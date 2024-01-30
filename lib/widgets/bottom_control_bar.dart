import 'package:flutter/material.dart';

import '../core/app_helper.dart';
import '../globals.dart';

class BottomControlBarWidget extends StatelessWidget {
  const BottomControlBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bottomControlConf = Globals.configuration.bottomControlBarModel;
    return bottomControlConf.active
        ? Container(
            height: AppHelper.controlBarHeight(context),
            decoration: BoxDecoration(
              color: bottomControlConf.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffFBFBFB).withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 3,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: kBottomNavigationBarHeight,
                child: Row(
                  children: [
                    const SizedBox(width: 24),
                    InkWell(
                      onTap: () async {
                        (await Globals.goBackFunction.future)();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: bottomControlConf.iconColor,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 48),
                    InkWell(
                      onTap: () async {
                        if (await (await Globals.inAppWebViewController.future)
                            .canGoForward()) {
                          (await Globals.inAppWebViewController.future)
                              .goForward();
                        }
                      },
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: bottomControlConf.iconColor,
                        size: 25,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () async {
                        (await Globals.inAppWebViewController.future).reload();
                      },
                      child: Icon(
                        Icons.refresh,
                        color: bottomControlConf.iconColor,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox(
            height: 0,
            width: 0,
          );
  }
}
