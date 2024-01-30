import 'package:flutter/cupertino.dart';

class AppVerticalFadeAnimationWidget extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool downToUp;

  const AppVerticalFadeAnimationWidget(
      {required Key key,
      this.duration = const Duration(seconds: 1),
      this.curve = Curves.easeOut,
      required this.child,
      this.downToUp = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: duration,
        curve: curve,
        builder: (_, double doubleValue, Widget? argChild) {
          return Transform.translate(
              offset:
                  Offset(0.0, (doubleValue - 1) * ((downToUp ? -1 : 1) * 50)),
              child: Opacity(
                opacity: doubleValue,
                child: argChild,
              ));
        },
        child: child);
  }
}
