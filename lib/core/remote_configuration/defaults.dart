import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'models/app_url_rules.dart';
import 'models/shopping.dart';

import '../../shopping/model/product.dart';
import 'models/app_bar.dart';
import 'models/app_rating.dart';
import 'models/app_sharing.dart';
import 'models/bottom_control_bar.dart';
import 'models/bottom_navigation_bar.dart';
import 'models/home.dart';
import 'models/loading_screen.dart';
import 'models/localization.dart';
import 'models/login.dart';
import 'models/login_auto_fill.dart';
import 'models/mobile_ads.dart';
import 'models/onboarding_screen.dart';
import 'models/preferences.dart';
import 'models/qr_code.dart';
import 'models/status_bar.dart';
import 'models/user_agent.dart';

class Defaults {
  static const int version = 1;
  static const String initialLink = "https://admin.webvify.app";
  static const String primaryColor = "#1CAFBF";
  static const String backgroundColor = "#283184";

  static const List<String> inAppLinks = [];
  static const List<String> cookies = [];
  static const List<String> ignoreErrorCodes = [];

  static const StatusBarModel statusBar = StatusBarModel(
    backgroundColor: Color(0xFF283184),
    brightness: Brightness.light,
  );

  static const LoadingScreenModel loading = LoadingScreenModel(
    loadingSpinnerUrl: "assets/images/loading.gif",
    active: true,
    backgroundColor: Color(0xff283184),
    secondaryBackgroundColor: Color(0xff283184),
    color: Color(0xff1CAFBF),
    hideLoadingScreenAt: 50,
  );

  static const OnboardingScreenModel onboarding = OnboardingScreenModel(
      active: false, showOnEveryLaunch: false, imageUrls: []);

  static const LoginAutoFillModel loginAutoFill = LoginAutoFillModel(
    active: true,
    usernameInputName: "username",
    passwordInputName: "password",
  );

  static const QRCodeModel qrCode = QRCodeModel(
    active: false,
    redirectingURL: "https://admin.webvify.app?qr_code={{QR_CODE}}",
    type: "qrcode",
  );

  static const BottomControlBarModel bottomControlBar = BottomControlBarModel(
    backgroundColor: Colors.white54,
    active: false,
    iconColor: Colors.black,
  );

  static const AppBarModel appBar = AppBarModel(
    active: false,
    defaultTitle: "default_title",
    keepDefault: true,
    backgroundColor: Color(0xff1CAFBF),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  );

  static const AppRatingModel appRating = AppRatingModel(
    active: true,
    delayTime: 60,
    delayDay: 7,
  );

  static const AppSharingModel appSharing = AppSharingModel(
      active: true,
      androidShareText: "https://webvify.app",
      iOSShareText: "https://webvify.app");

  static const UserAgentModel userAgent = UserAgentModel(
    android:
        "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36 [FB_IAB/FB4A;FBAV/294.0.0.39.118;] android_mobile_app",
    iOS:
        "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36 [FB_IAB/FB4A;FBAV/294.0.0.39.118;] ios_mobile_app",
  );

  static const AppURLRule urlRule = AppURLRule(url: "*", rule: "out", index: 3);

  static const PreferencesModel preferences = PreferencesModel(
    addFirebaseTokenToInitialLink: false,
    alertErrors: false,
    addLoginUserIdInitialLink: false,
    appTrackingTransparency: false,
    useShouldOverrideUrlLoading: true,
    androidResizeToAvoidBottomInset: false,
    iOSResizeToAvoidBottomInset: false,
    pullToRefresh: true,
    appUpgrader: true,
    verticalOrientations: true,
    locationPermission: false,
    downloadEnabled: true,
    cameraPermission: false,
    storagePermission: false,
    microphonePermission: false,
    supportZoom: true,
    verticalScrollBarEnabled: false,
    expandableButtonInitialOpen: false,
    horizontalScrollBarEnabled: false,
    disableHorizontalScroll: false,
    disableVerticalScroll: false,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: false,
    disableContextMenu: true,
    iosAllowLinkPreview: false,
    iosDisableLongPressContextMenuOnLinks: true,
    clearCache: false,
    pageNotFoundErrorScreen: true,
    errorScreen: true,
    splashDelay: 0,
    javascriptUrl: "",
    cssUrl: "",
    javascriptCode: "",
    cssCode: "",
    forceCameraPermission: false,
    forceLocationPermission: false,
    forceMicrophonePermission: false,
    forceNotificationPermission: false,
    forceStoragePermission: false,
    notificationPermission: true,
    floatButtonBottomPadding: 0,
  );

  // Bottom navigation bar
  static const BottomNavigationBarModel bottomNavigationBar =
      BottomNavigationBarModel(
    active: false,
    style: NavBarStyle.style16,
    initialIndex: 2,
    backgroundColor: Color(0xff283184),
    listenWebview: false,
    hideOnThisLinks: [],
    navbarItems: [
      NavbarItemProps(
        scrollToTop: true,
        iconData: Icons.error,
        title: "unset",
        javascript:
            "alert('not set url or javascript, please check the configuration of app')",
        inactiveColorPrimary: Color(0xff333333),
        activeColorPrimary: Color(0xff1CAFBF),
        activeColorSecondary: Color(0xff1CAFBF),
        inactiveColorSecondary: Color(0xff333333),
      )
    ],
  );

  // mobile ads

  static const MobileAds mobileAds = MobileAds(
      active: false,
      keywords: [],
      nonPersonalizedAds: false,
      appOpenAds: AppOpenAds(
          active: false,
          iOSAddId: "ca-app-pub-3940256099942544/5662855259",
          androidAddId: "ca-app-pub-3940256099942544/3419835294",
          maxCacheDuration: 60),
      bannerAds: BannerAds(
          active: false,
          androidAddId: "ca-app-pub-3940256099942544/6300978111",
          iOSAddId: "ca-app-pub-3940256099942544/2934735716",
          location: BannerAdLocation.none),
      interstitialAds: InterstitialAds(
          active: false,
          iOSAddId: "ca-app-pub-3940256099942544/1033173712",
          androidAddId: "ca-app-pub-3940256099942544/1033173712",
          intervalDuration: 0,
          showClickOnBottomNavBar: false));

  static const Localization localizations = Localization(
    defaultLocale_: "en",
    supportedLocales_: ["en"],
    translations_: {},
  );

  // Home Screen
  static const bool homeActive = false;
  static const bool homeGoHomeFloatButton = false;
  static const bool homeStatusBar = false;
  static const String homeBackgroundUrl = "";
  static const LogoField homeLogoField = LogoField(
    location: "top_center",
    padding: EdgeInsets.zero,
    size: Size.zero,
    url: "",
  );
  static const ButtonField homeButtonField = ButtonField(
    location: "top_center",
    padding: EdgeInsets.zero,
    size: Size.zero,
    horizontalButtonCount: 1,
    horizontalButtonSpacing: 1,
    verticalButtonSpacing: 1,
    buttonAspectRatio: 1,
    buttons: [
      HomeButton(
        title: "Title",
        url: initialLink,
        backgroundColor: Color(0x283184FF),
        foregroundColor: Color(0xff1CAFBF),
        iconSpacing: 8.0,
        iconData: Icons.error,
      )
    ],
  );

  // Login Model
  static const LoginScreenModel loginModel = LoginScreenModel(
    active: false,
    forceToLogin: true,
    accountFloatButton: true,
    disableRegister: false,
    disableGoHomeButton: false,
    brightness: Brightness.dark,
    backgroundColor: Colors.white,
    linkColor: Colors.blue,
    logoField: LoginLogoField(
      url: "assets/build/ios_icon/ios_icon.png",
      width: 200,
      height: 200,
    ),
  );

  static ShoppingModel shoppingModel = ShoppingModel(
    priceUnit: "\$",
    products: [
      Product(
        id: 'p1',
        title: 'Red Shirt',
        description: 'A red shirt - it is pretty red!',
        price: 29.99,
        imageUrl:
            'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      ),
      Product(
        id: 'p2',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
      ),
      Product(
        id: 'p3',
        title: 'Yellow Scarf',
        description: 'Warm and cozy - exactly what you need for the winter.',
        price: 19.99,
        imageUrl:
            'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
      ),
      Product(
        id: 'p4',
        title: 'A Pan',
        description: 'Prepare any meal you want.',
        price: 49.99,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
      ),
    ],
  );
}
