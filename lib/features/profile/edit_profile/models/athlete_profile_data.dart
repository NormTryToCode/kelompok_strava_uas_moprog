import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
      return 'Atlet Stride';
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
    final rawBirthDate = map['birthDate'];
    String parsedBirthDate = fallback.birthDate;
    if (rawBirthDate is String && rawBirthDate.isNotEmpty) {
      parsedBirthDate = rawBirthDate;
    } else if (rawBirthDate is Timestamp) {
      final dt = rawBirthDate.toDate();
      final d = dt.day.toString().padLeft(2, '0');
      final m = dt.month.toString().padLeft(2, '0');
      parsedBirthDate = '$d/$m/${dt.year}';
    }

    final rawWeight = map['weightKg'];
    String parsedWeight = fallback.weightKg;
    if (rawWeight is String && rawWeight.isNotEmpty) {
      parsedWeight = rawWeight;
    } else if (rawWeight is num) {
      parsedWeight = rawWeight.toStringAsFixed(1).replaceAll('.', ',');
    }

    final rawAvatar = map['avatarPath'] as String?;
    final rawPhotoUrl = map['photoUrl'] as String?;
    final parsedAvatar = (rawAvatar != null && rawAvatar.isNotEmpty)
        ? rawAvatar
        : ((rawPhotoUrl != null && rawPhotoUrl.isNotEmpty)
            ? rawPhotoUrl
            : fallback.avatarPath);

    return AthleteProfileData(
      firstName: map['firstName'] as String? ?? fallback.firstName,
      lastName: map['lastName'] as String? ?? fallback.lastName,
      city: map['city'] as String? ?? fallback.city,
      country: map['country'] as String? ?? fallback.country,
      primarySport: map['primarySport'] as String? ?? fallback.primarySport,
      bio: map['bio'] as String? ?? fallback.bio,
      birthDate: parsedBirthDate,
      gender: map['gender'] as String? ?? fallback.gender,
      weightKg: parsedWeight,
      avatarPath: parsedAvatar,
    );
  }
}