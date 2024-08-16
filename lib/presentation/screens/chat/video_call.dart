import 'package:blog_app/core/constants/my_strings.dart';
import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/injection.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key, required this.callID});
  final String callID;

  @override
  Widget build(BuildContext context) {
    final String name =
        Injection<AuthService>().currentUser!.displayName.toString();
    final String userID = Injection<AuthService>().currentUser!.uid.toString();
    return ZegoUIKitPrebuiltCall(
      appID: AppInfo.APP_ID,
      appSign: AppInfo.APP_SIGN,
      userID: userID,
      userName: name,
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),

      // events: ZegoUIKitPrebuiltCallEvents(onCallEnd: (e, v) {
      //   StarlightUtils.pop();
      //   log('Video Call Ended');
      // }),

      // onDispose: () {
      //   log('Video Call disposed');
      // },
    );
  }
}
