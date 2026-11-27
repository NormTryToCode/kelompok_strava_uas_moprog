/// Shared form field validators for authentication flows.
class AuthValidators {
  AuthValidators._();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Please enter your email';
    }
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? password(
    String? value, {
    String emptyMessage = 'Please enter your password',
  }) {
    final raw = value ?? '';
    if (raw.isEmpty) {
      return emptyMessage;
    }
    if (raw.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
