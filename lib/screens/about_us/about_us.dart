import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zoomicar/constants/strings.dart';
import 'package:zoomicar/utils/helpers/show_snack_bar.dart';
import '/screens/about_us/widgets/menu.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('درباره ما'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => const AboutUsMenuItems(),
              );
            },
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/ringsport.png',
                width: MediaQuery.of(context).size.width * 0.6),
            const Text(aboutUsDescriptions, textAlign: TextAlign.justify),
            const SizedBox(height: 64),
            const Text('ما را در شبکه های اجتماعی دنبال کنید'),
            _buildSocialMedias(context),
            const Divider(thickness: 1, indent: 32, endIndent: 32),
            InkWell(
              onTap: () async {
                await canLaunch(semicolonUrl)
                    ? await launch(semicolonUrl)
                    : showWarningSnackBar(context,
                        message: 'مشکلی در باز کردن لینک رخ داده است');
              },
              radius: 0,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'توسعه داده شده توسط\n تیم سمی کالن',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.overline,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMedias(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIcon(
          context,
          assetName: 'assets/icons/ic_telegram.svg',
          url: telegramUrl,
        ),
        _buildIcon(
          context,
          assetName: 'assets/icons/ic_instagram.svg',
          url: instagramUrl,
        ),
        _buildIcon(
          context,
          assetName: 'assets/icons/ic_linkedin.svg',
          url: linkedinUrl,
        ),
      ],
    );
  }

  Widget _buildIcon(BuildContext context,
      {required String assetName, required String url}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: GestureDetector(
        onTap: () async {
          await canLaunch(url)
              ? await launch(url)
              : showWarningSnackBar(context,
                  message: 'مشکلی در باز کردن لینک رخ داده است');
        },
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(2),
          child: SvgPicture.asset(assetName, width: 36),
        ),
      ),
    );
  }
}
