import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  final _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAll(String collection) async {
    final snap = await _db.collection(collection).get();
    return snap.docs.map((d) => {...d.data(), 'id': d.id}).toList();
  }

  Future<List<Map<String, dynamic>>> getWhere(
  String collection,
  String field,
  Object value,
  ) async {
    final snap =
        await _db.collection(collection).where(field, isEqualTo: value).get();
    return snap.docs.map((d) => {...d.data(), 'id': d.id}).toList();
  }

    Future<void> save(String collection, String id, Map<String, dynamic> data) async {
      debugPrint('Firestore save -> $collection/$id');
      try {
        await _db
            .collection(collection)
            .doc(id)
            .set(data)
            .timeout(const Duration(seconds: 10));
        debugPrint('Firestore save OK');
      } catch (e) {
        debugPrint('Firestore save FAILED: $e');
        rethrow;
      }
    }

  Future<void> remove(String collection, String id) =>
      _db.collection(collection).doc(id).delete();

  Stream<List<Map<String, dynamic>>> watch(String collection) =>
      _db.collection(collection).snapshots().map(
            (s) => s.docs.map((d) => {...d.data(), 'id': d.id}).toList(),
          );
}