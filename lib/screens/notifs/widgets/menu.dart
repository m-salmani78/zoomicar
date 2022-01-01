import 'package:flutter/material.dart';
import 'package:zoomicar/screens/webview_screen/webview_screen.dart';

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
            'دانشنامه',
            avatar: const Icon(Icons.science),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return const WebViewPage(
                      url:
                          'https://fa.wikipedia.org/wiki/%D8%AE%D9%88%D8%AF%D8%B1%D9%88%DB%8C_%D8%A8%D8%B1%D9%82%DB%8C');
                },
              ));
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
