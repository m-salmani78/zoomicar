import 'package:flutter/material.dart';
import 'package:zoomicar/models/brand_model.dart';
import 'package:zoomicar/screens/mechanics/mechanics_screen.dart';
import 'package:zoomicar/utils/services/brand_service.dart';
import '/models/problem_model.dart';
import '/widgets/form_error.dart';

import 'widget/body.dart';

class SuggestedBrandsScreen extends StatefulWidget {
  const SuggestedBrandsScreen({Key? key, required this.problem})
      : super(key: key);

  final Problem problem;

  @override
  _SuggestedBrandsScreenState createState() => _SuggestedBrandsScreenState();
}

class _SuggestedBrandsScreenState extends State<SuggestedBrandsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('برندهای پیشنهادی')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: BrandService.getBrands(context, accessory: widget.problem.tag),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          }
          if (snapshot.hasError) {
            return _buildError();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final brands = brandsFromMap(snapshot.data!['brands']);
            // log('@ Brands: ' + brands.toString());
            return Body(
                changingPrice: snapshot.data!['changing_price'],
                brands: brands);
          }
          return _buildLoading();
        },
      ),
      bottomNavigationBar: TextButton(
        child: const Text('نزدیکترین مراکز تعویض'),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MechanicsScreen(problem: widget.problem),
            )),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FormError(errors: ['اتصال برقرار نیست']),
          TextButton.icon(
            onPressed: () {
              setState(() {});
            },
            label: const Text('تلاش مجدد'),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
