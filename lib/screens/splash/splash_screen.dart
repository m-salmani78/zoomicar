import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import '/screens/sign_in/sign_in_screen.dart';
import '/screens/splash/widgets/splash_footer.dart';
import '/widgets/app_name.dart';

import 'widgets/splash_content.dart';

const List<Map<String, String>> splashData = [
  {
    'image': 'assets/images/slider1.png',
    // description: 'We notify you to when your car needs to repair',
    'description': 'بهترین دستیار راننده و مراقب دائمی ماشین شما',
  },
  {
    'image': 'assets/images/slider2.png',
    // description: 'We notify you to when your car needs to repair',
    'description': 'آگاه سازی کاربر هنگامی که ماشین نیاز به تعویض قطعات دارد',
  },
  {
    'image': 'assets/images/slider3.png',
    'description':
        // 'introducing the closest and mechanics when the car has a problem',
        'معرفی نزدیکترین مکانیکی ها زمانی که ماشین شما دچار مشکل شده است.',
  },
];

class SplashScreen extends StatefulWidget {
  // static const routeName = '/splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        children: [
          const Positioned(
            top: 64,
            child: AppName(),
          ),
          PageView(
            controller: _pageController,
            onPageChanged: (value) => setState(() => currentPage = value),
            children: List.generate(
              splashData.length,
              (index) => SplashContent(splashData[index]),
            ),
          ),
          Positioned(
            bottom: 0,
            child: _buildSplashFooter(),
          ),
        ],
      ),
    );
  }

  Widget _buildSplashFooter() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      child: SplashFooterScreen(
        currentPage: currentPage,
        onClickNext: currentPage == splashData.length - 1
            ? () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignInScreen()))
            : () {
                currentPage++;
                _pageController.animateToPage(currentPage,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
        onClickSkip: currentPage == splashData.length - 1
            ? null
            : () {
                currentPage = splashData.length - 1;
                _pageController.animateToPage(currentPage,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
      ),
    );
  }
}
