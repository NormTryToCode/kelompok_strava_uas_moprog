import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_providers.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_service.dart';
import 'package:kelompok_strava_uas_moprog/features/forget-password/forget_password.dart';
import 'package:kelompok_strava_uas_moprog/features/login/login_page.dart';
import 'package:kelompok_strava_uas_moprog/features/register/register_page.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/auth_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeUserCredential implements UserCredential {
  @override
  User? get user => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAuthService implements AuthService {
  int emailSignInCalls = 0;
  int googleSignInCalls = 0;
  int signUpCalls = 0;
  int resetCalls = 0;

  String? lastEmail;
  String? lastPassword;
  String? lastDisplayName;

  UserCredential? googleResult = _FakeUserCredential();
  AuthException? errorToThrow;

  @override
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emailSignInCalls++;
    lastEmail = email;
    lastPassword = password;
    if (errorToThrow != null) throw errorToThrow!;
    return _FakeUserCredential();
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    googleSignInCalls++;
    if (errorToThrow != null) throw errorToThrow!;
    return googleResult;
  }

  @override
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    signUpCalls++;
    lastEmail = email;
    lastPassword = password;
    lastDisplayName = displayName;
    if (errorToThrow != null) throw errorToThrow!;
    return _FakeUserCredential();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    resetCalls++;
    lastEmail = email;
    if (errorToThrow != null) throw errorToThrow!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFirebaseAuth implements FirebaseAuth {
  int signInWithProviderCalls = 0;
  AuthProvider? lastProvider;

  @override
  Future<UserCredential> signInWithProvider(AuthProvider provider) async {
    signInWithProviderCalls++;
    lastProvider = provider;
    return _FakeUserCredential();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeGoogleSignIn implements GoogleSignIn {
  _FakeGoogleSignIn({this.exceptionToThrow});

  final GoogleSignInException? exceptionToThrow;
  int authenticateCalls = 0;

  @override
  Future<GoogleSignInAccount> authenticate({
    List<String> scopeHint = const <String>[],
  }) async {
    authenticateCalls++;
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    throw const GoogleSignInException(
      code: GoogleSignInExceptionCode.canceled,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void _tallScreen(WidgetTester tester) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(800, 1400);
  addTearDown(tester.view.reset);
}

ThemeData _appDarkTheme() {
  return ThemeData.dark(useMaterial3: true).copyWith(
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
  );
}

Widget _wrapWithRoot({
  required AuthService authService,
  required Widget child,
}) {
  return ProviderScope(
    overrides: [authServiceProvider.overrideWithValue(authService)],
    child: MaterialApp(
      theme: _appDarkTheme(),
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => child),
              ),
              child: const Text('Open Auth Page'),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
      'AuthTextField renders dark text on white background in dark theme and toggles visibility',
      (tester) async {
    final controller = TextEditingController(text: 'secret123');
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: _appDarkTheme(),
        home: Scaffold(
          body: AuthTextField(
            controller: controller,
            hintText: 'Password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
          ),
        ),
      ),
    );

    final editableText = tester.widget<EditableText>(find.byType(EditableText));
    expect(editableText.style.color, const Color(0xFF110E1B));
    expect(editableText.obscureText, isTrue);

    final inputDecorator =
        tester.widget<InputDecorator>(find.byType(InputDecorator));
    expect(inputDecorator.decoration.fillColor, Colors.white);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();

    final updatedEditable =
        tester.widget<EditableText>(find.byType(EditableText));
    expect(updatedEditable.obscureText, isFalse);
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  testWidgets(
      'LoginPage validates inputs, saves Remember Me, signs in, and pops to root',
      (tester) async {
    _tallScreen(tester);
    final fakeAuth = _FakeAuthService();

    await tester.pumpWidget(
      _wrapWithRoot(authService: fakeAuth, child: const LoginPage()),
    );
    await tester.tap(find.text('Open Auth Page'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
    expect(fakeAuth.emailSignInCalls, 0);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'runner@stride.online',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Remember Me'));
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(fakeAuth.emailSignInCalls, 1);
    expect(fakeAuth.lastEmail, 'runner@stride.online');
    expect(fakeAuth.lastPassword, 'password123');
    expect(find.text('Open Auth Page'), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('auth_remember_me'), isTrue);
    expect(prefs.getString('auth_saved_email'), 'runner@stride.online');
  });

  testWidgets(
      'LoginPage Google sign-in pops on success, stays on cancel, and shows error on failure',
      (tester) async {
    _tallScreen(tester);
    final fakeAuth = _FakeAuthService()..googleResult = null;

    await tester.pumpWidget(
      _wrapWithRoot(authService: fakeAuth, child: const LoginPage()),
    );
    await tester.tap(find.text('Open Auth Page'));
    await tester.pumpAndSettle();

    // Canceled returns null -> stays on LoginPage without error snackbar
    await tester.tap(find.text('Login with Google'));
    await tester.pumpAndSettle();
    expect(fakeAuth.googleSignInCalls, 1);
    expect(find.text('Login with Google'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);

    // AuthException -> stays on LoginPage and shows SnackBar
    fakeAuth.errorToThrow = const AuthException('Google auth failed');
    await tester.tap(find.text('Login with Google'));
    await tester.pumpAndSettle();
    expect(find.text('Google auth failed'), findsOneWidget);

    // Success -> pops back to root
    fakeAuth
      ..errorToThrow = null
      ..googleResult = _FakeUserCredential();
    await tester.tap(find.text('Login with Google'));
    await tester.pumpAndSettle();
    expect(find.text('Open Auth Page'), findsOneWidget);
  });

  testWidgets(
      'RegisterPage validates terms, registers user, and switches to LoginPage',
      (tester) async {
    _tallScreen(tester);
    final fakeAuth = _FakeAuthService();

    await tester.pumpWidget(
      _wrapWithRoot(authService: fakeAuth, child: const RegisterPage()),
    );
    await tester.tap(find.text('Open Auth Page'));
    await tester.pumpAndSettle();

    // Tapping "Already have an account? Login" navigates to LoginPage (not root)
    await tester.tap(find.text('Already have an account? Login'));
    await tester.pumpAndSettle();
    expect(find.text("Let's Start Running!"), findsOneWidget);
    expect(find.text('Open Auth Page'), findsNothing);

    // Navigate back to RegisterPage
    await tester.tap(find.text('Create an Account'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'alex@stride.club',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'Alex Runner');
    await tester.enterText(find.byType(TextFormField).at(2), 'secret123');
    await tester.enterText(find.byType(TextFormField).at(3), 'secret123');

    // Missing Terms checkbox shows snackbar and blocks registration
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pumpAndSettle();
    expect(find.text('Please agree to the Terms & Services.'), findsOneWidget);
    expect(fakeAuth.signUpCalls, 0);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pumpAndSettle();

    expect(fakeAuth.signUpCalls, 1);
    expect(fakeAuth.lastEmail, 'alex@stride.club');
    expect(fakeAuth.lastDisplayName, 'Alex Runner');
    expect(find.text('Open Auth Page'), findsOneWidget);
  });

  testWidgets('ForgetPassword validates email and transitions to confirmation',
      (tester) async {
    _tallScreen(tester);
    final fakeAuth = _FakeAuthService();

    await tester.pumpWidget(
      _wrapWithRoot(authService: fakeAuth, child: const ForgetPassword()),
    );
    await tester.tap(find.text('Open Auth Page'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Send Reset Link'));
    await tester.pumpAndSettle();
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(fakeAuth.resetCalls, 0);

    await tester.enterText(
      find.byType(TextFormField).first,
      'runner@stride.online',
    );
    await tester.tap(find.text('Send Reset Link'));
    await tester.pumpAndSettle();

    expect(fakeAuth.resetCalls, 1);
    expect(fakeAuth.lastEmail, 'runner@stride.online');
    expect(find.text('Check Your Email'), findsOneWidget);
    expect(find.text('Try Another Email'), findsOneWidget);
  });

  test(
      'AuthService.signInWithGoogle returns null on cancel and falls back to signInWithProvider on native error',
      () async {
    final canceledGoogle = _FakeGoogleSignIn(
      exceptionToThrow: const GoogleSignInException(
        code: GoogleSignInExceptionCode.canceled,
      ),
    );
    final canceledFirebase = _FakeFirebaseAuth();
    final canceledService = AuthService(
      firebaseAuth: canceledFirebase,
      googleSignIn: canceledGoogle,
    );

    final canceledResult = await canceledService.signInWithGoogle();
    expect(canceledResult, isNull);
    expect(canceledGoogle.authenticateCalls, 1);
    expect(canceledFirebase.signInWithProviderCalls, 0);

    final failedGoogle = _FakeGoogleSignIn(
      exceptionToThrow: const GoogleSignInException(
        code: GoogleSignInExceptionCode.unknownError,
        description: 'No credential available',
      ),
    );
    final fallbackFirebase = _FakeFirebaseAuth();
    final fallbackService = AuthService(
      firebaseAuth: fallbackFirebase,
      googleSignIn: failedGoogle,
    );

    final fallbackResult = await fallbackService.signInWithGoogle();
    expect(fallbackResult, isNotNull);
    expect(failedGoogle.authenticateCalls, 1);
    expect(fallbackFirebase.signInWithProviderCalls, 1);
    expect(fallbackFirebase.lastProvider, isA<GoogleAuthProvider>());
  });
}
