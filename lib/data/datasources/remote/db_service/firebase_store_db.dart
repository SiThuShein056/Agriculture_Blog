import 'dart:developer';

import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseStoreDb {
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();
  final AuthService _auth = Injection<AuthService>();

  Stream<QuerySnapshot<Map<String, dynamic>>> getUser(String userId) {
    Stream<QuerySnapshot<Map<String, dynamic>>> user =
        _db.collection("users").where("id", isEqualTo: userId).snapshots();
    return user;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> checkUser() {
    Stream<QuerySnapshot<Map<String, dynamic>>> docusSnapshot = _db
        .collection("users")
        .where("id", isEqualTo: _auth.currentUser!.uid)
        .snapshots();
    return docusSnapshot;
  }

  Future<void> updateUserData(
      {required String id,
      String? name,
      String? email,
      String? profileUrl}) async {
    Map<String, dynamic> payload = {};
    if (name != null) payload["name"] = name;
    if (email != null) payload["email"] = email;
    if (profileUrl != null) payload["profileUrl"] = profileUrl;

    await _db.collection("users").doc(id).update(payload);
  }

  Future<void> createUser({
    required String id,
    required String name,
    required String email,
    required String profileUrl,
  }) async {
    var exitUser = false;
    final doc = FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.uid);

    final user = UserModel(
      id: id,
      name: name,
      email: email,
      profielUrl: profileUrl,
    );

    var data = await FirebaseFirestore.instance.collection("users").get();
    var userData = data.docs;
    for (var element in userData) {
      var id = element["id"].toString();
      if (id == _auth.currentUser!.uid) {
        exitUser = true;
      }
    }

    if (!exitUser) {
      await doc.set(
        user.toJson(),
      );
    }

    log(exitUser.toString());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyPosts() {
    Stream<QuerySnapshot<Map<String, dynamic>>> docusSnapshot = _db
        .collection("posts")
        .where("user_id", isEqualTo: _auth.currentUser!.uid)
        .snapshots();
    return docusSnapshot;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCategories() {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshot =
        _db.collection("categories").snapshots();
    return snapshot;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSubCategories(String id) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = _db
        .collection("subCategories")
        .where("category_id", isEqualTo: id)
        .snapshots();
    return snapshot;
  }
}
