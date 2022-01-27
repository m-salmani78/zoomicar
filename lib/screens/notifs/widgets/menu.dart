import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoomicar/constants/strings.dart';

class NotificationsMenuItems extends StatelessWidget {
  const NotificationsMenuItems({Key? key}) : super(key: key);

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
            'گزارش مشکل',
            avatar: const Icon(Icons.report),
            onTap: () async {
              if (await canLaunch(emailAddress)) await launch(emailAddress);
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
