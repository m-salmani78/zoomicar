import 'package:flutter/material.dart';
import 'package:zoomicar/constants/api_keys.dart';
import 'package:zoomicar/constants/app_constants.dart';
import 'package:zoomicar/models/brand_model.dart';
import 'package:zoomicar/screens/mechanic_details/widget/your_rate_view.dart';
import 'package:zoomicar/screens/webview_screen/webview_screen.dart';
import 'package:zoomicar/utils/services/brand_service.dart';

class BrandDetailsScreen extends StatefulWidget {
  const BrandDetailsScreen({Key? key, required this.brand}) : super(key: key);
  final Brand brand;

  @override
  State<BrandDetailsScreen> createState() => _BrandDetailsScreenState();
}

class _BrandDetailsScreenState extends State<BrandDetailsScreen> {
  late double _rate;
  @override
  void initState() {
    _rate = widget.brand.userRate.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.brand.name)),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(cornerRadius),
            child:
                Image.network(baseUrl + widget.brand.image, fit: BoxFit.cover),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('قیمت: ${widget.brand.price} تومان',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              _buildAvgRate(context, widget.brand.rate),
            ],
          ),
          Text(
            widget.brand.description,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewPage(
                        url: widget.brand.link ??
                            'https://speedy.iranecar.com/'),
                  ));
            },
            label: const Text('مشاهده سایت'),
            icon: const Icon(Icons.public),
          ),
          const SizedBox(height: 16),
          const Divider(height: 32),
          const Text(
            'امتیاز شما',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          _buildRatingBar(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildRatingBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: customCardDecoration(context),
      child: Column(
        children: [
          const SizedBox(height: 8),
          buildRatingBar(
            context,
            initialRating: widget.brand.userRate.toDouble(),
            onRatingUpdate: (value) => _rate = value,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                5,
                (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '${index + 1}',
                        style: Theme.of(context).textTheme.overline,
                      ),
                    )),
          ),
          const SizedBox(height: 8),
          Divider(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: 6,
            thickness: 6,
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              child: const Text('ارسال امتیاز', style: TextStyle(height: 2)),
              onPressed: () => BrandService.rateBrand(context,
                  brandId: widget.brand.id, rate: _rate),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvgRate(BuildContext context, double rate) {
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
          Icon(Icons.star_rounded, color: color),
          Text(
            '${rate.toStringAsFixed(1)} از 5 ',
          ),
        ],
      ),
    );
  }
}
