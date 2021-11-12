import 'package:flutter/material.dart';
import '/screens/add_car/add_car.dart';
import '/models/car_model.dart';
import '/screens/home/home_screen.dart';
import '../../../utils/services/account_change_handler.dart';

class MenuItems extends StatelessWidget {
  final Car car;
  const MenuItems({Key? key, required this.car}) : super(key: key);

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
          _buildItem(
            'ویرایش اطلاعات',
            avatar: const Icon(Icons.edit),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCarScreen(car: car)),
              );
            },
          ),
          _buildItem(
            'حذف خودرو',
            avatar: const Icon(Icons.delete, color: Colors.red),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content:
                        const Text('آیا مطمئنید میخواهید خودرو را حذف کنید؟'),
                    actions: [
                      TextButton(
                        child: const Text('بله'),
                        // child: Text('Yes'),
                        onPressed: () async {
                          // showDialog(
                          //   context: context,
                          //   builder: (_) =>
                          //       Center(child: CircularProgressIndicator()),
                          // );
                          var error =
                              await AccountChangeHandler.deleteCurrentCar(
                                  car.carId);
                          if (error == null) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomeScreen()),
                              (route) => false,
                            );
                          } else {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(error),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('فهمیدم'),
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                      TextButton(
                        // child: Text('Cancel'),
                        child: const Text('لغو'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, {Widget? avatar, Function()? onTap}) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Text(title),
        leading: avatar,
        onTap: onTap,
      ),
    );
  }
}
