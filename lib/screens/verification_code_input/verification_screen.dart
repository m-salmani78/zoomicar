import 'package:flutter/material.dart';
import '/screens/verification_code_input/widgets/verification_code_input.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تایید شماره'),
      ),
      body: Column(
        children: [
          VerificationCodeInput(
            onCompleted: (value) {},
          ),
          const Text('data'),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('ادامه')),
          ),
        ],
      ),
    );
  }
}
