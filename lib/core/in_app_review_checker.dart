import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../consts.dart';
import '../globals.dart';

class InAppReviewChecker {
  static final InAppReview inAppReview = InAppReview.instance;

  static void check() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.containsKey(AppConsts.appReviewDateKey)) {
      DateTime lastSeen =
          DateTime.parse(preferences.getString(AppConsts.appReviewDateKey)!);
      if (DateTime.now().difference(lastSeen).inDays >
          Globals.configuration.appRatingModel.delayDay) {
        _show(preferences);
      }
    } else {
      _show(preferences);
    }
  }

  static void _show(SharedPreferences preferences) {
    Future.delayed(const Duration(seconds: 2), () async {
      inAppReview.requestReview().then((onValue) {
        preferences.setString(
            AppConsts.appReviewDateKey, DateTime.now().toIso8601String());
      });
    });
  }
}
