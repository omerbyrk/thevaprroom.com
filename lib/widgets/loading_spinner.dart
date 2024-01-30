import 'package:flutter/material.dart';
import '../extensions.dart';

import '../globals.dart';

class LoadingSpinnerWidget extends StatelessWidget {
  const LoadingSpinnerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Globals.configuration.loadingScreenModel.secondaryBackgroundColor,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              height: 40,
              width: 40,
              child: Image(
                image: Globals.configuration.loadingScreenModel
                    .loadingSpinnerUrl.toImageProvider,
                color: Globals.configuration.loadingScreenModel.color,
                width: 40,
                height: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
