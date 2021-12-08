import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/models/problem_model.dart';
import '../../../utils/services/account_change_handler.dart';
import '../../../constants/api_keys.dart';
import '/widgets/form_error.dart';

import 'notif_list.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.carId}) : super(key: key);

  final int carId;
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int _selctedItem = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Flexible(
          child: _selctedItem == 2
              ? NotifList(problems: const [], carId: widget.carId)
              : FutureBuilder(
                  future: http.post(
                    Uri.parse(baseUrl + '/car/notifications'),
                    headers: {
                      authorization: AccountChangeHandler().token ?? ''
                    },
                    body: {"car_id": widget.carId.toString()},
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoading();
                    }
                    if (snapshot.hasError) {
                      log('@ Problem Error: ${snapshot.error}');
                      return _buildError();
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      final response = snapshot.data as http.Response;
                      if (response.statusCode == 200) {
                        var problems = problemsFromJson(
                          utf8.decode(response.bodyBytes),
                          carId: widget.carId,
                        );
                        return NotifList(
                            carId: widget.carId,
                            problems: problems
                                .where((item) => item.percent >= 100)
                                .toList());
                      }
                    }
                    return _buildLoading();
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            context,
            label: 'همه پیام ها',
            selected: _selctedItem == 0,
            onSelected: (selected) {
              setState(() => _selctedItem = 0);
            },
          ),
          const SizedBox(width: 4),
          _buildChip(
            context,
            label: 'اطلاع رسانی ها',
            avatar: (Icons.notifications_active_outlined),
            selected: _selctedItem == 1,
            onSelected: (selected) {
              setState(() => _selctedItem = 1);
            },
          ),
          const SizedBox(width: 4),
          _buildChip(
            context,
            label: 'پیشنهادها',
            avatar: (Icons.local_offer_outlined),
            selected: _selctedItem == 2,
            onSelected: (selected) {
              setState(() => _selctedItem = 2);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context,
      {required String label,
      IconData? avatar,
      required bool selected,
      ValueChanged<bool>? onSelected}) {
    return ChoiceChip(
      label: Text(label),
      avatar: avatar == null ? null : Icon(avatar),
      selected: selected,
      onSelected: onSelected,
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
