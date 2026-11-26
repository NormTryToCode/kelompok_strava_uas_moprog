import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_providers.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_service.dart';
import 'package:kelompok_strava_uas_moprog/features/login/login_page.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/auth_text_field.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/checkbox_widget.dart';

class RegisterWidget extends ConsumerStatefulWidget {
  const RegisterWidget({super.key});

  @override
  ConsumerState<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends ConsumerState<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isRegisterLoading = false;
  bool _isGoogleLoading = false;
  bool _agreedToTerms = false;

  bool get _isBusy => _isRegisterLoading || _isGoogleLoading;

  static final _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _showTermsSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Styles.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Stride Terms & Services',
                style: TextStyle(
                  color: Styles.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'By creating a Stride account, you agree to:',
                style: TextStyle(
                  color: Styles.textSecondary,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  '• Provide accurate account details and keep your credentials secure.',
                  style: TextStyle(color: Styles.textPrimary, fontSize: 14),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  '• Allow Stride to store your activity logs, GPS routes, and profile preferences in Firebase.',
                  style: TextStyle(color: Styles.textPrimary, fontSize: 14),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  '• Follow community guidelines when posting in clubs and challenges.',
                  style: TextStyle(color: Styles.textPrimary, fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: Styles.primary,
                    foregroundColor: Styles.textPrimary,
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    if (!_agreedToTerms) {
      _showErrorSnackBar('Please agree to the Terms & Services.');
      return;
    }

    setState(() => _isRegisterLoading = true);
    try {
      await ref.read(authServiceProvider).signUpWithEmail(
            email: _emailController.text,
            password: _passwordController.text,
            displayName: _nameController.text,
          );
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on AuthException catch (e) {
      _showErrorSnackBar(e.message);
    } finally {
      if (mounted) setState(() => _isRegisterLoading = false);
    }
  }

  Future<void> _handleGoogleRegister() async {
    FocusScope.of(context).unfocus();

    setState(() => _isGoogleLoading = true);
    try {
      final credential =
          await ref.read(authServiceProvider).signInWithGoogle();
      if (credential != null && mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on AuthException catch (e) {
      _showErrorSnackBar(e.message);
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6D4AFF), Color(0xFF432C85)],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.16),
                width: 1.2,
              ),
              boxShadow: Styles.ambientGlow(
                color: Styles.primary,
                intensity: 0.35,
                blur: 36,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_run_rounded,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Register As New User",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Start your first step with us.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AuthTextField(
                    controller: _emailController,
                    hintText: "Email (e.g. cake@gmail.com)",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty) return 'Please enter your email';
                      if (!_emailRegex.hasMatch(email)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: _nameController,
                    hintText: "Full Name",
                    prefixIcon: Icons.person_outline,
                    autofillHints: const [AutofillHints.name],
                    validator: (value) {
                      if ((value?.trim() ?? '').isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: _passwordController,
                    hintText: "Password",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: (value) {
                      final password = value ?? '';
                      if (password.isEmpty) return 'Please enter a password';
                      if (password.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: _confirmPasswordController,
                    hintText: "Confirm Password",
                    prefixIcon: Icons.lock_reset_outlined,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.newPassword],
                    onFieldSubmitted: (_) {
                      if (!_isBusy) _handleRegister();
                    },
                    validator: (value) {
                      if ((value ?? '').isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 6),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(visualDensity: VisualDensity.compact),
                    child: CheckBoxWidget(
                      checkBoxText: "I agree to the ",
                      linkText: "Terms & Services",
                      onLinkTap: _showTermsSheet,
                      value: _agreedToTerms,
                      onChanged: (value) {
                        setState(() => _agreedToTerms = value);
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: _isBusy ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF191136),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          const Color(0xFF191136).withValues(alpha: 0.6),
                      disabledForegroundColor: Colors.white70,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isRegisterLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(color: Colors.white54, thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.white54, thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _isBusy ? null : _handleGoogleRegister,
                    icon: _isGoogleLoading
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
                    label: const Text(
                      "Register with Google",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF110E1B),
                      disabledBackgroundColor:
                          Colors.white.withValues(alpha: 0.8),
                      disabledForegroundColor: Colors.black54,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _isBusy ? null : _goToLogin,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.45),
                        width: 1.2,
                      ),
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
