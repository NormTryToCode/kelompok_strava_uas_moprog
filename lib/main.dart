import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_gate.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_service.dart';
import 'package:kelompok_strava_uas_moprog/firebase_options.dart';
import 'package:media_kit/media_kit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GoogleSignIn.instance.initialize(
    serverClientId: AuthService.googleServerClientId,
  );
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: Styles.canvas,
          canvasColor: Styles.canvas,
          colorScheme: const ColorScheme.dark(
            primary: Styles.primary,
            onPrimary: Styles.textPrimary,
            secondary: Styles.primaryLight,
            surface: Styles.surface,
            onSurface: Styles.textPrimary,
            error: Styles.danger,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Styles.canvas,
            foregroundColor: Styles.textPrimary,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: _DarkCanvasPageTransitionsBuilder(),
              TargetPlatform.iOS: _DarkCanvasPageTransitionsBuilder(),
              TargetPlatform.linux: _DarkCanvasPageTransitionsBuilder(),
              TargetPlatform.macOS: _DarkCanvasPageTransitionsBuilder(),
              TargetPlatform.windows: _DarkCanvasPageTransitionsBuilder(),
            },
          ),
        ),
        home: const AuthGate(),
      ),
    ),
  );
}

class _DarkCanvasPageTransitionsBuilder extends PageTransitionsBuilder {
  const _DarkCanvasPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return ColoredBox(
      color: Styles.canvas,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.06, 0),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(
          opacity: curved,
          child: child,
        ),
      ),
    );
  }
}