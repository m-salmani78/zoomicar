import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;
  final Duration duration;

  // ignore: use_key_in_widget_constructors
  const FadeAnimation(
      {required this.delay,
      required this.child,
      this.duration = const Duration(milliseconds: 500)});

  @override
  Widget build(BuildContext context) {
    final tween = TimelineTween<String>()
      ..addScene(
        begin: (delay * 1000).round().milliseconds,
        duration: duration,
        curve: Curves.easeOut,
      )
          .animate('opacity', tween: 0.0.tweenTo(1.0))
          .animate('translate', tween: (-30.0).tweenTo(0.0));

    return PlayAnimation<TimelineValue<String>>(
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: animation.get('opacity'),
        child: Transform.translate(
          offset: Offset(0, animation.get('translate')),
          child: child,
        ),
      ),
    );
  }
}
