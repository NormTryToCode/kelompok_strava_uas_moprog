import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_providers.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_service.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/widgets/auth_card.dart';
import 'package:kelompok_strava_uas_moprog/features/forget-password/forget_password.dart';
import 'package:kelompok_strava_uas_moprog/features/register/register_page.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/auth_text_field.dart';
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

  static final _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

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
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Image.asset(
                      'asset/images/Logo.png'
                    ),),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Let's Start Running!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Track every mile, beat your personal best.",
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
                    hintText: "Enter your email",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!_emailRegex.hasMatch(email)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: _passwordController,
                    hintText: "Enter your password",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    onFieldSubmitted: (_) {
                      if (!_isBusy) _handleEmailLogin();
                    },
                    validator: (value) {
                      final password = value ?? '';
                      if (password.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (password.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
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
                  ElevatedButton(
                    onPressed: _isBusy ? null : _handleEmailLogin,
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
                    child: _isEmailLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Login",
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
                    onPressed: _isBusy ? null : _handleGoogleLogin,
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
                      "Login with Google",
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
