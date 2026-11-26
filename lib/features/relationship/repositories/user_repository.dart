import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/user_profile.dart';

class UserRepository {
  static UserRepository instance = UserRepository();
  final _db = DatabaseService.instance;

  Future<List<UserProfile>> getAll() async {
    final rows = await _db.getAll('athlete_profiles');
    return rows
        .where((r) => r['deletedAt'] == null)
        .map(UserProfile.fromJson)
        .toList();
  }

  Future<List<UserProfile>> search(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    final me = FirebaseAuth.instance.currentUser?.uid;
    final all = await getAll();
    return all
        .where((u) =>
            u.uid != me &&
            (u.name.toLowerCase().contains(q) || u.username.contains(q)))
        .toList();
  }
}