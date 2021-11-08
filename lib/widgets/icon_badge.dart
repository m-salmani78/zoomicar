import 'package:flutter/material.dart';

class IconBadge extends StatelessWidget {
  final Widget icon;
  final int itemsNum;
  final GestureTapCallback? onPressed;
  // ignore: use_key_in_widget_constructors
  const IconBadge({required this.icon, this.onPressed, this.itemsNum = 0});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          icon,
          Positioned(
            top: -6,
            right: -6,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: (itemsNum == 0 ? 0 : 18),
              width: (itemsNum == 0 ? 0 : 18),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(
                    width: 2, color: Theme.of(context).scaffoldBackgroundColor),
              ),
              child: itemsNum == 0
                  ? null
                  : Center(
                      child: Text(
                        "$itemsNum",
                        style: const TextStyle(
                          fontSize: (11),
                          height: 1.4,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
