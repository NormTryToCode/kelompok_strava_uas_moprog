import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_providers.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_service.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/widgets/auth_card.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/widgets/auth_header.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/widgets/auth_or_divider.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/widgets/auth_primary_button.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/widgets/google_auth_button.dart';
import 'package:kelompok_strava_uas_moprog/features/forget-password/forget_password.dart';
import 'package:kelompok_strava_uas_moprog/features/login/widgets/login_credentials_fields.dart';
import 'package:kelompok_strava_uas_moprog/features/register/register_page.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/checkbox_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWidget extends ConsumerStatefulWidget {
  const LoginWidget({super.key});

  @override
  ConsumerState<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends ConsumerState<LoginWidget> {
  static const _rememberMeKey = 'auth_remember_me';
  static const _savedEmailKey = 'auth_saved_email';

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isEmailLoading = false;
  bool _isGoogleLoading = false;
  bool _rememberMe = false;

  bool get _isBusy => _isEmailLoading || _isGoogleLoading;

  @override
  void initState() {
    super.initState();
    _loadRememberedEmail();
  }

  Future<void> _loadRememberedEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final remember = prefs.getBool(_rememberMeKey) ?? false;
      final savedEmail = prefs.getString(_savedEmailKey) ?? '';
      if (!mounted) return;
      setState(() {
        _rememberMe = remember;
        if (remember &&
            savedEmail.isNotEmpty &&
            _emailController.text.isEmpty) {
          _emailController.text = savedEmail;
        }
      });
    } catch (_) {}
  }

  Future<void> _persistRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberMeKey, _rememberMe);
      if (_rememberMe) {
        await prefs.setString(_savedEmailKey, _emailController.text.trim());
      } else {
        await prefs.remove(_savedEmailKey);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

  Future<void> _handleEmailLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isEmailLoading = true);
    try {
      await ref.read(authServiceProvider).signInWithEmail(
            email: _emailController.text,
            password: _passwordController.text,
          );
      await _persistRememberMe();
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on AuthException catch (e) {
      _showErrorSnackBar(e.message);
    } finally {
      if (mounted) setState(() => _isEmailLoading = false);
    }
  }

  Future<void> _handleGoogleLogin() async {
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
    final secondaryButtonStyle = OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.white.withValues(alpha: 0.08),
      side: BorderSide(color: Colors.white.withValues(alpha: 0.45), width: 1.2),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return AuthCard(
      child: Form(
        key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AuthHeader(
                    title: "Let's Start Running!",
                    subtitle: "Track every mile, beat your personal best.",
                  ),
                  const SizedBox(height: 24),
                  LoginCredentialsFields(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    onSubmitted: _isBusy ? null : _handleEmailLogin,
                  ),
                  const SizedBox(height: 6),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(visualDensity: VisualDensity.compact),
                    child: CheckBoxWidget(
                      checkBoxText: "Remember Me",
                      value: _rememberMe,
                      onChanged: (value) => setState(() => _rememberMe = value),
                    ),
                  ),
                  const SizedBox(height: 18),
                  AuthPrimaryButton(
                    label: 'Login',
                    isLoading: _isEmailLoading,
                    onPressed: _isBusy ? null : _handleEmailLogin,
                  ),
                  const SizedBox(height: 20),
                  const AuthOrDivider(),
                  const SizedBox(height: 20),
                  GoogleAuthButton(
                    label: 'Login with Google',
                    isLoading: _isGoogleLoading,
                    onPressed: _isBusy ? null : _handleGoogleLogin,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isBusy
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgetPassword(),
                                    ),
                                  );
                                },
                          style: secondaryButtonStyle,
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Forgot Password?",
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
                          onPressed: _isBusy
                              ? null
                              : () {
                                  final route = MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  );
                                  if (Navigator.canPop(context)) {
                                    Navigator.pushReplacement(context, route);
                                  } else {
                                    Navigator.push(context, route);
                                  }
                                },
                          style: secondaryButtonStyle,
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Create an Account",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
