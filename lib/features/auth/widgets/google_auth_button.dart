import 'package:flutter/material.dart';

/// Google sign-in/sign-up button with an asset icon fallback and loading state.
class GoogleAuthButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const GoogleAuthButton({
    super.key,
    this.label = 'Login with Google',
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF110E1B),
              ),
            )
          : Image.asset(
              'asset/images/google.png',
              height: 20,
              width: 20,
              errorBuilder: (_, _, _) => const Icon(
                Icons.g_mobiledata_rounded,
                size: 24,
                color: Color(0xFF110E1B),
              ),
            ),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF110E1B),
        disabledBackgroundColor: Colors.white.withValues(alpha: 0.8),
        disabledForegroundColor: Colors.black54,
        elevation: 0,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
