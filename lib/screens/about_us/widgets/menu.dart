import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoomicar/constants/strings.dart';
import 'package:zoomicar/utils/helpers/show_snack_bar.dart';

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
            'تماس با ما',
            avatar: const Icon(Icons.call),
            onTap: () async {
              await canLaunch(contactUs)
                  ? await launch(contactUs)
                  : showWarningSnackBar(context,
                      message: 'مشکلی در باز کردن لینک رخ داده است');
            },
          ),
          _buildItem(
            'مشاهده سایت',
            avatar: const Icon(Icons.language),
            onTap: () async {
              await canLaunch(officialWebsiteUrl)
                  ? await launch(officialWebsiteUrl)
                  : showWarningSnackBar(context,
                      message: 'مشکلی در باز کردن لینک رخ داده است');
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
