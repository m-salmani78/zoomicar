import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zoomicar/screens/webview_screen/webview_screen.dart';
import '/constants/app_constants.dart';
import '/models/brand_model.dart';
import '../../../constants/api_keys.dart';
import 'package:readmore/readmore.dart';

class BrandList extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const BrandList({required this.brands});

  final List<Brand> brands;

  @override
  Widget build(BuildContext context) {
    return brands.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              return _buildItem(context, brands[index]);
            },
          )
        : Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/box.svg',
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                const SizedBox(height: 4),
                const Text('موردی یافت نشد'),
              ],
            ),
          );
  }

  Widget _buildItem(BuildContext context, Brand brand) {
    return Card(
      // margin: const EdgeInsets.all(8),
      elevation: defaultElevation,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Image.network(baseUrl + brand.image,
                    width: 72, height: 72, fit: BoxFit.fill),
                const SizedBox(width: 12),
                Flexible(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            brand.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text('قیمت ${brand.price}',
                              style: Theme.of(context).textTheme.caption),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ReadMoreText(
                        brand.description,
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.justify,
                        trimLines: 2,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'بیشتر',
                        trimExpandedText: 'کمتر',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            TextButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WebViewPage(
                          url: 'https://speedy.iranecar.com/'),
                    ));
              },
              child: const Text('مشاهده سایت'),
            )
          ],
        ),
      ),
    );
  }
}
