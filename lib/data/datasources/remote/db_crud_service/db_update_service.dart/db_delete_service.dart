import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseDeleteService {
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();

  Future<void> deleteNoti(String id) async {
    await _db.collection("notifications").doc(id).delete();
  }

  Future<void> deleteComment(String commentId) async {
    await _db.collection("comments").doc(commentId).delete();
  }
}
