import 'package:firebase_auth/firebase_auth.dart';

const String defaultStorageUserId = 'default_user';

String resolveStorageUserId() {
  try {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && uid.isNotEmpty) return uid;
  } catch (_) {
  }
  return defaultStorageUserId;
}