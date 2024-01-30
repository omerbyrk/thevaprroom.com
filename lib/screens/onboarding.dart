import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../consts.dart';
import '../core/app_helper.dart';
import '../extensions.dart';
import '../globals.dart';
import 'screen_base.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> with ScreenBase {
  final PageController _pageController = PageController();
  var onBoardingScreenProps = Globals.configuration.onboardingScreenModel;
  int _currentPage = 0;

  @override
  void initState() {
    configure(context: context, fullscreen: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Globals.configuration.loadingScreenModel.secondaryBackgroundColor,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox(
            child: PageView(
              onPageChanged: (index) {
                _currentPage = index;
                setState(() {});
              },
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              children: Globals.configuration.onboardingScreenModel.imageUrls
                  .map<Widget>((imageUrl) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: imageUrl.toImageProvider,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      _goLandingScreen();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Globals.configuration.backgroundColor
                            .withOpacity(.95),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tr("skip"),
                        style: TextStyle(
                          color: Globals.configuration.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      if (_isLastPage) {
                        _goLandingScreen();
                        return;
                      }
                      _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);

                      setState(() {});
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Globals.configuration.backgroundColor
                              .withOpacity(.95),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _isLastPage ? tr("done") : tr("next"),
                          style: TextStyle(
                            color: Globals.configuration.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _isLastPage =>
      _currentPage == onBoardingScreenProps.imageUrls.length - 1;

  Future<void> _goLandingScreen() async {
    (await SharedPreferences.getInstance())
        .setBool(AppConsts.onboardingKey, true);
    AppHelper.goLandingScreen();
  }
}
