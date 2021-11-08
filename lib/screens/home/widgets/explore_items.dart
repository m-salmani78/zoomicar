import 'package:flutter/material.dart';

class ExploreItems extends StatelessWidget {
  final String name;
  final VoidCallback? onPressedViewAll;
  final List<Widget> children;
  const ExploreItems(
      {Key? key,
      required this.name,
      this.onPressedViewAll,
      required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                child: const Text('همه'),
                // child: Text('View All'),
                onPressed: onPressedViewAll,
              ),
            ],
          ),
        ),
        children.isEmpty
            ? Container(
                height: 200,
                color: Theme.of(context).colorScheme.primary.withOpacity(.02),
                child: const Center(
                    child: Text(
                  'موردی برای نمایش وجود ندارد',
                  // 'nothing to show',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(4),
                scrollDirection: Axis.horizontal,
                child: Row(children: children),
              ),
      ],
    );
  }
}
