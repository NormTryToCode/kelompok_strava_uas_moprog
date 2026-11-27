import 'package:flutter/material.dart';

/// Secondary navigation actions below the Google button on the login card.
class LoginSecondaryActions extends StatelessWidget {
  final VoidCallback? onForgotPassword;
  final VoidCallback? onCreateAccount;

  const LoginSecondaryActions({
    super.key,
    this.onForgotPassword,
    this.onCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
    final secondaryButtonStyle = OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.white.withValues(alpha: 0.08),
      side: BorderSide(
        color: Colors.white.withValues(alpha: 0.45),
        width: 1.2,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onForgotPassword,
            style: secondaryButtonStyle,
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: onCreateAccount,
            style: secondaryButtonStyle,
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
