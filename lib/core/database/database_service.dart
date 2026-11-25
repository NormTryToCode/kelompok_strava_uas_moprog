import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'models/user_model.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List>> getAll(String collection) async {
    final snap = await _db.collection(collection).get();
    return snap.docs.map((d) => {...d.data(), 'id': d.id}).toList();
  }

  Future<List>> getWhere(
    String collection,
    String field,
    Object value,
  ) async {
    final snap =
        await _db.collection(collection).where(field, isEqualTo: value).get();
    return snap.docs.map((d) => {...d.data(), 'id': d.id}).toList();
  }

  Future<void> save(
    String collection,
    String id,
    Map<String, dynamic> data, {
    bool merge = false,
  }) async {
    debugPrint('Firestore save -> $collection/$id');
    try {
      await _db
          .collection(collection)
          .doc(id)
          .set(data, SetOptions(merge: merge))
          .timeout(const Duration(seconds: 10));
      debugPrint('Firestore save OK');
    } catch (e) {
      debugPrint('Firestore save FAILED: $e');
      rethrow;
    }
  }

  Future<void> remove(String collection, String id) =>
      _db.collection(collection).doc(id).delete();

  Stream<List>> watch(String collection) =>
      _db.collection(collection).snapshots().map(
            (s) => s.docs.map((d) => {...d.data(), 'id': d.id}).toList(),
          );

  CollectionReference<UserModel> get users => UserModel.collection(_db);

  DocumentReference<UserModel> userDoc(String uid) => users.doc(uid);

  Future<void> syncUserOnAuth({
    required User firebaseUser,
    required String authProvider, // "email" | "google"
    String? username,
  }) async {
    final rawDoc = _db.collection('users').doc(firebaseUser.uid);
    debugPrint('Firestore syncUserOnAuth -> users/${firebaseUser.uid}');

    try {
      await _db.runTransaction((tx) async {
        final snap = await tx.get(rawDoc);

        if (!snap.exists) {
          final fallbackFirstName =
              (username != null && username.trim().isNotEmpty)
                  ? username.trim()
                  : (firebaseUser.displayName?.trim().split(' ').first ??
                      (firebaseUser.email?.split('@').first ?? 'Athlete'));

          tx.set(rawDoc, {
            'email': firebaseUser.email ?? '',
            'firstName': fallbackFirstName,
            'lastName': null,
            'photoUrl': firebaseUser.photoURL,
            'city': null,
            'country': null,
            'primarySport': null,
            'bio': null,
            'birthDate': null,
            'gender': null,
            'weightKg': null,
            'authProvider': authProvider,
            'role': 'user',
            'totalDistanceMeters': 0.0,
            'totalActivitiesCount': 0,
            'followersCount': 0,
            'followingCount': 0,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'deletedAt': null,
          });
        } else {
          final existing = snap.data();
          tx.set(
            rawDoc,
            {
              'email': firebaseUser.email ?? existing?['email'] ?? '',
              if (firebaseUser.photoURL != null && existing?['photoUrl'] == null)
                'photoUrl': firebaseUser.photoURL,
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );
        }
      }).timeout(const Duration(seconds: 10));

      debugPrint('Firestore syncUserOnAuth OK');
    } catch (e) {
      debugPrint('Firestore syncUserOnAuth FAILED: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUser(String uid) async {
    final snap = await userDoc(uid).get();
    return snap.data();
  }

  Stream<UserModel?> watchUser(String uid) {
    return userDoc(uid).snapshots().map((snap) => snap.data());
  }

  Future<void> updateProfileFields({
    required String uid,
    String? firstName,
    String? lastName,
    String? photoUrl,
    String? city,
    String? country,
    String? primarySport,
    String? bio,
    DateTime? birthDate,
    String? gender,
    double? weightKg,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (firstName != null && firstName.trim().isNotEmpty) {
      updates['firstName'] = firstName.trim();
    }
    if (lastName != null) {
      updates['lastName'] = lastName.trim().isEmpty ? null : lastName.trim();
    }
    if (photoUrl != null) {
      updates['photoUrl'] = photoUrl.trim().isEmpty ? null : photoUrl.trim();
    }
    if (city != null) {
      updates['city'] = city.trim().isEmpty ? null : city.trim();
    }
    if (country != null) {
      updates['country'] = country.trim().isEmpty ? null : country.trim();
    }
    if (primarySport != null) {
      updates['primarySport'] =
          primarySport.trim().isEmpty ? null : primarySport.trim();
    }
    if (bio != null) {
      updates['bio'] = bio.trim().isEmpty ? null : bio.trim();
    }
    if (birthDate != null) {
      updates['birthDate'] = Timestamp.fromDate(birthDate);
    }
    if (gender != null) {
      updates['gender'] = gender.trim().isEmpty ? null : gender.trim();
    }
    if (weightKg != null) {
      updates['weightKg'] = weightKg;
    }

    debugPrint('Firestore updateProfileFields -> users/$uid');
    try {
      await _db
          .collection('users')
          .doc(uid)
          .update(updates)
          .timeout(const Duration(seconds: 10));
      debugPrint('Firestore updateProfileFields OK');
    } catch (e) {
      debugPrint('Firestore updateProfileFields FAILED: $e');
      rethrow;
    }
  }
}
