import 'package:flutter/material.dart';
import '/models/problem_model.dart';

class StatusLabel extends StatelessWidget {
  final ProblemStatus problemStatus;
  // ignore: use_key_in_widget_constructors
  const StatusLabel({required this.problemStatus});

  @override
  Widget build(BuildContext context) {
    Color color = colorFromProblemStatus(problemStatus);
    String title = '';
    switch (problemStatus) {
      case ProblemStatus.urgent:
        title = 'اضطراری';
        // title = 'Urgent';
        break;
      case ProblemStatus.critical:
        title = 'بحرانی';
        // title = 'Critical';
        break;
      case ProblemStatus.fair:
        title = 'نسبتا خوب';
        // title = 'Fair';
        break;
      default:
        title = 'خوب';
      // title = 'Good';
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(title,
          style: const TextStyle(color: Colors.white, fontSize: 10)),
    );
  }
}
