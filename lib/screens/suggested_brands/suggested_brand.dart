import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/models/problem_model.dart';
import '../../utils/services/account_change_handler.dart';
import '../../constants/api_keys.dart';
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
      body: FutureBuilder(
        future: http.post(
          Uri.parse(baseUrl + '/car/brands'),
          headers: {authorization: AccountChangeHandler().token ?? ""},
          body: {"accessory": widget.problem.tag},
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          }
          if (snapshot.hasError) {
            return _buildError();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final response = snapshot.data as http.Response;
            log('@ Brands: ' + response.body);
            if (response.statusCode == 200) {
              return Body(
                problem: widget.problem,
                json: jsonDecode(utf8.decode(response.bodyBytes)),
              );
            }
          }
          return _buildLoading();
        },
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
