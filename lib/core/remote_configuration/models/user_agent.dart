import '../defaults.dart';

class UserAgentModel {
  final String android;
  final String iOS;
  const UserAgentModel({required this.android, required this.iOS});

  factory UserAgentModel.fromMap(Map map) {
    return UserAgentModel(
      android: map["android"] ?? Defaults.userAgent.android,
      iOS: map["ios"] ?? Defaults.userAgent.iOS,
    );
  }

  Map<String, dynamic> toMap() => {
        "android": android,
        "iOS": iOS,
      };
}
