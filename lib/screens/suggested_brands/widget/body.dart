import 'package:flutter/material.dart';
import '/models/brand_model.dart';
import '/models/problem_model.dart';
import '/screens/mechanics/mechanics_screen.dart';

import 'brand_list.dart';

class Body extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const Body({required this.json, required this.problem});

  final Map<String, dynamic> json;
  final Problem problem;

  @override
  Widget build(BuildContext context) {
    final brands = List<Brand>.from(
      (json["brands"] as List).map((x) => Brand.fromJson(x)),
    );
    final int changingPrice = json["changing_price"] ?? -1;
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
        TextButton(
          child: const Text('نزدیکترین مراکز تعویض'),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MechanicsScreen(problem: problem),
              )),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildPartsChangeFee(int changingPrice) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Text('اجرت تعویض',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(changingPrice.toString() + ' تومان'),
        ],
      ),
    );
  }

  Widget _buildPriceRange({required int min, required int max}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Text('بازه قیمت',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text('$min - $max'),
        ],
      ),
    );
  }
}
