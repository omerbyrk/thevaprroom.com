// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webvify/core/permission_helper.dart';

import '../consts.dart';
import '../extensions.dart';
import '../globals.dart';
import '../main.dart';
import 'app_firebase_messaging.dart';

class AppHelper {
  static Future<void> loadUrlInWebview(String url) async {
    if (url.isEmpty || AppHelper.isLoginRequired) {
      return;
    }
    try {
      BuildContext context = await Globals.waitForBuildContext;

      if (ModalRoute.of(context)!.settings.name != AppConsts.homeWebviewRoute) {
        Navigator.of(context).pushReplacementNamed(AppConsts.homeWebviewRoute);
      }
    } catch (error, stack) {
      debugPrint(error.toString());
      debugPrint(stack.toString());
      AppHelper.alertError(error, stack);
    } finally {
      var controller = await Globals.inAppWebViewController.future;

      Future.delayed(Duration.zero,
          () => controller.loadUrl(urlRequest: url.toUrlRequest));
    }
  }

  static bool get isLoginRequired =>
      Globals.configuration.loginScreen.active &&
      Globals.configuration.loginScreen.forceToLogin &&
      FirebaseAuth.instance.currentUser == null;

  static goLandingScreen({BuildContext? context}) async {
    Navigator.of(context ?? await Globals.waitForBuildContext)
        .pushReplacementNamed(AppConsts.landingRoute);
  }

  static restartApp() => runRemoteConfigDependencies().then((value) async {
        Globals.inAppWebViewController = Completer<InAppWebViewController>();
        Phoenix.rebirth(await Globals.waitForBuildContext);
      });

  static Future<void> remoteChangesNotification(
      FirebaseNotificationModel firebaseNotificationModel) async {
    if (Globals.buildContext == null) {
      return;
    }

    var context = await Globals.waitForBuildContext;

    if (firebaseNotificationModel.forceToRestart ?? false) {
      restartApp();
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        title: firebaseNotificationModel.title,
        desc: firebaseNotificationModel.body,
        btnOkText: tr("restart"),
        btnCancelText: tr("cancel"),
        btnOkIcon: Icons.restart_alt,
        btnCancelIcon: Icons.close,
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          restartApp();
        },
      ).show();
    }
  }

  static void checkWebsiteVersion(BuildContext buildContext) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    int localVersion =
        sharedPreferences.getInt(AppConsts.websiteVersionKey) ?? 1;

    int configVersion = Globals.configuration.websiteVersion;

    if (configVersion > localVersion) {
      // clear cache!
      ScaffoldMessenger.of(buildContext).showSnackBar(
        SnackBar(
          content: Text(tr(
            "cache_cleaned",
          )),
        ).toStandart,
      );

      await (await Globals.inAppWebViewController.future).clearCache();
      await (await Globals.inAppWebViewController.future).reload();

      sharedPreferences.setInt(AppConsts.websiteVersionKey, configVersion);
    }
  }

  static void checkForcedPermission() async {
    var context = await Globals.waitForBuildContext;
    Future<void> showPermissionRequiredDialog(String message) async {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              title: Text(
                tr("permission_required"),
                style: TextStyle(color: Globals.configuration.primaryColor),
              ),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text(
                    tr("check_permission"),
                    style: const TextStyle(color: Colors.green),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    checkForcedPermission();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text(
                    tr("app_settings"),
                    style: TextStyle(color: Globals.configuration.primaryColor),
                  ),
                  onPressed: () async {
                    openAppSettings();
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    final preferences = Globals.configuration.preferences;
    var notificationSettings =
        await FirebaseMessaging.instance.requestPermission();

    if (preferences.notificationPermission &&
        preferences.forceNotificationPermission &&
        (notificationSettings.authorizationStatus !=
            AuthorizationStatus.authorized)) {
      return await showPermissionRequiredDialog(
        tr("notification_permission_required"),
      );
    }

    if (preferences.cameraPermission &&
        preferences.forceCameraPermission &&
        !(await Permission.camera.isGranted)) {
      return await showPermissionRequiredDialog(
          tr("camera_permission_required"));
    }

    if (preferences.locationPermission &&
        preferences.forceLocationPermission &&
        !(await PermissionHelper.lookLocationPermission())) {
      return await showPermissionRequiredDialog(
          tr("location_permission_required"));
    }

    if (preferences.microphonePermission &&
        preferences.forceMicrophonePermission &&
        !(await Permission.microphone.isGranted)) {
      return await showPermissionRequiredDialog(
          tr("microphone_permission_required"));
    }

    if (preferences.storagePermission &&
        preferences.forceStoragePermission &&
        !(await PermissionHelper.lookStoragePermission())) {
      return await showPermissionRequiredDialog(
          tr("storage_permission_required"));
    }
  }

  static bool hasBottomSpace(BuildContext context) =>
      MediaQuery.of(context).padding.bottom > 0;

  static double navigationBarHeight(BuildContext context) =>
      (65 + (hasBottomSpace(context) ? 20.0 : 8.0));

  static double controlBarHeight(BuildContext context) =>
      (40 + (hasBottomSpace(context) ? 12.0 : 0));

  static void launchURL(BuildContext context, String url) async {
    // ignore: deprecated_member_use
    if (await launch(url, forceSafariVC: false)) {
      return;
    } else if (url.isURL) {
      await ChromeSafariBrowser().open(url: WebUri.uri(Uri.parse(url)));
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr("app_is_not_installed"),
                ),
                const Divider(),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  url,
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  static alertError(
    dynamic error,
    StackTrace? stack,
  ) async {
    if (Globals.configuration.preferences.alertErrors) {
      var context = await Globals.waitForBuildContext;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(children: [
            Text(
              error.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              stack.toString(),
            )
          ]),
        ).toStandart,
      );
    }
  }

  static Timer? _statusTimer;

  static void fullscreen() {
    _cancelStatusbarTimer();
    notFullscreen(color: Colors.transparent);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.bottom]);
  }

  static void _cancelStatusbarTimer() {
    if (_statusTimer != null && _statusTimer!.isActive) {
      _statusTimer!.cancel();
    }
  }

  static void notFullscreen({Color? color, bool? useWhiteForeground}) {
    _cancelStatusbarTimer();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    _statusTimer =
        Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      try {
        await FlutterStatusbarcolor.setStatusBarColor(
          color ?? Globals.configuration.statusBarColor,
        );
        await FlutterStatusbarcolor.setStatusBarWhiteForeground(
            useWhiteForeground ??
                (Globals.configuration.statusBarBrigtness == Brightness.light));
      } catch (e) {
        _statusTimer!.cancel();
      }
    });
  }

  static Map<int, Color> getSwatch(Color color) {
    final hslColor = HSLColor.fromColor(color);
    final lightness = hslColor.lightness;

    /// if [500] is the default color, there are at LEAST five
    /// steps below [500]. (i.e. 400, 300, 200, 100, 50.) A
    /// divisor of 5 would mean [50] is a lightness of 1.0 or
    /// a color of #ffffff. A value of six would be near white
    /// but not quite.
    const lowDivisor = 6;

    /// if [500] is the default color, there are at LEAST four
    /// steps above [500]. A divisor of 4 would mean [900] is
    /// a lightness of 0.0 or color of #000000
    const highDivisor = 5;

    final lowStep = (1.0 - lightness) / lowDivisor;
    final highStep = lightness / highDivisor;

    return {
      50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
      100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
      200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
      300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
      400: (hslColor.withLightness(lightness + lowStep)).toColor(),
      500: (hslColor.withLightness(lightness)).toColor(),
      600: (hslColor.withLightness(lightness - highStep)).toColor(),
      700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
      800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
      900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
    };
  }
}
