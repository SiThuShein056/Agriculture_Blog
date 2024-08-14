import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/models/message_model/message_model.dart';
import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatDeleteService {
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();
  final FirebaseStorage _storage = Injection<FirebaseStorage>();
  final AuthService _auth = Injection<AuthService>();

  // String generateChatID({required String uid1, required String uid2}) {
  //   List uids = [uid1, uid2];
  //   uids.sort();
  //   String chatID = uids.fold("", (id, uid) => "$id$uid");
  //   return chatID;
  // }

  // Future<void> updateMessageReadStatus(MessageModel message) async {
  //   _db.collection("messages").doc(message.id).update(
  //       {"read_time": DateTime.now().microsecondsSinceEpoch.toString()});
  // }

  Future<void> deleteMessage(MessageModel message) async {
    await _db.collection("messages").doc(message.id).delete();
    if (message.type == Type.image || message.type == Type.video) {
      _storage.refFromURL(message.message);
    }
  }

  // Future<void> updateChatListCreatedTime(String chatID) async {
  //   _db.collection("chats").doc(chatID).update(
  //       {"created_time": DateTime.now().millisecondsSinceEpoch.toString()});
  // }
}
