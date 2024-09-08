import 'package:blog_app/data/datasources/local/utils/my_util.dart';
import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/conservation_crud_service/chat_delete_service.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/conservation_crud_service/chat_read_service.dart';
import 'package:blog_app/data/models/message_model/message_model.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/blocs/chat_bloc/chat_bloc.dart';
import 'package:blog_app/presentation/blocs/chat_bloc/chat_event.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:blog_app/presentation/screens/chat/video_call.dart';
import 'package:blog_app/presentation/screens/chat/video_player.dart';
import 'package:blog_app/presentation/screens/chat/voice_call.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../data/datasources/remote/db_crud_service/conservation_crud_service/chat_update_service.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    bool isMe = Injection<AuthService>().currentUser!.uid == message.fromId;
    return GestureDetector(
      onLongPress: () {
        _showBottomSheet(context, isMe);
      },
      child: isMe ? _greenMessage(context) : _blueMessage(context),
    );
  }

  Widget _blueMessage(BuildContext context) {
    if (message.readTime.isEmpty) {
      // ChatCreateService().updateMessageReadStatus(message);
      ChatUpdateService().updateMessageData(
          id: message.id,
          readTime: DateTime.now().microsecondsSinceEpoch.toString());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(message.type == Type.image
              ? MediaQuery.of(context).size.width * .01
              : MediaQuery.of(context).size.width * .04),
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .04,
            vertical: MediaQuery.of(context).size.height * .01,
          ),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 160, 225, 248),
              border:
                  Border.all(color: const Color.fromARGB(255, 41, 149, 174)),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )),
          child: message.type == Type.image
              ? InkWell(
                  onTap: () {
                    StarlightUtils.pushNamed(RouteNames.imageViewerScreen,
                        arguments: message.message);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.03),
                    child: CachedNetworkImage(
                      imageUrl: message.message,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator().centered(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error).centered(),
                      height: MediaQuery.of(context).size.height * .35,
                      width: MediaQuery.of(context).size.height * .35,
                    ),
                  ),
                )
              : message.type == Type.video
                  ? IconButton(
                      onPressed: () {
                        StarlightUtils.push(VideoPlayerWidget(
                          uri: message.message,
                        ));
                      },
                      icon: const Icon(Icons.play_circle_outline_outlined))
                  : (message.type == Type.videoCallLink &&
                          message.expiredTime == true)
                      ? InkWell(
                          onTap: () {
                            StarlightUtils.push(
                                VideoCallScreen(callID: message.message));
                          },
                          child: Text(
                            "Tap here to join Video call  with me ${message.message}",
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      : (message.type == Type.videoCallLink &&
                              message.expiredTime == false)
                          ? InkWell(
                              onTap: null,
                              child: Text(
                                "Expired Video Call ID ${message.message}",
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          : (message.type == Type.voiceCallLink &&
                                  message.expiredTime == true)
                              ? InkWell(
                                  onTap: () {
                                    StarlightUtils.push(VoiceCallScreen(
                                        callID: message.message));
                                  },
                                  child: Text(
                                    "Tap here to join Voice call  with me ${message.message}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline),
                                  ),
                                )
                              : (message.type == Type.voiceCallLink &&
                                      message.expiredTime == false)
                                  ? InkWell(
                                      onTap: null,
                                      child: Text(
                                        "Expired Voice call  ID ${message.message}",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.red,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    )
                                  : message.isPostID
                                      ? IsPostID(postID: message.message)
                                      : Text(
                                          message.message,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * .04),
          child: Text(
            MyUtil.getPostedTime(context: context, time: message.sentTime),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        )
      ],
    );
  }

  Widget _greenMessage(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(message.type == Type.image
                ? MediaQuery.of(context).size.width * .01
                : MediaQuery.of(context).size.width * .04),
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .04,
              vertical: MediaQuery.of(context).size.height * .01,
            ),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(59, 170, 92, 1),
                boxShadow: message.type != Type.video
                    ? null
                    : const [
                        BoxShadow(
                          offset: Offset(2, 1),
                          blurRadius: 2,
                          color: Color.fromARGB(255, 47, 113, 37),
                        )
                      ],
                gradient: message.type != Type.video
                    ? null
                    : const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                            Color.fromARGB(255, 197, 246, 190),
                            Color.fromARGB(255, 173, 239, 163),
                            Color.fromARGB(255, 89, 196, 65),
                          ]),
                border:
                    Border.all(color: const Color.fromARGB(255, 115, 161, 61)),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                )),
            child: message.type == Type.image
                ? InkWell(
                    onTap: () {
                      StarlightUtils.pushNamed(RouteNames.imageViewerScreen,
                          arguments: message.message);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.03),
                      child: CachedNetworkImage(
                        imageUrl: message.message,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator().centered(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error).centered(),
                        height: MediaQuery.of(context).size.height * .35,
                        width: MediaQuery.of(context).size.height * .35,
                      ),
                    ),
                  )
                : message.type == Type.video
                    ? IconButton(
                        onPressed: () {
                          StarlightUtils.pushNamed(RouteNames.videoPlayerScreen,
                              arguments: message.message);
                        },
                        icon: const Icon(
                          Icons.play_circle_outline,
                        ))
                    : (message.type == Type.videoCallLink &&
                            message.expiredTime == true)
                        ? Text(
                            "Video Call ID : ${message.message}",
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.blue),
                          ).tr()
                        : (message.type == Type.videoCallLink &&
                                message.expiredTime == false)
                            ? Text(
                                "Expired Video Call ID : ${message.message}",
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 15,
                                    color: Colors.red),
                              ).tr()
                            : (message.type == Type.voiceCallLink &&
                                    message.expiredTime == true)
                                ? Text(
                                    "Voice Call ID : ${message.message}",
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 15,
                                        color: Colors.blue),
                                  ).tr()
                                : (message.type == Type.voiceCallLink &&
                                        message.expiredTime == false)
                                    ? Text(
                                        "Expired Voice Call ID : ${message.message}",
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 15,
                                            color: Colors.red),
                                      )
                                    : message.isPostID
                                        ? IsPostID(postID: message.message)
                                        : Text(
                                            message.message,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
          ),
          Padding(
            padding:
                EdgeInsets.only(right: MediaQuery.of(context).size.width * .04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (message.readTime.isNotEmpty)
                  const Icon(
                    Icons.done_all_rounded,
                    size: 15,
                    color: Color.fromARGB(255, 111, 197, 114),
                  ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  MyUtil.getPostedTime(
                      context: context, time: message.sentTime),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Future<dynamic> _showBottomSheet(BuildContext context, bool isMe) {
    final bloc = context.read<ChatBloc>();

    return showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(102, 94, 171, 103),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.015,
                    horizontal: MediaQuery.of(context).size.width * 0.4),
              ),
              message.type == Type.text
                  ? OptionItem(
                      name: "Copy Text".tr(),
                      icon: const Icon(
                        Icons.copy_all_outlined,
                        color: Colors.blue,
                      ),
                      onTap: () {
                        FlutterClipboard.copy(message.message).then((value) {
                          StarlightUtils.pop();
                          StarlightUtils.snackbar(
                              SnackBar(content: const Text("Copied").tr()));
                        });
                      })
                  : message.type == Type.image
                      ? ValueListenableBuilder(
                          valueListenable: bloc.saving,
                          builder: (context, value, child) {
                            return OptionItem(
                                name: value ? "Saving..." : "Save Image".tr(),
                                icon: const Icon(
                                  Icons.download_outlined,
                                  color: Colors.blue,
                                ),
                                onTap: () async {
                                  bloc.add(SaveImageEvent(message.message));
                                });
                          })
                      : message.type == Type.video
                          ? ValueListenableBuilder(
                              valueListenable: bloc.saving,
                              builder: (context, value, child) {
                                return OptionItem(
                                    name: value
                                        ? "Saving..........."
                                        : "Save Video".tr(),
                                    icon: const Icon(
                                      Icons.download_outlined,
                                      color: Colors.blue,
                                    ),
                                    onTap: () {
                                      bloc.add(SaveVideoEvent(message.message));
                                    });
                              })
                          : const SizedBox(),
              if (message.type == Type.text ||
                  message.type == Type.image ||
                  message.type == Type.video)
                Divider(
                  color: const Color.fromRGBO(59, 170, 92, 1),
                  endIndent: MediaQuery.of(context).size.width * 0.04,
                  indent: MediaQuery.of(context).size.width * 0.04,
                ),
              if (isMe &&
                  message.type == Type.text &&
                  (message.isPostID == false))
                OptionItem(
                    name: "Edit Message".tr(),
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.blue,
                    ),
                    onTap: () {
                      StarlightUtils.pop();
                      _updateMessageDialog();
                    }),
              if (isMe)
                OptionItem(
                    name: "Delete Message".tr(),
                    icon: const Icon(
                      Icons.delete_outline_outlined,
                      color: Colors.red,
                    ),
                    onTap: () async {
                      ChatDeleteService().deleteMessage(message);

                      StarlightUtils.pop();
                    }),
              if (isMe &&
                  (message.type == Type.text ||
                      message.type == Type.image ||
                      message.type == Type.video))
                Divider(
                  color: const Color.fromRGBO(59, 170, 92, 1),
                  endIndent: MediaQuery.of(context).size.width * 0.04,
                  indent: MediaQuery.of(context).size.width * 0.04,
                ),
              OptionItem(
                  name:
                      "Sent At :${MyUtil.getPostedTime(context: context, time: message.sentTime)} ",
                  icon: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.blue,
                  ),
                  onTap: () {}),
              OptionItem(
                  name: message.readTime.isEmpty
                      ? "Read At : Not seen yet"
                      : "Read At : ${MyUtil.getPostedTime(
                          context: context,
                          time: message.readTime,
                        )}",
                  icon: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.green,
                  ),
                  onTap: () {}),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              )
            ],
          );
        });
  }

  Future<dynamic> _updateMessageDialog() {
    String updateMessage = message.message;
    return StarlightUtils.dialog(AlertDialog(
      title: Row(
        children: [
          const Icon(
            Icons.message,
            color: Colors.blue,
          ),
          const Text("Update Message").tr()
        ],
      ),
      content: TextFormField(
        initialValue: updateMessage,
        onChanged: (value) => updateMessage = value,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            StarlightUtils.pop();
          },
          child: const Text(
            "Cancel",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ).tr(),
        ),
        MaterialButton(
          onPressed: () {
            // ChatCreateService().updateMessage(message, updateMessage);
            ChatUpdateService()
                .updateMessageData(id: message.id, message: updateMessage);
            StarlightUtils.pop();
          },
          child: const Text(
            "Update",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ).tr(),
        )
      ],
    ));
  }
}

class IsPostID extends StatelessWidget {
  const IsPostID({
    super.key,
    required this.postID,
  });

  final String postID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ChatReadService().getReportedPost(postID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //TODO LIKE POSTS
            return const CupertinoActivityIndicator();
          }
          if (snapshot.data == null) {
            return const Text("NONAME");
          }
          PostModel? post;
          for (var element in snapshot.data!.docs) {
            post = PostModel.fromJson(element);
          }
          if (post == null) {
            return const Text("No Post Found");
          }
          return GestureDetector(
            onTap: () {
              StarlightUtils.pushNamed(RouteNames.postDetail, arguments: post);
            },
            child: Text(
              "Post ID : $postID",
              style: const TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 15,
                  color: Colors.blue),
            ),
          );
        });
  }
}

class OptionItem extends StatelessWidget {
  const OptionItem({
    super.key,
    required this.name,
    required this.icon,
    required this.onTap,
  });
  final String name;
  final Icon icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          top: MediaQuery.of(context).size.height * 0.015,
          bottom: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            Flexible(
                child: Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                // color: Colors.black54,
                letterSpacing: 0.5,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
