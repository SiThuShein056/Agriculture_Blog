import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUpdateService {
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();

  Future<void> updateMessageData({
    required String id,
    String? readTime,
    String? message,
    bool? expiredTime,

    // bool? commentPermission,
  }) async {
    Map<String, dynamic> payload = {};
    if (readTime != null) payload["read_time"] = readTime;
    if (message != null) payload["message"] = message;
    if (expiredTime != null) payload["expired_time"] = expiredTime;
    //  if (commentPermission != null) {
    //     payload["commentPermission"] = commentPermission;
    //   }

    await _db.collection("messages").doc(id).update(payload);
  }

  Future<void> updateMessageExpired(String sentMessage) async {
    var data = await _db.collection("messages").get();
    var chatData = data.docs;
    for (var element in chatData) {
      var dbmessage = element["message"].toString();
      if (dbmessage == sentMessage) {
        await updateMessageData(id: element["id"], expiredTime: false);
      }
    }
  }

  Future<void> updateChatData({
    required String id,
    String? createdTime,
    String? blockerId,
    bool? isBlocked,

    // bool? commentPermission,
  }) async {
    Map<String, dynamic> payload = {};
    if (createdTime != null) payload["created_time"] = createdTime;
    if (blockerId != null) payload["blocker_id"] = blockerId;
    if (isBlocked != null) {
      payload["is_blocked"] = isBlocked;
    }

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
