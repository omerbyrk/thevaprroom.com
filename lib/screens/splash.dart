import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../extensions.dart';
import '../widgets/fade_animation.dart';
import 'screen_base.dart';

import '../globals.dart';
import '../core/app_helper.dart';

//com.webvify
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with ScreenBase {
  final String imageURL = tr("splash_image");
  final bool isFullscreen = true;

  @override
  void initState() {
    configure(context: context, fullscreen: true);
    navigateToHomeScreen();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isFullscreen ? fullScreenSplash : centeredSplash;
  }

  Widget get centeredSplash => Scaffold(
        backgroundColor: tr("splash_background").toColor,
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: SafeArea(
                    child: FadeAnimationWidget(
                      key: Key(imageURL),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: Image(
                          width: 250,
                          height: 250,
                          image: imageURL.toImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );

  Widget get fullScreenSplash => Scaffold(
        backgroundColor: tr("splash_background").toColor,
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FadeAnimationWidget(
            key: Key(imageURL),
            child: Image(
              image: imageURL.toImageProvider,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      );

  void navigateToHomeScreen() {
    Future.delayed(Duration(
            milliseconds: Globals.configuration.preferences.splashDelay))
        .then((value) {
      AppHelper.goLandingScreen();
    });
  }
}
