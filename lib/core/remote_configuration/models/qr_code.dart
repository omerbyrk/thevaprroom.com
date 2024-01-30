import '../defaults.dart';

class QRCodeModel {
  final bool active;
  final String redirectingURL;
  final String type;

  const QRCodeModel(
      {required this.redirectingURL, required this.active, required this.type});

  factory QRCodeModel.fromMap(Map map) {
    return QRCodeModel(
      redirectingURL: map["redirect_url"] ?? Defaults.qrCode.redirectingURL,
      active: map["active"] ?? Defaults.qrCode.active,
      type: map["type"] ?? Defaults.qrCode.type,
    );
  }

  Map<String, dynamic> toMap() =>
      {"active": active, "redirect_url": redirectingURL, "type": type};
}
