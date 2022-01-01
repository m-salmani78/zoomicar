import 'package:flutter/material.dart';
import 'package:zoomicar/widgets/circular_percent_indicator.dart';
import '/models/problem_model.dart';
import '/screens/mechanics/mechanics_screen.dart';
import '/screens/problem/widget/mark_complete.dart';
import '/screens/suggested_brands/suggested_brand.dart';

import 'widget/recommended_machanics.dart';

class ProblemScreen extends StatelessWidget {
  // static const routeName = '/problem';
  final Problem problem;

  const ProblemScreen({Key? key, required this.problem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(problem.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildHeader(context, problem),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      problem.problemStatus.index >= ProblemStatus.fair.index
                          ? null
                          : () async {
                              showDialog(
                                context: context,
                                builder: (context) => MarkCompleteDialog(
                                  carId: problem.carId,
                                  tag: problem.tag,
                                ),
                              );
                            },
                  child: const Text('انجام شد'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SuggestedBrandsScreen(problem: problem)),
                  );
                },
                child: const Text('برندهای پیشنهادی'),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 0),
          Row(
            children: [
              const SizedBox(width: 16),
              const Text('نزدیکترین مراکز',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton(
                child: const Text('همه'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MechanicsScreen(problem: problem),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          Expanded(child: RecommendedMechanics(problem: problem)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Problem problem) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 160,
          lineWidth: 10,
          percent: problem.percent * 0.01,
          child: Hero(
            tag: problem.hashCode,
            child: Image.asset(
              problem.imageAssetAddress,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
          ),
          progressColor: problem.color,
        ),
        const SizedBox(height: 8),
        if (problem.problemStatus == ProblemStatus.urgent ||
            problem.problemStatus == ProblemStatus.critical)
          Text(
            "سطح روغن ماشین شما کم است. برای از بین بردن اصطکاک و گرم شدن بیش از حد ، روغن موتور را تعویض کنید.",
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
