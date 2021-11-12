import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/constants/app_constants.dart';
import '/models/account_model.dart';
import '/screens/add_car/add_car.dart';
import '/screens/home/home_screen.dart';
import '../utils/services/account_change_handler.dart';
import '../constants/api_keys.dart';

class ChooseCarBottomSheet extends StatelessWidget {
  final accountBox = Hive.box<Account>(accountBoxKey);

  ChooseCarBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).dialogBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          ...accountBox.values.map(
            (account) => _buildItems(
              title: account.car.model,
              id: account.id,
              avatar: CachedNetworkImage(
                imageUrl: baseUrl + account.car.image,
                progressIndicatorBuilder: (context, url, progress) {
                  return CircularProgressIndicator(
                    value: progress.progress,
                    color: Colors.white,
                  );
                },
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              onTap: () {
                final index = accountBox.values.toList().indexOf(account);
                AccountChangeHandler.carIndex = index;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false);
              },
            ),
          ),
          if (accountBox.length < 4)
            _buildItems(
              title: 'افزودن خودرو',
              avatar: const Icon(Icons.add),
              id: -1,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddCarScreen()));
              },
            ),
        ],
      ),
    );
  }

  Widget _buildItems(
      {required String title,
      required int id,
      Widget? avatar,
      Function()? onTap}) {
    final carsId = accountBox.values.map((e) => e.id).toList();
    final index = AccountChangeHandler.carIndex;
    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Text(title),
        leading: ClipOval(child: CircleAvatar(radius: 24, child: avatar)),
        onTap: onTap,
        trailing: id < 0
            ? null
            : Radio<int>(
                value: id,
                groupValue: index == null ? -1 : carsId[index],
                onChanged: (_) {},
              ),
      ),
    );
  }
}
