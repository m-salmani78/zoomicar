import 'package:flutter/material.dart';
import '/constants/app_constants.dart';
import '/models/problem_model.dart';
import '/screens/problem/problem_screen.dart';
import '/widgets/status_label.dart';

class ProblemCardView extends StatelessWidget {
  final Problem problem;
  // ignore: use_key_in_widget_constructors
  const ProblemCardView({required this.problem});

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220, minHeight: 200),
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProblemScreen(problem: problem),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: problem.hashCode,
                      child: Image.asset(
                        problem.imageAssetAddress,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/images/ic-engine-oil-filled.png',
                          scale: 1.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    StatusLabel(problemStatus: problem.problemStatus),
                  ],
                ),
                Text(problem.title, style: txtTheme.headline6),
                Text(
                  "سطح روغن ماشین شما کم است. برای از بین بردن اصطکاک و گرم شدن بیش از حد ، روغن موتور را تعویض کنید.",
                  // "your car's oil levels are low on oil is needed to lovely Kate all metal companies to eliminate friction and overheating",
                  // problem.description,
                  style: txtTheme.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
