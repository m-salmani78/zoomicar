import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/constants/app_constants.dart';
import '/models/account_model.dart';
import '/models/problem_model.dart';
import '/screens/notifs/widgets/notif_item.dart';

class NotifList extends StatelessWidget {
  final List<Problem> problems;
  final int carId;
  final accountBox = Hive.box<Account>(accountBoxKey);
  NotifList({Key? key, required this.problems, required this.carId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (problems.isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/box.svg',
              width: MediaQuery.of(context).size.width * 0.6,
            ),
            const SizedBox(height: 4),
            const Text('پیامی وجود ندارد'),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: problems.length + 1,
      itemBuilder: (context, index) {
        if (index == problems.length) return const SizedBox(height: 100);
        final account = accountBox.get(carId);
        return NotifItem(
          problem: problems[index],
          car: account?.car,
        );
      },
    );
  }
}
