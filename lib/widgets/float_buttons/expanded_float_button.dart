import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import '../../globals.dart';
import 'account_float_button.dart';
import 'app_sharing_float_button.dart';
import 'float_button_base.dart';
import 'go_home_float_button.dart';
import 'qr_code_float_button.dart';

class ExpandableFloatButton extends StatefulWidget {
  const ExpandableFloatButton({super.key});

  @override
  State<ExpandableFloatButton> createState() => _ExpandableFloatButtonState();
}

//const DownloadFileFloatButton(),
class _ExpandableFloatButtonState extends State<ExpandableFloatButton> {
  // En alttaki buton en yukarda olacak
  final _floatButtons = const <FloatButtonBase>[
    AccountFloatButton(),
    AppSharingFloatButton(),
    QRCodeButtonFloatButton(),
    GoHomeFloatButton(),
  ];
  final _children = <StatelessWidget>[];

  @override
  void initState() {
    for (var floatButton in _floatButtons) {
      if (floatButton.isActive()) {
        _children.add(floatButton as StatelessWidget);
      }
    }
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _children.isEmpty
        ? const SizedBox(
            height: 0,
            width: 0,
          )
        : ExpandableFab(
            type: ExpandableFabType.up,
            distance: 75,
            initialOpen:
                Globals.configuration.preferences.expandableButtonInitialOpen,
            backgroundColor: Globals.configuration.backgroundColor,
            foregroundColor: Globals.configuration.primaryColor,
            children: _children,
          );
  }
}
