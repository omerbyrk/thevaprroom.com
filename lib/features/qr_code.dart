import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../consts.dart';
import '../core/remote_configuration/models/qr_code.dart';
import '../extensions.dart';
import '../globals.dart';
import 'feature.dart';

class QRCodeFeature extends Feature {
  QRCodeModel get qrConf => Globals.configuration.qrCodeModel;

  @override
  void trigger() async {
    ScanMode scanMode =
        qrConf.type == "qrcode" ? ScanMode.QR : ScanMode.BARCODE;
    String scanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ffffff", "Cancel", true, scanMode);
    if (scanResult == "-1") {
      return;
    }

    String redirectURL = qrConf.redirectingURL;

    redirectURL = redirectURL.replaceFirst(AppConsts.qrCodeKey, scanResult);

    (await Globals.inAppWebViewController.future)
        .loadUrl(urlRequest: redirectURL.toUrlRequest);
  }
}
