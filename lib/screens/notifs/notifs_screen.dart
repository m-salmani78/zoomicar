import 'package:flutter/material.dart';
import '/screens/notifs/widgets/advertising_view.dart';

import 'widgets/body.dart';
import 'widgets/menu.dart';

class NotifsScreen extends StatelessWidget {
  final int carId;
  // ignore: use_key_in_widget_constructors
  const NotifsScreen({required this.carId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اعلانات'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => const NotificationsMenuItems(),
              );
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Body(carId: carId),
      bottomSheet: const AdvertisingView(),
    );
  }
}
