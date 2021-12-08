import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '/constants/app_constants.dart';
import '/models/account_model.dart';
import '/models/problem_model.dart';
import '/screens/home/home_screen.dart';
import '../../../utils/services/account_change_handler.dart';
import '../../../constants/api_keys.dart';

class MarkCompleteDialog extends StatefulWidget {
  final int carId;
  final String tag;
  // ignore: use_key_in_widget_constructors
  const MarkCompleteDialog({required this.carId, required this.tag});
  @override
  _MarkCompleteDialogState createState() => _MarkCompleteDialogState();
}

class _MarkCompleteDialogState extends State<MarkCompleteDialog> {
  final accountBox = Hive.box<Account>(accountBoxKey);
  final _formKey = GlobalKey<FormState>();
  int kilometerage = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      clipBehavior: Clip.antiAlias,
      title: const Text('ثبت کیلومتر:'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
              hintText: '0 km', contentPadding: EdgeInsets.all(12)),
          onChanged: (value) => kilometerage = int.parse(value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return requiredInputError;
            }
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text("لغو"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text("تایید"),
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            showDialog(
              context: context,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
            http.post(
              Uri.parse(baseUrl + '/car/update_accessory'),
              headers: {authorization: AccountChangeHandler().token ?? ''},
              body: {
                "accessory": widget.tag,
                "last_change": kilometerage.toString(),
                "car_id": widget.carId.toString(),
              },
            ).then((response) {
              log('@ StatusCode: ${response.statusCode}');
              if (response.statusCode == 200) {
                log('@ UpdateAccessory: ' + response.body);
                Map<String, dynamic> json =
                    jsonDecode(utf8.decode(response.bodyBytes));
                if (json[StatusResponse.key] == StatusResponse.success) {
                  var account = accountBox.get(widget.carId);
                  if (account != null) {
                    account.car
                        .editParamWithTag(tag: widget.tag, value: kilometerage);
                    var problem = account.findProblem(tag: widget.tag);
                    if (problem == null) {
                      account.problems.add(Problem(
                        carId: widget.carId,
                        tag: widget.tag,
                        description: "",
                        notifs: notifsFromJson(json['notifications']),
                      ));
                    } else {
                      problem.notifs = notifsFromJson(json['notifications']);
                    }
                  }
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (route) => false);
                  log('@ finish update');
                  return;
                }
              }
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) =>
                    _buildAlertDialog(context, 'خطا در ارسال اطلاعات.'),
              );
            }).onError((error, stackTrace) {
              if (error == null) return;
              log('@ Update Error: ' + error.toString());
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) =>
                    _buildAlertDialog(context, 'اتصال برقرار نیست.'),
              );
            });
          },
        ),
      ],
    );
  }

  Widget _buildAlertDialog(BuildContext context, String title) {
    return AlertDialog(
      content: Text(title),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("تلاش مجدد")),
        TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false);
            },
            child: const Text("بازگشت")),
      ],
    );
  }
}
