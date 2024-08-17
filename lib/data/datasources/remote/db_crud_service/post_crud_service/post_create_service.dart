import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/datasources/remote/messaging_service/messaging_service.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class PostCreateService {
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();
  final AuthService _auth = Injection<AuthService>();

  Future<void> sentNewPostNotification(String body) async {
    ///get token for all user
    var data = await FirebaseFirestore.instance.collection("users").get();
    var userData = data.docs;
    for (var element in userData) {
      var ownerID = element["id"].toString();
      if (ownerID != _auth.currentUser!.uid) {
        String userToken = element["chat_message_token"].toString();
        String name = element["name"].toString();

        Logger logger = Logger();
        MessagingService msg = MessagingService();
        msg.sendNotificationToSelectedDevice(
            "New Post Added from ${Injection<AuthService>().currentUser!.displayName}",
            body,
            userToken);
        logger.i("Posted from $name");
      }
    }
  }

  Future<void> sentNewCommentNotification(String postId, String body) async {
    var postData = await _db.collection("posts").doc(postId).get();
    var post = PostModel.fromJson(postData.data());

    var ownerData = await _db.collection("users").doc(post.userId).get();
    var ownerName = UserModel.fromJson(ownerData.data()!);

    var data = await FirebaseFirestore.instance.collection("users").get();
    var userData = data.docs;

    for (var element in userData) {
      var userID = element["id"].toString();
      if (userID != _auth.currentUser!.uid) {
        String userToken = element["chat_message_token"].toString();

        Logger logger = Logger();
        MessagingService msg = MessagingService();
        msg.sendNotificationToSelectedDevice(
            "${Injection<AuthService>().currentUser!.displayName} Commented on ${ownerName.name}'s Post}",
            body,
            userToken);
        logger.i(
            "${Injection<AuthService>().currentUser!.displayName} Commented on $ownerName 's Post");
      }
    }
  }
}
