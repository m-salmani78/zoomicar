import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomicar/constants/app_constants.dart';
import 'package:zoomicar/screens/sign_up/sign_up_screen.dart';
import 'package:zoomicar/utils/services/auth_provider.dart';
import 'package:zoomicar/widgets/custom_text_field.dart';
import 'package:zoomicar/widgets/fade_animation.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(16),
      decoration: customBoxDecoration(context),
      child: Form(
        key: provider.formKey,
        child: Column(
          children: [
            const Spacer(),
            FadeAnimation(delay: 0.5, child: _buildUserName(context, provider)),
            const SizedBox(height: 24),
            FadeAnimation(
              delay: 0.6,
              child: buildPhoneNumber(context,
                  onSubmeted: (value) {
                    registerAction(context, provider: provider);
                  },
                  onChanged: (value) => provider.mobile = value),
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

  Widget _buildUserName(BuildContext context, AuthProvider provider) {
    return TextFormField(
      onChanged: (value) => provider.username = value,
      maxLength: 20,
      decoration: customInputDecoration(
        context,
        hint: 'نام کاربری',
        icon: const Icon(Icons.person_rounded),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return requiredInputError;
        } else if (value.contains(RegExp(r'[A-Z|a-z]'))) {
          return 'لطفا فقط از حروف فارسی استفاده کنید';
        }
      },
    );
  }
}
