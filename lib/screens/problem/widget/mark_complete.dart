import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:zoomicar/utils/helpers/show_snack_bar.dart';
import '/constants/app_constants.dart';
import '/models/account_model.dart';
import '/models/problem_model.dart';
import '/screens/home/home_screen.dart';
import '../../../utils/services/account_change_handler.dart';
import '../../../constants/api_keys.dart';

class MarkCompleteDialog extends StatefulWidget {
  final int carId;
  final String tag;
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius)),
      title: Text('تعویض ${tagToTitle(widget.tag)}:'),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('لطفا کیلومتر خودرو را در لحظه تعویض وارد نمایید:'),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: TextFormField(
              textDirection: TextDirection.ltr,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                  hintTextDirection: TextDirection.ltr,
                  hintText: '0 km',
                  contentPadding: EdgeInsets.all(12)),
              onChanged: (value) => kilometerage = int.tryParse(value) ?? 0,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return requiredInputError;
                }
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("لغو"),
          onPressed: () => Navigator.pop(context),
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
            ).then((response) async {
              log('@ StatusCode: ${response.statusCode}');
              if (response.statusCode == 200) {
                log('@ UpdateAccessory: ' + response.body);
                Map<String, dynamic> json =
                    jsonDecode(utf8.decode(response.bodyBytes));
                if (json[StatusResponse.key] == StatusResponse.success) {
                  var account = accountBox.get(widget.carId);
                  if (account == null) {
                    return;
                  }
                  log(json['notifications'].toString(),
                      name: 'new notifications');
                  account.car
                      .editParamWithTag(tag: widget.tag, value: kilometerage);
                  var problem = account.findProblem(tag: widget.tag);
                  if (problem == null) {
                    account.problems.add(Problem(
                      carId: widget.carId,
                      tag: widget.tag,
                      notifs: notifsFromJson(json['notifications']),
                    ));
                    log('problem added', name: 'update accessory');
                  } else {
                    problem.notifs = notifsFromJson(json['notifications']);
                    log('problem edited', name: 'update accessory');
                  }
                  accountBox.put(account.id, account);
                  showSuccessSnackBar(context,
                      message: 'اطلاعات با موفقیت ثبت شد.');
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false);
                  log('@ finish update');
                  return;
                }
              }
              Navigator.pop(context);
              showWarningSnackBar(context, message: 'خطا در ارسال اطلاعات.');
            }).onError((error, stackTrace) {
              if (error == null) return;
              log('@ Update Error: ' + error.toString());
              Navigator.pop(context);
              showWarningSnackBar(context, message: 'اتصال برقرار نیست.');
            });
          },
        ),
      ],
    );
  }
}
