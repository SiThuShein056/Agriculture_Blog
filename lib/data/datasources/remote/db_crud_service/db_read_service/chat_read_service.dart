import 'dart:async';

import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/models/chat_model/chat_model.dart';
import 'package:blog_app/data/models/message_model/message_model.dart';
import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatReadService {
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();
  final AuthService _auth = Injection<AuthService>();
  final StreamController<List<ChatModel>> _chatStream =
      StreamController<List<ChatModel>>.broadcast();
  final StreamController<List<MessageModel>> _messageStream =
      StreamController<List<MessageModel>>.broadcast();

  ///
  Stream<QuerySnapshot<Map<String, dynamic>>> getChats() {
    Stream<QuerySnapshot<Map<String, dynamic>>> msg = _db
        .collection("chats")
        .where("participants", arrayContains: _auth.currentUser!.uid)
        .orderBy("created_time", descending: true)
        .snapshots();

    return msg;
  }

  ///
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(String chatID) {
    Stream<QuerySnapshot<Map<String, dynamic>>> msg = _db
        .collection("messages")
        .where("chatId", isEqualTo: chatID)
        .orderBy("sent_time", descending: true)
        .snapshots();

    return msg;
  }

  ///
  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(String chatID) {
    Stream<QuerySnapshot<Map<String, dynamic>>> msg = _db
        .collection("messages")
        .where("chatId", isEqualTo: chatID)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .snapshots();

    return msg;
  }

  ///CHATLIST
  final List<ChatModel> _chat = [];
  void chatParser(QuerySnapshot event) {
    _chat.clear();
    _chat.addAll(event.docs.map((e) => ChatModel.fromJson(e.data())));
    _chatStream.add(_chat);
  }

  final Map<String, StreamSubscription> _chatStreams = {};
  void _chatStreamSetUp() {
    _chatStreams["data"] = _db
        .collection("chats")
        .where("participants", arrayContains: _auth.currentUser!.uid)
        .orderBy("created_time", descending: false)
        .snapshots()
        .listen((e) {
      return chatParser(e);
    });
  }

  Stream<List<ChatModel>> chats() {
    var stream = _chatStreams["data"];
    if (stream != null) {
      stream.cancel();
      _chatStreams.remove("data");
    }
    _chatStreamSetUp();

    return _chatStream.stream;
  }

  ///MESSAGE
  final List<MessageModel> _message = [];
  void messageParser(QuerySnapshot event) {
    _message.clear();
    _message.addAll(event.docs.map((e) => MessageModel.fromJson(e.data())));
    _messageStream.add(_message);
  }

  final Map<String, StreamSubscription> _messageStreams = {};
  void _messageStreamsSetUp(String id) {
    _messageStreams[id] = _db
        .collection("messages")
        .where("chatId", isEqualTo: id)
        .orderBy("sent_time", descending: false)
        .snapshots()
        .listen((e) {
      return messageParser(e);
    });
  }

  Stream<List<MessageModel>> messages(String chatID) {
    var stream = _messageStreams[chatID];
    if (stream != null) {
      stream.cancel();
      _messageStreams.remove(chatID);
    }

    _messageStreamsSetUp(chatID);
    return _messageStream.stream;
  }

  ///
}
