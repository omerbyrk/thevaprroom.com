import '../defaults.dart';
import 'dart:io';

class PreferencesModel {
  final bool addFirebaseTokenToInitialLink;
  final bool addLoginUserIdInitialLink;
  final bool appTrackingTransparency;
  final bool downloadEnabled;
  final bool alertErrors;
  final bool useShouldOverrideUrlLoading;
  final bool androidResizeToAvoidBottomInset;
  final bool iOSResizeToAvoidBottomInset;
  final bool pullToRefresh;
  final bool appUpgrader;
  final bool verticalOrientations;
  final bool notificationPermission;
  final bool forceNotificationPermission;
  final bool cameraPermission;
  final bool forceCameraPermission;
  final bool locationPermission;
  final bool forceLocationPermission;
  final bool microphonePermission;
  final bool forceMicrophonePermission;
  final bool storagePermission;
  final bool forceStoragePermission;
  final bool supportZoom;
  final bool verticalScrollBarEnabled;
  final bool horizontalScrollBarEnabled;
  final bool disableVerticalScroll;
  final bool disableHorizontalScroll;

  final bool mediaPlaybackRequiresUserGesture;
  final bool allowsInlineMediaPlayback;
  final bool disableContextMenu;
  final bool iosAllowLinkPreview;
  final bool iosDisableLongPressContextMenuOnLinks;

  final bool pageNotFoundErrorScreen;
  final bool errorScreen;

  final bool clearCache;

  final bool expandableButtonInitialOpen;

  final int splashDelay;
  final double floatButtonBottomPadding;
  final String javascriptUrl;
  final String cssUrl;
  final String javascriptCode;
  final String cssCode;

  const PreferencesModel({
    required this.floatButtonBottomPadding,
    required this.appTrackingTransparency,
    required this.mediaPlaybackRequiresUserGesture,
    required this.disableContextMenu,
    required this.useShouldOverrideUrlLoading,
    required this.alertErrors,
    required this.notificationPermission,
    required this.forceNotificationPermission,
    required this.forceCameraPermission,
    required this.forceLocationPermission,
    required this.forceMicrophonePermission,
    required this.forceStoragePermission,
    required this.pageNotFoundErrorScreen,
    required this.androidResizeToAvoidBottomInset,
    required this.iOSResizeToAvoidBottomInset,
    required this.microphonePermission,
    required this.downloadEnabled,
    required this.errorScreen,
    required this.iosAllowLinkPreview,
    required this.iosDisableLongPressContextMenuOnLinks,
    required this.splashDelay,
    required this.javascriptUrl,
    required this.allowsInlineMediaPlayback,
    required this.cssUrl,
    required this.addFirebaseTokenToInitialLink,
    required this.addLoginUserIdInitialLink,
    required this.pullToRefresh,
    required this.appUpgrader,
    required this.expandableButtonInitialOpen,
    required this.verticalOrientations,
    required this.locationPermission,
    required this.cameraPermission,
    required this.storagePermission,
    required this.supportZoom,
    required this.verticalScrollBarEnabled,
    required this.horizontalScrollBarEnabled,
    required this.disableHorizontalScroll,
    required this.disableVerticalScroll,
    required this.clearCache,
    required this.cssCode,
    required this.javascriptCode,
  });

  bool get resizeToAvoidBottomInset => Platform.isIOS
      ? iOSResizeToAvoidBottomInset
      : androidResizeToAvoidBottomInset;

  factory PreferencesModel.fromMap(Map map) {
    return PreferencesModel(
      addFirebaseTokenToInitialLink: map["add_firebase_token_to_initial_url"] ??
          Defaults.preferences.addFirebaseTokenToInitialLink,
      appTrackingTransparency: map["app_tracking_transparency"] ??
          Defaults.preferences.appTrackingTransparency,
      alertErrors: map["alert_errors"] ?? Defaults.preferences.alertErrors,
      useShouldOverrideUrlLoading: map["use_should_override_url_loading"] ??
          Defaults.preferences.useShouldOverrideUrlLoading,
      addLoginUserIdInitialLink: map["add_login_user_id_initial_url"] ??
          Defaults.preferences.addLoginUserIdInitialLink,
      downloadEnabled:
          map["download_enabled"] ?? Defaults.preferences.downloadEnabled,
      androidResizeToAvoidBottomInset:
          map["android_resize_to_avoid_bottom_inset"] ??
              Defaults.preferences.androidResizeToAvoidBottomInset,
      iOSResizeToAvoidBottomInset: map["iOS_resize_to_avoid_bottom_inset"] ??
          Defaults.preferences.iOSResizeToAvoidBottomInset,
      pullToRefresh:
          map["pull_to_refresh"] ?? Defaults.preferences.pullToRefresh,
      appUpgrader: map["app_upgrader"] ?? Defaults.preferences.appUpgrader,
      verticalOrientations: map["vertical_orientations"] ??
          Defaults.preferences.verticalOrientations,
      locationPermission:
          map["location_permission"] ?? Defaults.preferences.locationPermission,
      cameraPermission:
          map["camera_permission"] ?? Defaults.preferences.microphonePermission,
      microphonePermission: map["microphone_permission"] ??
          Defaults.preferences.microphonePermission,
      storagePermission:
          map["storage_permission"] ?? Defaults.preferences.storagePermission,
      horizontalScrollBarEnabled: map["horizontal_scroll_bar_enabled"] ??
          Defaults.preferences.horizontalScrollBarEnabled,
      supportZoom: map["support_zoom"] ?? Defaults.preferences.supportZoom,
      verticalScrollBarEnabled: map["vertical_scroll_bar_enabled"] ??
          Defaults.preferences.verticalScrollBarEnabled,
      disableHorizontalScroll: map["disable_horizontal_scroll"] ??
          Defaults.preferences.disableHorizontalScroll,
      disableVerticalScroll: map["disable_vertical_scroll"] ??
          Defaults.preferences.disableVerticalScroll,
      mediaPlaybackRequiresUserGesture:
          map["media_playback_requires_user_gesture"] ??
              Defaults.preferences.mediaPlaybackRequiresUserGesture,
      allowsInlineMediaPlayback: map["allows_inline_media_playback"] ??
          Defaults.preferences.allowsInlineMediaPlayback,
      disableContextMenu: map["disable_context_menu"] ??
          Defaults.preferences.disableContextMenu,
      iosAllowLinkPreview: map["ios_allow_link_preview"] ??
          Defaults.preferences.iosAllowLinkPreview,
      iosDisableLongPressContextMenuOnLinks:
          map["ios_disable_long_press_context_menu_on_links"] ??
              Defaults.preferences.iosDisableLongPressContextMenuOnLinks,
      pageNotFoundErrorScreen: map["page_not_found_error_screen"] ??
          Defaults.preferences.pageNotFoundErrorScreen,
      expandableButtonInitialOpen: map["expandable_button_initial_open"] ??
          Defaults.preferences.expandableButtonInitialOpen,
      errorScreen: map["error_screen"] ?? Defaults.preferences.errorScreen,
      splashDelay: map["splash_delay"] ?? Defaults.preferences.splashDelay,
      javascriptUrl: map["javascript_url"] != ""
          ? map["javascript_url"]
          : Defaults.preferences.javascriptUrl,
      cssUrl:
          map["css_url"] != "" ? map["css_url"] : Defaults.preferences.cssUrl,
      javascriptCode:
          map["javascript_code"] ?? Defaults.preferences.javascriptCode,
      cssCode: map["css_code"] ?? Defaults.preferences.cssCode,
      clearCache: map["clear_cache"] ?? Defaults.preferences.clearCache,
      notificationPermission: map["notification_permission"] ??
          Defaults.preferences.notificationPermission,
      forceCameraPermission: map["force_camera_permission"] ??
          Defaults.preferences.forceCameraPermission,
      forceLocationPermission: map["force_location_permission"] ??
          Defaults.preferences.forceLocationPermission,
      forceMicrophonePermission: map["force_microphone_permission"] ??
          Defaults.preferences.forceMicrophonePermission,
      forceNotificationPermission: map["force_notification_permission"] ??
          Defaults.preferences.forceNotificationPermission,
      forceStoragePermission: map["force_storage_permission"] ??
          Defaults.preferences.forceStoragePermission,
      floatButtonBottomPadding: (map["float_button_bottom_padding"] ??
              Defaults.preferences.floatButtonBottomPadding as int)
          .toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        "add_firebase_token_to_initial_url": addFirebaseTokenToInitialLink,
        "alert_errors": alertErrors,
        "add_login_user_id_initial_url": addLoginUserIdInitialLink,
        "android_resize_to_avoid_bottom_inset": androidResizeToAvoidBottomInset,
        "iOS_resize_to_avoid_bottom_inset": iOSResizeToAvoidBottomInset,
        "app_tracking_transparency": appTrackingTransparency,
        "pull_to_refresh": pullToRefresh,
        "app_upgrader": appUpgrader,
        "vertical_orientations": verticalOrientations,
        "location_permission": locationPermission,
        "camera_permission": cameraPermission,
        "storage_permission": storagePermission,
        "microphone_permission": microphonePermission,
        "vertical_scroll_bar_enabled": verticalScrollBarEnabled,
        "support_zoom": supportZoom,
        "horizontal_scroll_bar_enabled": horizontalScrollBarEnabled,
        "media_playback_requires_user_gesture":
            mediaPlaybackRequiresUserGesture,
        "allows_inline_media_playback": allowsInlineMediaPlayback,
        "disable_context_menu": disableContextMenu,
        "ios_allow_link_preview": iosAllowLinkPreview,
        "ios_disable_long_press_context_menu_on_links":
            iosDisableLongPressContextMenuOnLinks,
        "splash_delay": splashDelay,
        "javascript_url": javascriptUrl == Defaults.preferences.javascriptUrl
            ? ""
            : javascriptUrl,
        "css_url": cssUrl == Defaults.preferences.cssUrl ? "" : cssUrl,
        "expandable_button_initial_open": expandableButtonInitialOpen,
        "css_code": cssCode,
        "javascript_code": javascriptCode,
        "notification_permission": notificationPermission,
        "force_notification_permission": forceNotificationPermission,
        "force_location_permission": forceLocationPermission,
        "force_camera_permission": forceCameraPermission,
        "force_storage_permission": forceStoragePermission,
        "force_microphone_permission": forceMicrophonePermission,
        "float_button_bottom_padding": floatButtonBottomPadding,
        "use_should_override_url_loading": useShouldOverrideUrlLoading,
        "download_enabled": useShouldOverrideUrlLoading,
      };
}
