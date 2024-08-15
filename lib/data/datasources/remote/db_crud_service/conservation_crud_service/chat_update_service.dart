import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUpdateService {
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();

  Future<void> updateMessageData({
    required String id,
    String? readTime,
    String? message,

    // bool? commentPermission,
  }) async {
    Map<String, dynamic> payload = {};
    if (readTime != null) payload["read_time"] = readTime;
    if (message != null) payload["message"] = message;
    //  if (commentPermission != null) {
    //     payload["commentPermission"] = commentPermission;
    //   }

    await _db.collection("messages").doc(id).update(payload);
  }

  Future<void> updateChatData({
    required String id,
    String? createdTime,

    // bool? commentPermission,
  }) async {
    Map<String, dynamic> payload = {};
    if (createdTime != null) payload["created_time"] = createdTime;
    //  if (commentPermission != null) {
    //     payload["commentPermission"] = commentPermission;
    //   }

    await _db.collection("chats").doc(id).update(payload);
  }

  // Future<void> updateMessageReadStatus(String id) async {
  //   updateMessageData(id: id,readTime: DateTime.now().microsecondsSinceEpoch.toString());

  // }

  // Future<void> updateMessage(String id, String msg) async {
  //   _db.collection("messages").doc(id).update({"message": msg});
  // }

  // Future<void> updateChatListCreatedTime(String chatID) async {
  //   _db.collection("chats").doc(chatID).update(
  //       {"created_time": DateTime.now().millisecondsSinceEpoch.toString()});
  // }
}
