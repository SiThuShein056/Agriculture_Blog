import 'dart:developer';

import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/models/message_model/message_model.dart';
import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatDeleteService {
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();
  final FirebaseStorage _storage = Injection<FirebaseStorage>();
  final AuthService auth = Injection<AuthService>();

  Future<void> deleteMessage(MessageModel message) async {
    await _db.collection("messages").doc(message.id).delete();
    if (message.type == Type.image || message.type == Type.video) {
      _storage.refFromURL(message.message);
    }
  }

  Future<void> deleteChat(id) async {
    await _db.collection("chats").doc(id).delete();
    var message = await _db.collection("messages").get();
    var msg = message.docs;
    for (var element in msg) {
      var chatID = element["chatId"].toString();

      if (chatID == id) {
        await _db.collection("messages").doc(element["id"]).delete().then((e) {
          log("DELETE MESSAGES ");
        });
      }
    }
  }
}
