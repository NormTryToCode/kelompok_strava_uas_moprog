import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/user_profile.dart';

class UserRepository {
  static UserRepository instance = UserRepository();
  final _db = DatabaseService.instance;

  Future<void> ensureProfile(User user) {
    final email = user.email ?? '';
    final handle = email.isNotEmpty
        ? email.split('@').first.toLowerCase()
        : user.uid.substring(0, 8);
    final name = (user.displayName?.trim().isNotEmpty ?? false)
        ? user.displayName!.trim()
        : handle;
    return _db.save('users', user.uid, {'name': name, 'username': handle});
  }

  Future<List<UserProfile>> searchByUsername(String username) async {
    final rows = await _db.getWhere(
      'users',
      'username',
      username.trim().toLowerCase(),
    );
    return rows.map(UserProfile.fromJson).toList();
  }
}