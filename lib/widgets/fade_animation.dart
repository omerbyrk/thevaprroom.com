import 'package:flutter/cupertino.dart';

class FadeAnimationWidget extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const FadeAnimationWidget({
    required Key key,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOut,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: duration,
        builder: (_, double doubleValue, Widget? argChild) {
          return Opacity(
            opacity: doubleValue,
            child: argChild,
          );
        },
        child: child);
  }
}
