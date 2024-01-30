// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webvify/core/app_cookie_manager.dart';
import 'package:webvify/widgets/secondary_loading_spinner.dart';

import '../consts.dart';
import '../extensions.dart';
import '../globals.dart';
import '../core/app_helper.dart';
import '../core/connection_status_listener.dart';
import '../core/permission_helper.dart';
import 'download_file_manager.dart';
import 'loading_spinner.dart';

class AppWebViewWidget extends StatefulWidget {
  const AppWebViewWidget({
    Key? key,
    required this.initialURL,
    required this.onWebViewCreated,
    this.onLoadStart,
    this.onLoadStop,
  }) : super(key: key);
  final String initialURL;
  final Function(InAppWebViewController) onWebViewCreated;
  final void Function(String?)? onLoadStart;
  final void Function(String?)? onLoadStop;
  @override
  AppWebViewWidgetState createState() => AppWebViewWidgetState();
}

class AppWebViewWidgetState extends State<AppWebViewWidget> {
  get isPullToRefreshActive => Globals.configuration.preferences.pullToRefresh;
  get isShowLoadingActive => Globals.configuration.loadingScreenModel.active;
  get autoFillActive => Globals.configuration.autoFillActive;
  late PullToRefreshController pullToRefreshController;

  int progress = 0;

  @override
  void initState() {
    debugPrint("AppWebViewWidgetState initState");
    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(
        color: Globals.configuration.primaryColor,
        backgroundColor: Globals.configuration.backgroundColor,
        enabled: isPullToRefreshActive,
      ),
      onRefresh: () async {
        var cont = (await Globals.inAppWebViewController.future);
        cont.reload();
      },
    );
    AppCookieManager()
      ..syncWithLocal()
      ..setEssentialCookies();
    super.initState();
  }

  @override
  void dispose() {
    debugPrint("AppWebViewWidgetState dispose");
    super.dispose();
  }

  void _download(String url) async {
    if (await PermissionHelper.lookStoragePermission()) {
      Directory? directory;
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }

      // Example download file url http://englishonlineclub.com/pdf/iOS%20Programming%20-%20The%20Big%20Nerd%20Ranch%20Guide%20(6th%20Edition)%20[EnglishOnlineClub.com].pdf
      await FlutterDownloader.enqueue(
        url: url,
        savedDir: directory!.path,
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: true,
      );
    } else {
      debugPrint('Permission Denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          resizeToAvoidBottomInset:
              Globals.configuration.preferences.resizeToAvoidBottomInset,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(
                bottom:
                    Globals.configuration.preferences.floatButtonBottomPadding),
            child: const DownloadFileManager(),
          ),
          body: InAppWebView(
              pullToRefreshController: pullToRefreshController,
              initialSettings: InAppWebViewSettings(
                underPageBackgroundColor: Globals.configuration.backgroundColor,
                useOnDownloadStart:
                    Globals.configuration.preferences.downloadEnabled,
                allowsInlineMediaPlayback:
                    Globals.configuration.preferences.allowsInlineMediaPlayback,
                userAgent: Globals.configuration.userAgent,
                useShouldOverrideUrlLoading: Globals
                    .configuration.preferences.useShouldOverrideUrlLoading,
                supportZoom: Globals.configuration.preferences.supportZoom,
                verticalScrollBarEnabled:
                    Globals.configuration.preferences.verticalScrollBarEnabled,
                horizontalScrollBarEnabled: Globals
                    .configuration.preferences.horizontalScrollBarEnabled,
                disableContextMenu:
                    Globals.configuration.preferences.disableContextMenu,
                mediaPlaybackRequiresUserGesture: Globals
                    .configuration.preferences.mediaPlaybackRequiresUserGesture,
                disableHorizontalScroll:
                    Globals.configuration.preferences.disableHorizontalScroll,
                disableVerticalScroll:
                    Globals.configuration.preferences.disableVerticalScroll,
                clearCache: Globals.configuration.preferences.clearCache,
                //disallowOverScroll: true,
                allowsLinkPreview:
                    Globals.configuration.preferences.iosAllowLinkPreview,
                disableLongPressContextMenuOnLinks: Globals.configuration
                    .preferences.iosDisableLongPressContextMenuOnLinks,
              ),
              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                return ServerTrustAuthResponse(
                    action: ServerTrustAuthResponseAction.PROCEED);
              },
              onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT);
              },
              onGeolocationPermissionsShowPrompt: (_, String origin) async {
                PermissionHelper.lookLocationPermission();
                return GeolocationPermissionShowPromptResponse(
                    allow: true, origin: origin, retain: true);
              },
              onDownloadStartRequest: (_, uri) {
                debugPrint("onDownloadStartRequest");
                _download(uri.url.toString());
              },
              shouldOverrideUrlLoading: (_, action) async {
                String url = action.request.url.toString();
                debugPrint("shouldOverrideUrlLoading $url");

                if (action.isForMainFrame) {
                  if (url.isInAppScheme) {
                    url.toLinkRedirector?.redirect();
                    return NavigationActionPolicy.CANCEL;
                  }
                  if (url.isExternalLink) {
                    AppHelper.launchURL(context, url);
                    return NavigationActionPolicy.CANCEL;
                  }
                }

                debugPrint("shouldOverrideUrlLoading Done");

                return NavigationActionPolicy.ALLOW;
              },
              initialUrlRequest: widget.initialURL.toUrlRequest,
              contextMenu: ContextMenu(
                settings: ContextMenuSettings(
                    hideDefaultSystemContextMenuItems: false),
              ),
              onWebViewCreated: (controller) {
                if (autoFillActive) {
                  controller.addJavaScriptHandler(
                      handlerName: "Username",
                      callback: (e) async {
                        if (e.isNotEmpty) {
                          String message = e[0].toString();
                          var preference =
                              await SharedPreferences.getInstance();
                          preference.setString(AppConsts.usernameKey, message);
                        }
                      });
                  controller.addJavaScriptHandler(
                      handlerName: "Password",
                      callback: (e) async {
                        if (e.isNotEmpty) {
                          String message = e[0].toString();
                          var preference =
                              await SharedPreferences.getInstance();
                          preference.setString(AppConsts.passwordKey, message);
                        }
                      });
                }
                controller.addJavaScriptHandler(
                    handlerName: "link_redirector",
                    callback: (url) async {
                      if (url.isNotEmpty) {
                        url[0].toString().toLinkRedirector?.redirect();
                      }
                    });
                widget.onWebViewCreated(controller);
              },
              onLoadStart: (controller, url) async {
                debugPrint("onLoadStart ${url.toString()}");
                widget.onLoadStart!(url?.toString());
              },
              onLoadStop: (_, url) {
                debugPrint("onLoadStop ${url.toString()}");
                loadStop(url?.toString());
              },
              onConsoleMessage: (controller, consoleMessage) {
                debugPrint(consoleMessage.message);
              },
              onProgressChanged: (controller, progress) async {
                if (Globals.configuration.loadingScreenModel.active) {
                  setState(() {
                    this.progress = progress;
                  });
                }
                loadCSS();
              }),
        ),
        progress < Globals.configuration.loadingScreenModel.hideLoadingScreenAt
            ? LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: Globals
                    .configuration.loadingScreenModel.secondaryBackgroundColor,
                color: Globals.configuration.loadingScreenModel.color,
              )
            : Container(),
      ],
    );
  }

  void loadCSS() async {
    var controller = await Globals.inAppWebViewController.future;
    final pref = Globals.configuration.preferences;

    await Future.wait([
      controller.injectCSSFileFromAsset(
        assetFilePath: AppConsts.indexCSSPath,
      ),
      pref.disableContextMenu
          ? controller.injectCSSFileFromAsset(
              assetFilePath: AppConsts.disableContextMenu,
            )
          : Future.value(),
      pref.cssUrl.isURL
          ? controller.injectCSSFileFromUrl(
              urlFile: WebUri.uri(Uri.parse(pref.cssUrl)),
            )
          : Future.value(),
      pref.cssCode.isNotEmpty
          ? controller.injectCSSCode(source: pref.cssCode)
          : Future.value(),
    ]);
  }

  Future<List<void>> loadJS() async {
    var controller = await Globals.inAppWebViewController.future;
    final pref = Globals.configuration.preferences;
    var preference = await SharedPreferences.getInstance();

    var username =
        preference.containsKey(AppConsts.usernameKey) && autoFillActive
            ? preference.getString(AppConsts.usernameKey)
            : "";
    var password =
        preference.containsKey(AppConsts.passwordKey) && autoFillActive
            ? preference.getString(AppConsts.passwordKey)
            : "";

    String jsDefinitions =
        "var username = '$username'; var password = '$password';  var doom_username = `${Globals.configuration.doomUsername}`; var doom_password = `${Globals.configuration.doomPassword}`; ";
    await controller.evaluateJavascript(source: jsDefinitions);

    return Future.wait([
      controller.injectJavascriptFileFromAsset(
          assetFilePath: AppConsts.indexJSPath),
      pref.javascriptUrl.isURL
          ? controller.injectJavascriptFileFromUrl(
              urlFile: WebUri.uri(Uri.parse(pref.javascriptUrl)),
            )
          : Future.value(),
      pref.javascriptCode.isNotEmpty
          ? controller.evaluateJavascript(source: pref.javascriptCode)
          : Future.value(),
    ]);
  }

  void loadStop(String? url) async {
    pullToRefreshController.endRefreshing();
    loadJS().whenComplete(
      () {
        widget.onLoadStop!(url);
        AppCookieManager().saveToLocal();
      },
    );
  }
}
