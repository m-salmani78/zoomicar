import 'package:flutter/material.dart';

class CircularPercentIndicator extends StatelessWidget {
  final double lineWidth;

  final double percent;

  final Color progressColor;

  final Widget center;

  final double radius;

  const CircularPercentIndicator(
      {Key? key,
      required this.lineWidth,
      required this.percent,
      required this.progressColor,
      required this.center,
      required this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: radius,
          width: radius,
          child: CircularProgressIndicator(
            strokeWidth: lineWidth,
            value: percent,
            color: progressColor,
          ),
        ),
        Center(
          child: center,
        )
      ],
    );
  }
}
