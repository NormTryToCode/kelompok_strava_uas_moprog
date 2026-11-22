import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  final _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAll(String collection) async {
    final snap = await _db.collection(collection).get();
    return snap.docs.map((d) => {...d.data(), 'id': d.id}).toList();
  }

  Future<void> save(String collection, String id, Map<String, dynamic> data) =>
      _db.collection(collection).doc(id).set(data);

  Future<void> remove(String collection, String id) =>
      _db.collection(collection).doc(id).delete();

  Stream<List<Map<String, dynamic>>> watch(String collection) =>
      _db.collection(collection).snapshots().map(
            (s) => s.docs.map((d) => {...d.data(), 'id': d.id}).toList(),
          );
}