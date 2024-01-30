import 'package:in_app_review/in_app_review.dart';

import 'feature.dart';

class InAppReviewFeature extends Feature {
  @override
  void trigger() {
    InAppReview.instance.requestReview();
  }
}
