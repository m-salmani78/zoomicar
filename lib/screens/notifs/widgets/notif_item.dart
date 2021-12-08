import 'package:flutter/material.dart';
import '/constants/app_constants.dart';
import '/models/problem_model.dart';
import '/models/car_model.dart';
import '/screens/problem/problem_screen.dart';
import '../../../utils/services/account_change_handler.dart';
import '/utils/helpers/persian_word_helper.dart';

class NotifItem extends StatelessWidget {
  final Problem problem;
  final Car? car;
  // ignore: use_key_in_widget_constructors
  const NotifItem({required this.problem, required this.car});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: defaultElevation,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius)),
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProblemScreen(problem: problem)));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.notifications_on_outlined),
                  const SizedBox(width: 4),
                  Text(
                    '${AccountChangeHandler().userName} عزیز',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '${wordInCombination(problem.title)} خودروی ${car == null ? '' : wordInCombination(car!.model)} خود را تعویض کنید.'
                  '\nنزدیکترین مراکز به شما :',
                  style: const TextStyle(height: 2),
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  const Text('...'),
                  const Spacer(),
                  TextButton(
                      style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProblemScreen(problem: problem)));
                      },
                      child: const Text('مشاهده')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
