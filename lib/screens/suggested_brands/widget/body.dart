import 'package:flutter/material.dart';
import '/models/brand_model.dart';

import 'brand_list.dart';

class Body extends StatelessWidget {
  const Body({required this.brands, required this.changingPrice});

  final List<Brand> brands;
  final int changingPrice;

  @override
  Widget build(BuildContext context) {
    final minPrice = brands.isNotEmpty
        ? brands
            .reduce((curr, next) => curr.price < next.price ? curr : next)
            .price
        : 0;
    final maxPrice = brands.isNotEmpty
        ? brands
            .reduce((curr, next) => curr.price > next.price ? curr : next)
            .price
        : 0;
    return Column(
      children: [
        _buildPartsChangeFee(changingPrice),
        const Divider(height: 0),
        Flexible(child: BrandList(brands: brands)),
        const Divider(height: 0),
        _buildPriceRange(max: maxPrice, min: minPrice),
      ],
    );
  }

  Widget _buildPartsChangeFee(int changingPrice) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Icon(Icons.hardware_rounded),
          const SizedBox(width: 4),
          const Text('اجرت تعویض',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Spacer(),
          Text(changingPrice.toString() + ' تومان'),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildPriceRange({required int min, required int max}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Icon(Icons.attach_money),
          const SizedBox(width: 4),
          const Text('بازه قیمت',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Spacer(),
          Text('$min - $max'),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
