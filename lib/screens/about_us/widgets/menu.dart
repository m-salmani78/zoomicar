import 'package:flutter/material.dart';

class AboutUsMenuItems extends StatelessWidget {
  const AboutUsMenuItems({Key? key}) : super(key: key);

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
            'ارتباط با ما',
            avatar: const Icon(Icons.call),
            onTap: () {},
          ),
          _buildItem(
            'مشاهده سایت',
            avatar: const Icon(Icons.language),
            onTap: () {},
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
