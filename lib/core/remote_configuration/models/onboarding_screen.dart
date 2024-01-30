import '../defaults.dart';

class OnboardingScreenModel {
  final bool active;
  final bool showOnEveryLaunch;
  final List<String> imageUrls;
  const OnboardingScreenModel({
    required this.active,
    required this.showOnEveryLaunch,
    required this.imageUrls,
  });

  factory OnboardingScreenModel.fromMap(Map map) {
    return OnboardingScreenModel(
        showOnEveryLaunch: (map["show_on_every_launch"] ??
            Defaults.onboarding.showOnEveryLaunch),
        imageUrls: ((map["image_urls"] ?? Defaults.onboarding.imageUrls)
                as List<dynamic>)
            .cast<String>(),
        active: (map["active"] ?? Defaults.onboarding.active));
  }

  Map<String, dynamic> toMap() => {
        "show_on_every_launch": showOnEveryLaunch,
        "image_urls": imageUrls,
        "active": active,
      };
}
