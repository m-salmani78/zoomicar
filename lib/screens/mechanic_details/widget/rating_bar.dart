import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import '/utils/helpers/account_change_handler.dart';
import '/utils/services/api_keys.dart';

class CustomRatingBar extends StatefulWidget {
  final int id;
  final int initialRating;

  // ignore: use_key_in_widget_constructors
  const CustomRatingBar({required this.id, required this.initialRating});

  @override
  _CustomRatingBarState createState() => _CustomRatingBarState();
}

class _CustomRatingBarState extends State<CustomRatingBar> {
  int _rate = -1;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        RatingBar.builder(
          direction: Axis.horizontal,
          itemCount: 5,
          initialRating: math.max<double>(0, widget.initialRating.toDouble()),
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          unratedColor: Colors.grey[400],
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Theme.of(context).colorScheme.primary,
          ),
          onRatingUpdate: (value) => _rate = value.round(),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: TextField(
            style: TextStyle(fontSize: 16),
            maxLength: 500,
            minLines: 1,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'تجربه تان را توصیف کنید (اختیاری)',
            ),
          ),
        ),
        TextButton(
          child: const Text('ارسال نظر'),
          onPressed: () async {
            if (_rate <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ابتدا امتیاز مورد نظر خود را وارد کنید'),
                ),
              );
              return;
            }
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );
            var response = await http.post(
              Uri.parse(baseUrl + '/car/rate_center'),
              headers: {authorization: AccountChangeHandler.token ?? ''},
              body: {
                "center_id": widget.id.toString(),
                "rate": _rate.toString(),
              },
            ).onError((error, stackTrace) {
              return http.Response("", 404);
            });
            log('@ Rate Response StatusDose: ${response.statusCode}');
            Navigator.pop(context);
            if (response.statusCode == 200) {
              var json = jsonDecode(response.body);
              try {
                if (json[StatusResponse.key] == StatusResponse.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('نظر شما با موفقیت ثبت شد')),
                  );
                  return;
                }
              } catch (_) {}
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('خطا در برقراری ارتباط')),
            );
          },
        ),
      ],
    );
  }
}
