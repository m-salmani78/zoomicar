import 'package:flutter/material.dart';
import 'package:zoomicar/constants/app_constants.dart';
import 'package:zoomicar/screens/mechanic_details/widget/your_rate_view.dart';
import 'package:zoomicar/utils/helpers/show_snack_bar.dart';
import 'package:zoomicar/utils/services/mechanic_rate_service.dart';

class SendCommentMenu extends StatelessWidget {
  const SendCommentMenu({required this.rateService});

  final MechanicRateService rateService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نظر شما'),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: double.infinity,
            decoration: customCardDecoration(context),
            child: Column(
              children: [
                buildRatingBar(context,
                    initialRating: rateService.rate.toDouble(),
                    onRatingUpdate: (value) =>
                        rateService.rate = value.toInt()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('${index + 1}'),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: TextField(
              controller: TextEditingController(text: rateService.text),
              style: const TextStyle(fontSize: 16),
              onChanged: (value) => rateService.text = value,
              maxLength: 400,
              minLines: 4,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'تجربه تان را توصیف کنید (اختیاری)',
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ElevatedButton(
          onPressed: () async {
            if (rateService.rate <= 0) {
              showWarningSnackBar(
                context,
                message: 'ابتدا امتیاز مورد نظر خود را وارد کنید',
              );
            } else {
              bool result = await rateService.sendComment(context);
              if (result) Navigator.pop(context, true);
            }
          },
          child: const Text('ارسال نظر'),
        ),
      ),
    );
  }
}
