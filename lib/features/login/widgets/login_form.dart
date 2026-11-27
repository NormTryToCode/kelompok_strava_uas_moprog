import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/widgets/auth_card.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/widgets/auth_header.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/widgets/auth_or_divider.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/widgets/auth_primary_button.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/widgets/google_auth_button.dart';
import 'package:kelompok_strava_uas_moprog/features/forget-password/forget_password.dart';
import 'package:kelompok_strava_uas_moprog/features/login/providers/login_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/login/widgets/login_credentials_fields.dart';
import 'package:kelompok_strava_uas_moprog/features/login/widgets/login_secondary_actions.dart';
import 'package:kelompok_strava_uas_moprog/features/register/register_page.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/checkbox_widget.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(_hydrateRememberedEmail);
  }

  Future<void> _hydrateRememberedEmail() async {
    if (!mounted) return;
    final savedEmail = await ref
        .read(loginControllerProvider.notifier)
        .loadRememberedEmail();
    if (!mounted || savedEmail == null) return;
    if (_emailController.text.isEmpty) {
      _emailController.text = savedEmail;
    }
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

  void _handleAuthResult(LoginActionResult result) {
    if (!mounted) return;
    if (result.didSignIn) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (result.errorMessage != null) {
      _showErrorSnackBar(result.errorMessage!);
    }
  }

  Future<void> _submitEmailLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final result = await ref
        .read(loginControllerProvider.notifier)
        .signInWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );
    _handleAuthResult(result);
  }

  Future<void> _submitGoogleLogin() async {
    FocusScope.of(context).unfocus();
    final result = await ref
        .read(loginControllerProvider.notifier)
        .signInWithGoogle();
    _handleAuthResult(result);
  }

  void _openForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgetPassword()),
    );
  }

  void _openRegister() {
    final route = MaterialPageRoute(builder: (context) => const RegisterPage());
    if (Navigator.canPop(context)) {
      Navigator.pushReplacement(context, route);
    } else {
      Navigator.push(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    final controller = ref.read(loginControllerProvider.notifier);

    return AuthCard(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AuthHeader(
              title: "Let's Start Running!",
              subtitle: 'Track every mile, beat your personal best.',
            ),
            const SizedBox(height: 24),
            LoginCredentialsFields(
              emailController: _emailController,
              passwordController: _passwordController,
              onSubmitted: state.isBusy ? null : _submitEmailLogin,
            ),
            const SizedBox(height: 6),
            Theme(
              data: Theme.of(context)
                  .copyWith(visualDensity: VisualDensity.compact),
              child: CheckBoxWidget(
                checkBoxText: 'Remember Me',
                value: state.rememberMe,
                onChanged: controller.setRememberMe,
              ),
            ),
            const SizedBox(height: 18),
            AuthPrimaryButton(
              label: 'Login',
              isLoading: state.isEmailLoading,
              onPressed: state.isBusy ? null : _submitEmailLogin,
            ),
            const SizedBox(height: 20),
            const AuthOrDivider(),
            const SizedBox(height: 20),
            GoogleAuthButton(
              label: 'Login with Google',
              isLoading: state.isGoogleLoading,
              onPressed: state.isBusy ? null : _submitGoogleLogin,
            ),
            const SizedBox(height: 16),
            LoginSecondaryActions(
              onForgotPassword: state.isBusy ? null : _openForgotPassword,
              onCreateAccount: state.isBusy ? null : _openRegister,
            ),
          ],
        ),
      ),
    );
  }
}
