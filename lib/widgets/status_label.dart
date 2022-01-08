import 'package:flutter/material.dart';
import '/models/problem_model.dart';

class StatusLabel extends StatelessWidget {
  final ProblemStatus problemStatus;
  const StatusLabel({Key? key, required this.problemStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = colorFromProblemStatus(problemStatus);
    String title = '';
    switch (problemStatus) {
      case ProblemStatus.urgent:
        title = 'اضطراری';
        break;
      case ProblemStatus.critical:
        title = 'بحرانی';
        break;
      case ProblemStatus.fair:
        title = 'نسبتا خوب';
        break;
      default:
        title = 'خوب';
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(title,
          style:
              const TextStyle(color: Colors.white, fontSize: 11, height: 1.2)),
    );
  }
}
