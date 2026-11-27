import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AuthService {
  AuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
        _hasCustomGoogleSignIn = googleSignIn != null;

  static const String googleServerClientId =
      '971947737969-p78743s232el6tea5r25u6i4a16jiu3l.apps.googleusercontent.com';
  static const String googleIosClientId =
      '971947737969-ia5akn3qp2j978qiogvqnkg51hfv8ch7.apps.googleusercontent.com';

  static bool _googleInitialized = false;

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final bool _hasCustomGoogleSignIn;

  static Future<void> initializeGoogleSignIn() async {
    if (_googleInitialized || kIsWeb) return;
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) {
      return;
    }

    try {
      await GoogleSignIn.instance.initialize(
        clientId: defaultTargetPlatform == TargetPlatform.iOS
            ? googleIosClientId
            : null,
        serverClientId: googleServerClientId,
      );
      _googleInitialized = true;
    } catch (e) {
      debugPrint('AuthService: GoogleSignIn initialize failed: $e');
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await _syncUserProfile(credential.user, authProvider: 'email');
      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e));
    } catch (e) {
      debugPrint('AuthService: signInWithEmail error: $e');
      throw const AuthException(
        'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final trimmedName = displayName?.trim();
      if (trimmedName != null && trimmedName.isNotEmpty) {
        await credential.user?.updateDisplayName(trimmedName);
        await credential.user?.reload();
      }
      await _syncUserProfile(
        _auth.currentUser ?? credential.user,
        authProvider: 'email',
        username: trimmedName,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e));
    } catch (e) {
      debugPrint('AuthService: signUpWithEmail error: $e');
      throw const AuthException(
        'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw const AuthException('No account found with this email address.');
      }
      throw AuthException(_mapFirebaseError(e));
    } catch (e) {
      debugPrint('AuthService: sendPasswordResetEmail error: $e');
      throw const AuthException(
        'Unable to send password reset email. Please try again.',
      );
    }
  }

  GoogleAuthProvider _buildGoogleProvider() {
    return GoogleAuthProvider()
      ..addScope('email')
      ..addScope('profile')
      ..setCustomParameters(const {'prompt': 'select_account'});
  }

  Future<UserCredential> _signInWithGoogleProvider() async {
    final provider = _buildGoogleProvider();
    final credential = await _auth.signInWithProvider(provider);
    await _syncUserProfile(credential.user, authProvider: 'google');
    return credential;
  }

  bool _isCancellationCode(String code) {
    return code == 'popup-closed-by-user' ||
        code == 'cancelled-popup-request' ||
        code == 'web-context-canceled' ||
        code == 'cancelled' ||
        code == 'user-cancelled';
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb && !_hasCustomGoogleSignIn) {
        final credential = await _auth.signInWithPopup(_buildGoogleProvider());
        await _syncUserProfile(credential.user, authProvider: 'google');
        return credential;
      }

      if (_hasCustomGoogleSignIn ||
          defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        if (!_hasCustomGoogleSignIn && !_googleInitialized) {
          await initializeGoogleSignIn();
        }
        try {
          final GoogleSignInAccount googleUser =
              await _googleSignIn.authenticate(
            scopeHint: const ['email', 'profile'],
          );
          final String? idToken = googleUser.authentication.idToken;
          if (idToken != null) {
            final credential = await _auth.signInWithCredential(
              GoogleAuthProvider.credential(idToken: idToken),
            );
            await _syncUserProfile(credential.user, authProvider: 'google');
            return credential;
          }
          debugPrint(
            'AuthService: Google Sign-In returned null idToken; falling back to Firebase provider flow.',
          );
          return await _signInWithGoogleProvider();
        } on GoogleSignInException catch (e) {
          if (e.code == GoogleSignInExceptionCode.canceled) {
            return null;
          }
          debugPrint(
            'AuthService: GoogleSignInException (${e.code.name}): ${e.description}; falling back to Firebase provider flow.',
          );
          try {
            return await _signInWithGoogleProvider();
          } on UnimplementedError catch (_) {
            throw AuthException('Google Sign-In failed (${e.code.name}).');
          }
        }
      }

      return await _signInWithGoogleProvider();
    } on AuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      if (_isCancellationCode(e.code)) {
        return null;
      }
      debugPrint('AuthService: FirebaseAuthException (${e.code}): ${e.message}');
      throw AuthException(_mapFirebaseError(e));
    } catch (e) {
      debugPrint('AuthService: signInWithGoogle error: $e');
      throw const AuthException(
        'Unable to sign in with Google right now. Please try again.',
      );
    }
  }

  Future<void> _syncUserProfile(
    User? user, {
    required String authProvider,
    String? username,
  }) async {
    if (user == null) return;
    try {
      await DatabaseService.instance
          .syncUserOnAuth(
            firebaseUser: user,
            authProvider: authProvider,
            username: username,
          )
          .timeout(const Duration(seconds: 4));
    } catch (e) {
      debugPrint('AuthService: syncUserOnAuth skipped/failed: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    if (_googleInitialized || _hasCustomGoogleSignIn) {
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        debugPrint('AuthService: GoogleSignIn signOut skipped/failed: $e');
      }
    }
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    final message = e.message ?? '';
    if (message.contains('DEVELOPER_ERROR') ||
        message.contains('12500') ||
        message.contains('10:')) {
      return 'Google Sign-In is not authorized for this app build (check SHA-1 in Firebase Console).';
    }

    switch (e.code) {
      case 'invalid-credential':
      case 'invalid-login-credentials':
      case 'wrong-password':
      case 'user-not-found':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'popup-blocked':
        return 'Sign-in popup was blocked. Please allow popups and try again.';
      case 'invalid-app-credential':
      case 'app-not-authorized':
        return 'Google Sign-In is not authorized for this app build (check SHA-1 in Firebase Console).';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
