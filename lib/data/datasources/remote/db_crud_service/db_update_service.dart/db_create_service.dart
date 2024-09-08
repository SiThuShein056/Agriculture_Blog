import 'dart:developer';

import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/notification_service/notification_service.dart';
import 'package:blog_app/data/models/notification_model/notification_model.dart';
import 'package:blog_app/data/models/post_Images_model/post_image_model.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/data/models/post_video_model/post_video_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseCreateService {
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();
  final AuthService _auth = Injection<AuthService>();
  Future<void> createNotifications(String postID) async {
    var data = await FirebaseFirestore.instance.collection("users").get();

    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final ownerID = _auth.currentUser!.uid;
    var userData = data.docs;

    for (var element in userData) {
      var userID = element["id"].toString();
      if (userID != _auth.currentUser!.uid) {
        var notiDoc =
            FirebaseFirestore.instance.collection("notifications").doc();
        log(notiDoc.id.toString());
        final noti = NotificationModel(
            id: notiDoc.id,
            postId: postID,
            userId: userID,
            createdAt: time,
            ownerId: ownerID,
            read: false);

        await notiDoc.set(noti.toJson());
      }
    }
  }

  Future<void> createPost(
      List imageUrl,
      List videoUrl,
      String category,
      String phone,
      String privacy,
      String description,
      bool commentStatus) async {
    final doc = _db.collection("posts").doc();
    final notiDoc = _db.collection("notification").doc();

    final post = PostModel(
      id: doc.id,
      userId: _auth.currentUser!.uid,
      createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
      category: category,
      phone: phone,
      privacy: privacy,
      description: description,
      commentStatus: commentStatus,
    );
    await doc
        .set(
      post.toJson(),
    )
        .then((v) {
      if (privacy == "public") {
        NotificationService().sentNewPostNotification(category);
        createNotifications(doc.id);
      }
    });

    if (imageUrl != []) {
      log("For In  ${imageUrl.length.toString()}");
      for (var element in imageUrl) {
        final postImageDoc = _db.collection("postImages").doc();

        final postImg = PostImageModel(
          id: postImageDoc.id,
          postId: doc.id,
          userId: _auth.currentUser!.uid,
          createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
          imageUrl: element,
        );
        await postImageDoc.set(
          postImg.toJson(),
        );
      }
    }
    if (videoUrl != []) {
      log("For VideoUrl In  ${videoUrl.length.toString()}");
      for (var element in videoUrl) {
        final postVideoDoc = _db.collection("postVideos").doc();

        final postVideo = PostVideoModel(
          id: postVideoDoc.id,
          postId: doc.id,
          userId: _auth.currentUser!.uid,
          createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
          videoUrl: element,
        );
        await postVideoDoc.set(
          postVideo.toJson(),
        );
      }
    }
  }

  Future<void> createUser({
    required String id,
    required String name,
    required String email,
    required String profileUrl,
    required String coverUrl,
  }) async {
    var exitUser = false;
    final doc = _db.collection("users").doc(_auth.currentUser!.uid);
    String time = DateTime.now().millisecondsSinceEpoch.toString();

    final user = UserModel(
      id: id,
      name: name,
      email: email,
      profielUrl: profileUrl,
      coverUrl: coverUrl,
      isOnline: true,
      lastActive: time,
      postStatus: true,
      commentStatus: true,
      messageStatus: true,
      commentPermission: true,
      chatMessageToken: "",
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
}
