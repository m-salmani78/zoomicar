import 'package:flutter/material.dart';
import 'package:zoomicar/constants/strings.dart';
import '/constants/app_constants.dart';
import '/models/problem_model.dart';
import '/screens/problem/problem_screen.dart';
import '/widgets/status_label.dart';

class ProblemCardView extends StatelessWidget {
  final Problem problem;
  const ProblemCardView({required this.problem});

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    return Card(
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
        child: Container(
          width: 210,
          height: 210,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
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
                      errorBuilder: (context, error, stackTrace) => Image.asset(
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
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  problemsDescrption[problem.tag] ?? '',
                  style: txtTheme.caption,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
