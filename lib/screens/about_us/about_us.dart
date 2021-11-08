import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            const Text(
              'رینگ اسپورت یک شرکت معروف در بهینه‌سازی موتور جستجو است که دارای یک وبلاگ بسیار خوب و حتی مجموعه‌ای از محصولات عالی است که کمک می‌کند به شما ترافیک بیشتری را برای وبسایت خود بدست آورید. صفحه درباره ما آنها یکی از نمونه‌های قوی می‌باشد که تمرکز اصلی صفحه درباره ما یک گرافیک (نمایش وقایع در یک بازه معین) است که به شما تاریخچه‌ای از گذشته و جزئیاتی در مورد دستاوردها، چالش‌ها و تاریخ‌های مهم شرکت را می‌دهد و می‌توانید تصاویر دایره‌ای را در طول مسیر، براحتی بررسی کنید. این امر به شما یک حس واقعی از ثبات و پایداری شرکت را می‌دهد و به شما القا می‌کند که می‌تواند تا سال‌های طولانی در کنار شما باشد. مزیت عمده این نوع صفحه «درباره ما» این است که این نوار زمان به شما این امکان را می‌دهد که حس کنید بخشی از داستان آنها هستید و می‌دانید که دقیقا چگونه شرکت شکوفا شده است و چه کارهایی در آن انجام شده است.',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 64),
            const Text('ما را در شبکه های اجتماعی دنبال کنید'),
            _buildSocialMedias(),
            const Divider(thickness: 1, indent: 32, endIndent: 32),
            InkWell(
              onTap: () async {
                const url = 'https://t.me/safari_ir';
                await canLaunch(url)
                    ? await launch(url)
                    : log('@ E: Could not launch $url');
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

  Widget _buildSocialMedias() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIcon(
            assetName: 'assets/icons/telegram.svg',
            url: 'https://t.me/salmani_78'),
        _buildIcon(
            assetName: 'assets/icons/instagram.svg',
            url: 'https://instagram.com/mo.ma.sal'),
        _buildIcon(assetName: 'assets/icons/twitter.svg', url: ''),
      ],
    );
  }

  Widget _buildIcon({required String assetName, required String url}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: GestureDetector(
        onTap: () async {
          await canLaunch(url)
              ? await launch(url)
              : log('@ E: Could not launch $url');
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
