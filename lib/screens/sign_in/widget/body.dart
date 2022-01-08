import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomicar/screens/sign_in/sign_in_screen.dart';
import 'package:zoomicar/utils/services/auth_provider.dart';
import 'package:zoomicar/widgets/custom_text_field.dart';
import 'package:zoomicar/widgets/fade_animation.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      decoration: customBoxDecoration(context),
      child: Form(
        key: provider.formKey,
        child: Column(
          children: [
            const Spacer(),
            FadeAnimation(
              delay: 0.53,
              child: buildPhoneNumber(
                context,
                onChanged: (value) => provider.mobile = value,
                onSubmeted: (value) {
                  confirmAction(context, provider);
                },
              ),
            ),
            Expanded(
              child: Center(
                  child: provider.isLoading
                      ? const CircularProgressIndicator()
                      : null),
            ),
          ],
        ),
      ),
    );
  }
}
