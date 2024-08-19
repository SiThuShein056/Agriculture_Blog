import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseUpdateService {
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();

  Future<void> updateUserData({
    required String id,
    String? name,
    String? email,
    String? profileUrl,
    String? coverUrl,
    bool? postStatus,
    bool? commentStatus,
    bool? messageStatus,
    bool? isOnline,
    String? lastActive,
    bool? commentPermission,
    String? chatMessageToken,
  }) async {
    Map<String, dynamic> payload = {};
    if (name != null) payload["name"] = name;
    if (email != null) payload["email"] = email;
    if (profileUrl != null) payload["profileUrl"] = profileUrl;
    if (coverUrl != null) payload["coverUrl"] = coverUrl;
    if (postStatus != null) payload["postStatus"] = postStatus;
    if (commentStatus != null) payload["commentStatus"] = commentStatus;
    if (lastActive != null) payload["last_Active"] = lastActive;
    if (isOnline != null) payload["is_Online"] = isOnline;
    if (commentPermission != null) {
      payload["commentPermission"] = commentPermission;
    }
    if (messageStatus != null) payload["messageStatus"] = messageStatus;
    if (chatMessageToken != null) {
      payload["chat_message_token"] = chatMessageToken;
    }

    await _db.collection("users").doc(id).update(payload);
  }

  Future<void> updatePostData({
    required String id,
    String? category,
    String? phone,
    String? privacy,
    String? description,
    bool? commentStatus,
  }) async {
    Map<String, dynamic> payload = {};
    if (category != null) payload["category"] = category;
    if (phone != null) payload["phone"] = phone;
    if (privacy != null) payload["post_type"] = privacy;
    if (description != null) payload["description"] = description;
    if (commentStatus != null) payload["commentStatus"] = commentStatus;

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

  Future<void> updateMainCategoryData({
    required String id,
    String? name,
  }) async {
    Map<String, dynamic> payload = {};
    if (name != null) payload["name"] = name;

    await _db.collection("mainCategories").doc(id).update(payload);
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
