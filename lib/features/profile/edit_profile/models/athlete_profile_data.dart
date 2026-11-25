import 'package:flutter/foundation.dart';

String normalizeAthleteSport(String raw) {
  switch (raw.trim().toLowerCase()) {
    case 'berlari':
    case 'running':
      return 'Running';
    case 'bersepeda':
    case 'cycling':
      return 'Cycling';
    case 'berenang':
    case 'swimming':
      return 'Swimming';
    default:
      return raw.trim().isEmpty ? 'Running' : raw.trim();
  }
}

String normalizeAthleteGender(String raw) {
  switch (raw.trim().toLowerCase()) {
    case 'pria':
    case 'male':
      return 'Male';
    case 'wanita':
    case 'female':
      return 'Female';
    case 'non-biner':
    case 'non-binary':
      return 'Non-binary';
    case 'memilih tidak mengatakan':
    case 'prefer not to say':
      return 'Prefer not to say';
    default:
      return raw.trim().isEmpty ? 'Prefer not to say' : raw.trim();
  }
}

@immutable
class AthleteProfileData {
  final String firstName;
  final String lastName;
  final String city;
  final String country;
  final String primarySport;
  final String bio;
  final String birthDate;
  final String gender;
  final String weightKg;
  final String avatarPath;

  const AthleteProfileData({
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.country,
    required this.primarySport,
    required this.bio,
    required this.birthDate,
    required this.gender,
    required this.weightKg,
    this.avatarPath = '',
  });

  String get fullName {
    final trimmedFirst = firstName.trim();
    final trimmedLast = lastName.trim();
    if (trimmedFirst.isEmpty && trimmedLast.isEmpty) {
      return 'Stride Athlete';
    }
    if (trimmedLast.isEmpty) return trimmedFirst;
    if (trimmedFirst.isEmpty) return trimmedLast;
    return '$trimmedFirst $trimmedLast';
  }

  double get parsedWeightKg {
    final normalized = weightKg.replaceAll(',', '.');
    return double.tryParse(normalized) ?? 74.0;
  }

  AthleteProfileData copyWith({
    String? firstName,
    String? lastName,
    String? city,
    String? country,
    String? primarySport,
    String? bio,
    String? birthDate,
    String? gender,
    String? weightKg,
    String? avatarPath,
  }) {
    return AthleteProfileData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      city: city ?? this.city,
      country: country ?? this.country,
      primarySport: primarySport ?? this.primarySport,
      bio: bio ?? this.bio,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      weightKg: weightKg ?? this.weightKg,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'city': city,
      'country': country,
      'primarySport': primarySport,
      'bio': bio,
      'birthDate': birthDate,
      'gender': gender,
      'weightKg': weightKg,
      'avatarPath': avatarPath,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  factory AthleteProfileData.fromMap(
    Map<String, dynamic> map, {
    required AthleteProfileData fallback,
  }) {
    return AthleteProfileData(
      firstName: map['firstName'] as String? ?? fallback.firstName,
      lastName: map['lastName'] as String? ?? fallback.lastName,
      city: map['city'] as String? ?? fallback.city,
      country: map['country'] as String? ?? fallback.country,
      primarySport: normalizeAthleteSport(
        map['primarySport'] as String? ?? fallback.primarySport,
      ),
      bio: map['bio'] as String? ?? fallback.bio,
      birthDate: map['birthDate'] as String? ?? fallback.birthDate,
      gender: normalizeAthleteGender(
        map['gender'] as String? ?? fallback.gender,
      ),
      weightKg: map['weightKg'] as String? ?? fallback.weightKg,
      avatarPath: map['avatarPath'] as String? ?? fallback.avatarPath,
    );
  }
}