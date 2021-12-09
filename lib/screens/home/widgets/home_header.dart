import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../utils/services/account_change_handler.dart';
import '../../../constants/api_keys.dart';
import '/screens/home/widgets/header_background.dart';
import '/models/car_model.dart';
import '/widgets/change_car_sheet.dart';

class HomeHeader extends StatelessWidget {
  final Car? car;
  // ignore: use_key_in_widget_constructors
  const HomeHeader(this.car);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        const HeaderBackground(),
        Column(
          children: [
            const Spacer(),
            Container(
              child: car == null
                  ? Image.asset(
                      'assets/images/no_car.png',
                      height: size.height * 0.2,
                    )
                  : CachedNetworkImage(
                      useOldImageOnUrlChange: true,
                      imageUrl: baseUrl + car!.image,
                      height: size.height * 0.2,
                      progressIndicatorBuilder: (context, url, progress) {
                        return ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: size.width * 0.4),
                          child: const Center(child: LinearProgressIndicator()),
                        );
                      },
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/car_sample.png'),
                    ),
            ),
            const Spacer(),
            TextButton(
              child: _buildCarModel(),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => ChooseCarBottomSheet(),
                );
              },
            ),
            const Divider(
              color: Colors.white,
              height: 0,
              indent: 16,
              endIndent: 16,
            ),
            const SizedBox(height: 12),
            Text(
              'سلام ${AccountChangeHandler().userName}، خوش آمدید',
              // 'Hi ${AccountChangeNotifier.userName}, Welcome',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ],
    );
  }

  Widget _buildCarModel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        (car == null)
            ? const Text(
                ' هیچ دستگاهی موجود نیست ',
                // ' no device ',
                style: TextStyle(color: Colors.white60),
              )
            : Text(
                car!.model,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        const Icon(Icons.keyboard_arrow_down, color: Colors.white)
      ],
    );
  }
}
