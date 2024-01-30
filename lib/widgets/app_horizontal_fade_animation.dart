import 'package:flutter/cupertino.dart';

class AppHorizontalFadeAnimationWidget extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool leftToRight;

  const AppHorizontalFadeAnimationWidget(
      {required Key key,
      this.duration = const Duration(seconds: 1),
      this.curve = Curves.easeOut,
      required this.child,
      this.leftToRight = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: duration,
        curve: curve,
        builder: (_, double doubleValue, Widget? argChild) {
          return Transform.translate(
              offset: Offset(
                  (doubleValue - 1) * ((leftToRight ? -1 : 1) * 50), 0.0),
              child: Opacity(
                opacity: doubleValue,
                child: argChild,
              ));
        },
        child: child);
  }
}
