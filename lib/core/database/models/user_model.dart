import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String? lastName; 
  final String? photoUrl;
  final String? city; 
  final String? country; 
  final String? primarySport; 
  final String? bio; 
  final Timestamp? birthDate; 
  final String? gender; 
  final double? weightKg; 
  final String authProvider; 
  final String role; 
  final double totalDistanceMeters;
  final int totalActivitiesCount;
  final int followersCount;
  final int followingCount;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final Timestamp? deletedAt;

  const UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    this.lastName,
    this.photoUrl,
    this.city,
    this.country,
    this.primarySport,
    this.bio,
    this.birthDate,
    this.gender,
    this.weightKg,
    this.authProvider = 'email',
    this.role = 'user',
    this.totalDistanceMeters = 0.0,
    this.totalActivitiesCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  String get fullName {
    final last = lastName?.trim();
    if (last != null && last.isNotEmpty) {
      return '${firstName.trim()} $last';
    }
    return firstName.trim();
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      uid: docId,
      email: map['email'] as String? ?? '',
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      city: map['city'] as String?,
      country: map['country'] as String?,
      primarySport: map['primarySport'] as String?,
      bio: map['bio'] as String?,
      birthDate: map['birthDate'] as Timestamp?,
      gender: map['gender'] as String?,
      weightKg: (map['weightKg'] as num?)?.toDouble(),
      authProvider: map['authProvider'] as String? ?? 'email',
      role: map['role'] as String? ?? 'user',
      totalDistanceMeters: (map['totalDistanceMeters'] as num?)?.toDouble() ?? 0.0,
      totalActivitiesCount: (map['totalActivitiesCount'] as num?)?.toInt() ?? 0,
      followersCount: (map['followersCount'] as num?)?.toInt() ?? 0,
      followingCount: (map['followingCount'] as num?)?.toInt() ?? 0,
      createdAt: map['createdAt'] as Timestamp?,
      updatedAt: map['updatedAt'] as Timestamp?,
      deletedAt: map['deletedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName.trim(),
      'lastName': lastName,
      'photoUrl': photoUrl,
      'city': city,
      'country': country,
      'primarySport': primarySport,
      'bio': bio,
      'birthDate': birthDate,
      'gender': gender,
      'weightKg': weightKg,
      'authProvider': authProvider,
      'role': role,
      'totalDistanceMeters': totalDistanceMeters,
      'totalActivitiesCount': totalActivitiesCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'deletedAt': deletedAt,
    };
  }

  UserModel copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? photoUrl,
    String? city,
    String? country,
    String? primarySport,
    String? bio,
    Timestamp? birthDate,
    String? gender,
    double? weightKg,
    String? authProvider,
    String? role,
    double? totalDistanceMeters,
    int? totalActivitiesCount,
    int? followersCount,
    int? followingCount,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    Timestamp? deletedAt,
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      photoUrl: photoUrl ?? this.photoUrl,
      city: city ?? this.city,
      country: country ?? this.country,
      primarySport: primarySport ?? this.primarySport,
      bio: bio ?? this.bio,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      weightKg: weightKg ?? this.weightKg,
      authProvider: authProvider ?? this.authProvider,
      role: role ?? this.role,
      totalDistanceMeters: totalDistanceMeters ?? this.totalDistanceMeters,
      totalActivitiesCount: totalActivitiesCount ?? this.totalActivitiesCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  static CollectionReference<UserModel> collection(FirebaseFirestore db) {
    return db.collection('athlete_profiles').withConverter<UserModel>(
          fromFirestore: (snap, _) => UserModel.fromMap(snap.data() ?? {}, snap.id),
          toFirestore: (model, _) => model.toMap(),
        );
  }
}
