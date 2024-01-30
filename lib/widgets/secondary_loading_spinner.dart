import 'package:flutter/material.dart';
import '../extensions.dart';

import '../globals.dart';

class SecondaryLoadingSpinnerWidget extends StatelessWidget {
  const SecondaryLoadingSpinnerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Globals.configuration.loadingScreenModel.backgroundColor,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Center(
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Globals.configuration.loadingScreenModel
                      .secondaryBackgroundColor),
              child: Center(
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
            ),
          ),
        ],
      ),
    );
  }
}
