import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zoomicar/screens/suggested_brands/widget/band_details_screen.dart';
import 'package:zoomicar/screens/webview_screen/webview_screen.dart';
import '/constants/app_constants.dart';
import '/models/brand_model.dart';
import '../../../constants/api_keys.dart';

class BrandList extends StatelessWidget {
  const BrandList({required this.brands});

  final List<Brand> brands;

  @override
  Widget build(BuildContext context) {
    return brands.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
      elevation: defaultElevation,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius)),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BrandDetailsScreen(brand: brand),
              ));
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(cornerRadius),
              child: Image.network(baseUrl + brand.image,
                  width: 110, height: 120, fit: BoxFit.cover),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        brand.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text('قیمت ${brand.price}',
                          style: Theme.of(context).textTheme.caption),
                    ],
                  ),
                  Text(
                    brand.description,
                    maxLines: 2,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      buildAvgRate(context, brand.rate),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewPage(
                                    url: brand.link ??
                                        'https://speedy.iranecar.com/'),
                              ));
                        },
                        child: const Text('مشاهده سایت'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

Widget buildAvgRate(BuildContext context, double rate) {
  final color = Theme.of(context).brightness == Brightness.light
      ? Colors.amber
      : Colors.white;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    margin: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.amber.shade100.withOpacity(0.4)
          : Colors.black,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: color, size: 22),
        Text(
          rate.toStringAsFixed(1),
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(width: 4),
      ],
    ),
  );
}
