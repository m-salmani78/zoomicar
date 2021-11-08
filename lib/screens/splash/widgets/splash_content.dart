import 'package:flutter/material.dart';

class SplashContent extends StatelessWidget {
  final Map<String, String> splashData;

  // ignore: use_key_in_widget_constructors
  const SplashContent(this.splashData);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Image.asset(
            splashData['image'] ?? '',
            height: MediaQuery.of(context).size.height / 3,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
          child: Text(
            splashData['description'] ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
