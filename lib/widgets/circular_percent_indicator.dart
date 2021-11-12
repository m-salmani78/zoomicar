import 'package:flutter/material.dart';

class CircularPercentIndicator extends StatelessWidget {
  final double lineWidth;

  final double percent;

  final Color progressColor;

  final Widget child;

  final double radius;

  const CircularPercentIndicator(
      {Key? key,
      required this.lineWidth,
      required this.percent,
      required this.progressColor,
      required this.child,
      required this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      margin: EdgeInsets.all(lineWidth / 2),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: CircularProgressIndicator(
              strokeWidth: lineWidth,
              value: percent,
              color: progressColor,
            ),
          ),
          Container(
            constraints: const BoxConstraints.expand(),
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(lineWidth / 2),
            padding: EdgeInsets.all(radius * 0.1),
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: child,
          )
        ],
      ),
    );
  }
}
