import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/utils/auth_validators.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/auth_text_field.dart';

class LoginCredentialsFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback? onSubmitted;

  const LoginCredentialsFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AuthTextField(
            controller: emailController,
            hintText: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            validator: AuthValidators.email,
          ),
          const SizedBox(height: 14),
          AuthTextField(
            controller: passwordController,
            hintText: 'Enter your password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            onFieldSubmitted: (_) => onSubmitted?.call(),
            validator: AuthValidators.password,
          ),
        ],
      ),
    );
  }
}
