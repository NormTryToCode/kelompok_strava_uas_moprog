import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_providers.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_service.dart';
import 'package:kelompok_strava_uas_moprog/features/login/providers/remember_me_store.dart';

typedef LoginActionResult = ({bool didSignIn, String? errorMessage});

class LoginState {
  final bool isEmailLoading;
  final bool isGoogleLoading;
  final bool rememberMe;

  const LoginState({
    this.isEmailLoading = false,
    this.isGoogleLoading = false,
    this.rememberMe = false,
  });

  bool get isBusy => isEmailLoading || isGoogleLoading;

  LoginState copyWith({
    bool? isEmailLoading,
    bool? isGoogleLoading,
    bool? rememberMe,
  }) {
    return LoginState(
      isEmailLoading: isEmailLoading ?? this.isEmailLoading,
      isGoogleLoading: isGoogleLoading ?? this.isGoogleLoading,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}

class LoginController extends AutoDisposeNotifier<LoginState> {
  bool _disposed = false;

  @override
  LoginState build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    return const LoginState();
  }

  Future<String?> loadRememberedEmail() async {
    final remembered = await ref.read(rememberMeStoreProvider).load();
    if (!_disposed) {
      state = state.copyWith(rememberMe: remembered.rememberMe);
    }
    if (remembered.rememberMe && remembered.savedEmail.isNotEmpty) {
      return remembered.savedEmail;
    }
    return null;
  }

  void setRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  Future<LoginActionResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isEmailLoading: true);
    try {
      await ref
          .read(authServiceProvider)
          .signInWithEmail(email: email, password: password);
      await ref
          .read(rememberMeStoreProvider)
          .save(rememberMe: state.rememberMe, email: email);
      return (didSignIn: true, errorMessage: null);
    } on AuthException catch (e) {
      return (didSignIn: false, errorMessage: e.message);
    } finally {
      if (!_disposed) {
        state = state.copyWith(isEmailLoading: false);
      }
    }
  }

  Future<LoginActionResult> signInWithGoogle() async {
    state = state.copyWith(isGoogleLoading: true);
    try {
      final credential = await ref.read(authServiceProvider).signInWithGoogle();
      return (didSignIn: credential != null, errorMessage: null);
    } on AuthException catch (e) {
      return (didSignIn: false, errorMessage: e.message);
    } finally {
      if (!_disposed) {
        state = state.copyWith(isGoogleLoading: false);
      }
    }
  }
}

final loginControllerProvider =
    NotifierProvider.autoDispose<LoginController, LoginState>(
      LoginController.new,
    );
