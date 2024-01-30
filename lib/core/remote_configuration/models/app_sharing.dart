import '../defaults.dart';

class AppSharingModel {
  final bool active;
  final String androidShareText;
  final String iOSShareText;
  const AppSharingModel({
    required this.active,
    required this.androidShareText,
    required this.iOSShareText,
  });

  factory AppSharingModel.fromMap(Map map) {
    return AppSharingModel(
      active: map["active"] ?? Defaults.appSharing.active,
      androidShareText:
          map["android_share_text"] ?? Defaults.appSharing.androidShareText,
      iOSShareText: map["iOS_share_text"] ?? Defaults.appSharing.iOSShareText,
    );
  }

  Map<String, dynamic> toMap() => {
        "active": active,
        "android_share_text": androidShareText,
        "iOS_share_text": iOSShareText,
      };
}
