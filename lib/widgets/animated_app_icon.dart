import 'package:flutter/material.dart';

class AnimatedAppIconWidget extends StatefulWidget {
  const AnimatedAppIconWidget({
    Key? key,
    this.height = 200,
    this.width = 200,
    this.radius = 360,
    this.assetName = "app_icon",
  }) : super(key: key);

  final int height;
  final int width;
  final double radius;
  final String assetName;

  @override
  AnimatedAppIconWidgetState createState() => AnimatedAppIconWidgetState();
}

class AnimatedAppIconWidgetState extends State<AnimatedAppIconWidget> {
  double _height = 1;
  double _width = 1;

  @override
  void initState() {
    runAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: _width,
      height: _height,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.elasticOut,
      child: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.radius),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(
                'assets/images/app_signature.gif',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void runAnimation() async {
    await Future.delayed(const Duration(milliseconds: 250));
    setState(() {
      _height = widget.height.toDouble();
      _width = widget.width.toDouble();
    });
  }
}
