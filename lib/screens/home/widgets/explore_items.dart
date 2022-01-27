import 'package:flutter/material.dart';
import 'package:zoomicar/models/problem_model.dart';
import 'package:zoomicar/widgets/problem_card_view.dart';

class ExploreItems extends StatelessWidget {
  final String name;
  final VoidCallback? onPressedViewAll;
  final List<Problem> problems;
  const ExploreItems(
      {Key? key,
      required this.name,
      this.onPressedViewAll,
      required this.problems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    problems.sort((a, b) {
      return b.percent.compareTo(a.percent);
    });
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
                onPressed: onPressedViewAll,
              ),
            ],
          ),
        ),
        problems.isEmpty
            ? Container(
                height: 200,
                color: Theme.of(context).colorScheme.primary.withOpacity(.01),
                child: Center(
                    child: Text(
                  'موردی برای نمایش وجود ندارد',
                  style: Theme.of(context).textTheme.caption,
                )),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(4),
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: problems
                        .map((e) => ProblemCardView(problem: e))
                        .toList()),
              ),
      ],
    );
  }
}
