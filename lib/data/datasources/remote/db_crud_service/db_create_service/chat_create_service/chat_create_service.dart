import 'dart:developer';

import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/models/chat_model/chat_model.dart';
import 'package:blog_app/data/models/message_model/message_model.dart';
import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ChatCreateService {
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();
  final AuthService _auth = Injection<AuthService>();

  String generateChatID({required String uid1, required String uid2}) {
    List uids = [uid1, uid2];
    uids.sort();
    String chatID = uids.fold("", (id, uid) => "$id$uid");
    return chatID;
  }

  Future<bool> chatExistUID(
      {required String uid1, required String uid2}) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final doc = await _db.collection("chats").doc(chatID).get();
    if (doc.exists) {
      return true;
    }

    return false;
  }

  Future<void> createChat({required String toId}) async {
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    String senderId = _auth.currentUser!.uid;
    String chatID = generateChatID(uid1: senderId, uid2: toId);
    final doc = _db.collection("chats").doc(chatID);
    final userExist = await chatExistUID(uid1: senderId, uid2: toId);
    log(userExist.toString());

    final chat = ChatModel(
        id: doc.id, createdTime: time, participants: [senderId, toId]);
    if (!userExist) {
      await doc.set(
        chat.toJson(),
      );
    }
  }

  Future<void> createMessage(
      {required String message,
      required String toId,
      required Type type}) async {
    String time = DateTime.now().microsecondsSinceEpoch.toString();
    String senderId = _auth.currentUser!.uid;
    String chatID = generateChatID(uid1: senderId, uid2: toId);
    final doc = _db.collection("messages").doc();

    final chat = MessageModel(
      fromId: senderId,
      id: doc.id,
      chatId: chatID,
      toId: toId,
      readTime: "",
      sentTime: time,
      type: type,
      message: message,
    );

    await doc.set(
      chat.toJson(),
    );
  }

  Future<void> sentFileImageMessage({
    required String toId,
  }) async {
    final List<XFile> images = await Injection<ImagePicker>().pickMultiImage();

    if (images.isNotEmpty) {
      for (var i in images) {
        final point = Injection<FirebaseStorage>().ref(
            "chatImages/${_auth.currentUser?.uid}/${DateTime.now().toString().replaceAll(" ", "")}/${i.name.split(".").last}");

        final uploaded = await point.putFile(i.path.file);

        final imageUrl = await Injection<FirebaseStorage>()
            .ref(uploaded.ref.fullPath)
            .getDownloadURL();
        log("image is $imageUrl");

        await ChatCreateService()
            .createMessage(message: imageUrl, toId: toId, type: Type.image);
      }
    }
  }

  Future<PersistentBottomSheetController> selectImageSession(
      {required BuildContext context}) async {
    return showBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            ///အတုံးလေးလုပ်တာ///
            Container(
              width: 100,
              height: 8,
              decoration: BoxDecoration(
                color: const Color.fromARGB(102, 184, 181, 211),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.only(bottom: 20),
            ),
            const Expanded(
              child: Row(
                children: [
                  Text("data"),
                  Text("data"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sentCameraImageMessage({
    required String toId,
  }) async {
    final XFile? image =
        await Injection<ImagePicker>().pickImage(source: ImageSource.camera);

    if (image != null) {
      final point = Injection<FirebaseStorage>().ref(
          "chatImages/${_auth.currentUser?.uid}/${DateTime.now().toString().replaceAll(" ", "")}/${image.name.split(".").last}");

      final uploaded = await point.putFile(image.path.file);

      final imageUrl = await Injection<FirebaseStorage>()
          .ref(uploaded.ref.fullPath)
          .getDownloadURL();

      await ChatCreateService()
          .createMessage(message: imageUrl, toId: toId, type: Type.image);
    }
  }

  Future<void> sentVideoMessage({
    required String toId,
  }) async {
    final XFile? image =
        await Injection<ImagePicker>().pickVideo(source: ImageSource.gallery);

    if (image != null) {
      final point = Injection<FirebaseStorage>().ref(
          "chatVideos/${_auth.currentUser?.uid}/${DateTime.now().toString().replaceAll(" ", "")}/${image.name.split(".").last}");

      final uploaded = await point.putFile(image.path.file);

      final videoUrl = await Injection<FirebaseStorage>()
          .ref(uploaded.ref.fullPath)
          .getDownloadURL();
      log("Video Url is $videoUrl");

      await ChatCreateService()
          .createMessage(message: videoUrl, toId: toId, type: Type.video);
    }
  }

  Future<void> updateMessageReadStatus(MessageModel message) async {
    _db.collection("messages").doc(message.id).update(
        {"read_time": DateTime.now().millisecondsSinceEpoch.toString()});
  }

  Future<void> updateChatListCreatedTime(String chatID) async {
    _db.collection("chats").doc(chatID).update(
        {"created_time": DateTime.now().millisecondsSinceEpoch.toString()});
  }
  // String getConservation(String id) {
  //   return _auth.currentUser!.uid.hashCode <= id.hashCode
  //       ? '${_auth.currentUser!.uid}_$id'
  //       : '${id}_${_auth.currentUser!.uid}';
  // }

  // Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(UserModel user) {
  //   Stream<QuerySnapshot<Map<String, dynamic>>> msg = _db
  //       .collection("chats/${getConservation(user.id)}/messages")
  //       .snapshots();
  //   log(getConservation(user.id));

  //   return msg;
  // }

  // Future<void> sendMessage(UserModel user, String msg) async {
  //   final time = DateTime.now().millisecondsSinceEpoch.toString();

  //   final MessageModel message = MessageModel(
  //       fromId: _auth.currentUser!.uid,
  //       toId: user.id,
  //       readTime: '',
  //       sentTime: time,
  //       type: "text",
  //       message: msg);
  //   final ref = _db.collection("chats/${getConservation(user.id)}/messages/");
  //   return ref.doc(time).set(message.toJson());
  // }
}
