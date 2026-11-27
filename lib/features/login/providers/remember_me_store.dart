import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberedCredentials {
  final bool rememberMe;
  final String savedEmail;

  const RememberedCredentials({this.rememberMe = false, this.savedEmail = ''});
}

/// Persists the "Remember Me" preference and last signed-in email locally.
class RememberMeStore {
  static const String rememberMeKey = 'auth_remember_me';
  static const String savedEmailKey = 'auth_saved_email';

  const RememberMeStore();

  Future<RememberedCredentials> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return RememberedCredentials(
        rememberMe: prefs.getBool(rememberMeKey) ?? false,
        savedEmail: prefs.getString(savedEmailKey) ?? '',
      );
    } catch (_) {
      return const RememberedCredentials();
    }
  }

  Future<void> save({required bool rememberMe, required String email}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(rememberMeKey, rememberMe);
      if (rememberMe) {
        await prefs.setString(savedEmailKey, email.trim());
      } else {
        await prefs.remove(savedEmailKey);
      }
    } catch (_) {}
  }
}

final rememberMeStoreProvider = Provider<RememberMeStore>((ref) {
  return const RememberMeStore();
});
