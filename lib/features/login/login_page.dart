import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/widgets/auth_scaffold.dart';
import 'package:kelompok_strava_uas_moprog/features/login/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthScaffold(child: LoginForm());
  }
}
