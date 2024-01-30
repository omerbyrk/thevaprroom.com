import '../defaults.dart';

class LoginAutoFillModel {
  final bool active;
  final String usernameInputName;
  final String passwordInputName;
  const LoginAutoFillModel(
      {required this.usernameInputName,
      required this.passwordInputName,
      required this.active});

  factory LoginAutoFillModel.fromMap(Map map) {
    return LoginAutoFillModel(
      usernameInputName: map["username_htmlinput_name"] ??
          Defaults.loginAutoFill.usernameInputName,
      passwordInputName: map["password_htmlinput_name"] ??
          Defaults.loginAutoFill.passwordInputName,
      active: map["active"] ?? Defaults.loginAutoFill.active,
    );
  }

  Map<String, dynamic> toMap() => {
        "active": active,
        "username_htmlinput_name": usernameInputName,
        "password_htmlinput_name": passwordInputName,
      };
}
