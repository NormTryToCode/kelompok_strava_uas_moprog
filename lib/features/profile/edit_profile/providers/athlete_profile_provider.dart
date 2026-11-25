import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/athlete_profile_data.dart';

final athleteProfileProvider =
  NotifierProvider<AthleteProfileNotifier, AthleteProfileData>(
    AthleteProfileNotifier.new,
);

class AthleteProfileNotifier extends Notifier<AthleteProfileData> {
  static const String _collection = 'athlete_profiles';
  static const String _docId = 'current_athlete';

  static const AthleteProfileData _defaultProfile = AthleteProfileData(
    firstName: 'Michael',
    lastName: 'Respati Sanjaya Ho',
    city: 'Jakarta',
    country: 'INDONESIA',
    primarySport: 'Running',
    bio: 'Chasing steady pace and cleaner splits every week.',
    birthDate: '30/08/2007',
    gender: 'Male',
    weightKg: '74.0',
  );

  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();
  StreamSubscription<List>? _firestoreSub;
  bool _isDisposed = false;

  @override
  AthleteProfileData build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
      _firestoreSub?.cancel();
    });

    _loadLocalCache();
    _listenFirestore();
    return _defaultProfile;
  }

  Future<void> _loadLocalCache() async {
    try {
      final String firstName =
        await _asyncPrefs.getString('first_name') ?? state.firstName;
      final String lastName =
        await _asyncPrefs.getString('last_name') ?? state.lastName;
      final String city = await _asyncPrefs.getString('city') ?? state.city;
      final String country =
        await _asyncPrefs.getString('country') ?? state.country;
      final String sport = normalizeAthleteSport(
        await _asyncPrefs.getString('sport') ?? state.primarySport,
      );
      final String savedBio = await _asyncPrefs.getString('text') ?? state.bio;
      final String birthDate =
        await _asyncPrefs.getString('birth_date') ?? state.birthDate;
      final String gender = normalizeAthleteGender(
      await _asyncPrefs.getString('gender') ?? state.gender,
      );
      final String weight =
        await _asyncPrefs.getString('weight_kg') ?? state.weightKg;
      final String avatarPath =
        await _asyncPrefs.getString('avatar_path') ?? state.avatarPath;

      if (_isDisposed) return;
      state = AthleteProfileData(
        firstName: firstName,
        lastName: lastName,
        city: city,
        country: country,
        primarySport: sport,
        bio: savedBio,
        birthDate: birthDate,
        gender: gender,
        weightKg: weight,
        avatarPath: avatarPath,
      );
    } catch (_) {}
  }

  void _listenFirestore() {
    try {
      _firestoreSub = DatabaseService.instance.watch(_collection).listen(
        (docs) {
          if (_isDisposed) return;
          final matches = docs.where((d) => d['id'] == _docId);
          if (matches.isEmpty) return;

          final Map<String, dynamic> remote = matches.first;
          final String remoteAvatar = remote['avatarPath'] as String? ?? '';
          state = AthleteProfileData.fromMap(
            remote,
            fallback: state,
          ).copyWith(
            avatarPath:
              remoteAvatar.isNotEmpty ? remoteAvatar : state.avatarPath,
          );
        },
        onError: (_) {},
      );
    } catch (_) {}
  }

  Future<bool> saveProfile(AthleteProfileData updatedData) async {
    final normalized = updatedData.copyWith(
      primarySport: normalizeAthleteSport(updatedData.primarySport),
      gender: normalizeAthleteGender(updatedData.gender),
    );
    state = normalized;

    await _asyncPrefs.setString('first_name', normalized.firstName);
    await _asyncPrefs.setString('last_name', normalized.lastName);
    await _asyncPrefs.setString('city', normalized.city);
    await _asyncPrefs.setString('country', normalized.country);
    await _asyncPrefs.setString('sport', normalized.primarySport);
    await _asyncPrefs.setString('text', normalized.bio);
    await _asyncPrefs.setString('birth_date', normalized.birthDate);
    await _asyncPrefs.setString('gender', normalized.gender);
    await _asyncPrefs.setString('weight_kg', normalized.weightKg);
    await _asyncPrefs.setString('avatar_path', normalized.avatarPath);

    try {
      await DatabaseService.instance.save(
        _collection,
        _docId,
        normalized.toMap(),
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}