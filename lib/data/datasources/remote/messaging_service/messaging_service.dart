import 'dart:convert';

import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/db_update_service.dart/db_update_service.dart';
import 'package:blog_app/data/datasources/remote/get_servic_key/get_server_key.dart';
import 'package:blog_app/injection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class MessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var logger = Logger();

  Future<void> getFirebaseMessagingToken() async {
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.getToken().then((token) {
      if (token != null) {
        DatabaseUpdateService().updateUserData(
            id: Injection<AuthService>().currentUser!.uid,
            chatMessageToken: token);
        logger.i("Token : $token");
      }
    });
  }

  sendNotificationToSelectedDevice(
    String sms,
    String deviceToken,
  ) async {
    GetServerKey getServerKey = GetServerKey();
    String serverAccessTokenKey = await getServerKey.getServerKeyToken();
    logger.i("ServerAccessTokenKey : $serverAccessTokenKey");
    String userName =
        Injection<AuthService>().currentUser!.displayName.toString();

    String endPointFirebaaseCloudMessaging =
        'https://fcm.googleapis.com/v1/projects/blog-app-94e6c/messages:send';

    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'notification': {
          'title': 'Sent From $userName',
          'body': sms,
        },
        'data': {
          'type': 'msj',
          'id': 'asdf123',
        }
      }
    };
    try {
      final http.Response response = await http.post(
        Uri.parse(endPointFirebaaseCloudMessaging),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverAccessTokenKey'
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        logger.i("Notification sent successfully : ${response.statusCode} ");
      } else {
        logger.e("Notification sent Fail : ${response.statusCode} ");
      }
    } catch (e) {
      logger.e(e);
    }
  }
}
