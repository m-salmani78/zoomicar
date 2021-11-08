import 'package:flutter/material.dart';

import '../splash_screen.dart';

class SplashFooterScreen extends StatelessWidget {
  final int currentPage;
  final VoidCallback? onClickNext, onClickSkip;

  // ignore: use_key_in_widget_constructors
  const SplashFooterScreen({
    required this.currentPage,
    this.onClickNext,
    this.onClickSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(onPressed: onClickSkip, child: const Text('پرش')),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            splashData.length,
            (index) => _buildDot(context, index),
          ),
        ),
        const Spacer(),
        TextButton(onPressed: onClickNext, child: const Text('بعدی')),
      ],
    );
  }

  AnimatedContainer _buildDot(BuildContext context, int index) {
    Color activeColor = Theme.of(context).colorScheme.primary;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 18 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? activeColor : const Color(0xFFCCCCCC),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
