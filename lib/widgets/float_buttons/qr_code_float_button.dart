import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../../features/qr_code.dart';
import '../../globals.dart';
import 'float_button_base.dart';

class QRCodeButtonFloatButton extends StatelessWidget with FloatButtonBase {
  const QRCodeButtonFloatButton({Key? key}) : super(key: key);

  @override
  bool isActive() {
    return Globals.configuration.qrCodeModel.active;
  }

  @override
  Widget build(BuildContext context) {
    return isActive()
        ? FloatingActionButton.small(
            heroTag: "qr_code",
            backgroundColor: Globals.configuration.backgroundColor,
            onPressed: () async {
              QRCodeFeature().trigger();
            },
            child: Icon(
              FontAwesome.qrcode,
              color: Globals.configuration.primaryColor,
            ),
          )
        : const SizedBox(
            width: 0,
            height: 0,
          );
  }
}
