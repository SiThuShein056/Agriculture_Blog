import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseUpdateService {
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();
  final AuthService _auth = Injection<AuthService>();

  Future<void> updateUserData({
    required String id,
    String? name,
    String? email,
    String? profileUrl,
    String? coverUrl,
  }) async {
    Map<String, dynamic> payload = {};
    if (name != null) payload["name"] = name;
    if (email != null) payload["email"] = email;
    if (profileUrl != null) payload["profileUrl"] = profileUrl;
    if (coverUrl != null) payload["coverUrl"] = coverUrl;

    await _db.collection("users").doc(id).update(payload);
  }

  Future<void> updatePostData({
    required String id,
    String? category,
    String? image,
    String? phone,
    String? privacy,
    String? description,
  }) async {
    Map<String, dynamic> payload = {};
    if (category != null) payload["category"] = category;
    if (image != null) payload["image"] = image;
    if (phone != null) payload["phone"] = phone;
    if (privacy != null) payload["post_type"] = privacy;
    if (description != null) payload["description"] = description;

    await _db.collection("posts").doc(id).update(payload);
  }

  Future<void> updateCategoryData({
    required String id,
    String? name,
  }) async {
    Map<String, dynamic> payload = {};
    if (name != null) payload["name"] = name;

    await _db.collection("categories").doc(id).update(payload);
  }

  Future<void> updateSubCategoryData({
    required String id,
    String? name,
  }) async {
    Map<String, dynamic> payload = {};
    if (name != null) payload["name"] = name;

    await _db.collection("subCategories").doc(id).update(payload);
  }
}
