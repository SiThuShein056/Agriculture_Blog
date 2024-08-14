import 'dart:developer';

import 'package:blog_app/data/datasources/local/utils/my_util.dart';
import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/db_create_service/chat_create_service/chat_create_service.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/db_delete_service.dart/chat_delete_service.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/db_read_service/chat_read_service.dart';
import 'package:blog_app/data/models/message_model/message_model.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:blog_app/presentation/screens/chat/video_call.dart';
import 'package:blog_app/presentation/screens/chat/video_player.dart';
import 'package:blog_app/presentation/screens/chat/voice_call.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:velocity_x/velocity_x.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe =
        Injection<AuthService>().currentUser!.uid == widget.message.fromId;
    return GestureDetector(
      onLongPress: () {
        _showBottomSheet(context, isMe);
      },
      child: isMe ? _greenMessage(context) : _blueMessage(context),
    );
  }

  Widget _blueMessage(BuildContext context) {
    if (widget.message.readTime.isEmpty) {
      ChatCreateService().updateMessageReadStatus(widget.message);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(widget.message.type == Type.image
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
          child: widget.message.type == Type.image
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.03),
                  child: CachedNetworkImage(
                    imageUrl: widget.message.message,
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
                )
              : widget.message.type == Type.video
                  ? IconButton(
                      onPressed: () {
                        StarlightUtils.push(VideoPlayerWidget(
                          uri: widget.message.message,
                        ));
                      },
                      icon: const Icon(Icons.video_file_outlined))
                  : widget.message.type == Type.videoCallLink
                      ? InkWell(
                          onTap: () {
                            StarlightUtils.push(
                                VideoCallScreen(callID: widget.message.chatId));
                          },
                          child: Text(
                            "Tap here to join Video call  with me ${widget.message.message}",
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      : widget.message.type == Type.voiceCallLink
                          ? InkWell(
                              onTap: () {
                                StarlightUtils.push(VoiceCallScreen(
                                    callID: widget.message.chatId));
                              },
                              child: Text(
                                "Tap here to join Voice call  with me ${widget.message.message}",
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          : Text(
                              widget.message.message,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * .04),
          child: Text(
            MyUtil.getPostedTime(
                context: context, time: widget.message.sentTime),
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
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? MediaQuery.of(context).size.width * .01
                : MediaQuery.of(context).size.width * .04),
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .04,
              vertical: MediaQuery.of(context).size.height * .01,
            ),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 120, 240, 164),
                border: Border.all(color: Colors.lightGreen),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                )),
            child: widget.message.type == Type.image
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.03),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.message,
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
                  )
                : widget.message.type == Type.video
                    ? IconButton(
                        onPressed: () {
                          StarlightUtils.push(VideoPlayerWidget(
                            uri: widget.message.message,
                          ));
                        },
                        icon: const Icon(Icons.video_file_outlined))
                    : widget.message.type == Type.videoCallLink
                        ? Text(
                            "Video Call ID : ${widget.message.message}",
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.blue),
                          )
                        : widget.message.type == Type.voiceCallLink
                            ? Text(
                                "Voice Call ID : ${widget.message.message}",
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 15,
                                    color: Colors.blue),
                              )
                            : widget.message.isPostID
                                ? IsPostID(postID: widget.message.message)
                                : Text(
                                    widget.message.message,
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
          ),
          Padding(
            padding:
                EdgeInsets.only(right: MediaQuery.of(context).size.width * .04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.message.readTime.isNotEmpty)
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
                      context: context, time: widget.message.sentTime),
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
                  color: const Color.fromARGB(102, 184, 181, 211),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.015,
                    horizontal: MediaQuery.of(context).size.width * 0.4),
              ),
              widget.message.type == Type.text
                  ? OptionItem(
                      name: "Copy Text",
                      icon: const Icon(
                        Icons.copy_all_outlined,
                        color: Colors.blue,
                      ),
                      onTap: () {
                        FlutterClipboard.copy(widget.message.message)
                            .then((value) {
                          StarlightUtils.pop();
                          StarlightUtils.snackbar(
                              const SnackBar(content: Text("Copied")));
                        });
                      })
                  : widget.message.type == Type.image
                      ? OptionItem(
                          name: "Save Image",
                          icon: const Icon(
                            Icons.download_outlined,
                            color: Colors.blue,
                          ),
                          onTap: () async {
                            try {
                              log(widget.message.message);
                              await GallerySaver.saveImage(
                                      "${widget.message.message}.jpg",
                                      albumName: "Farmer Hub")
                                  .then((success) {
                                if (success != null && success) {
                                  StarlightUtils.snackbar(const SnackBar(
                                      content: Text("Saved Image")));
                                }
                              });

                              StarlightUtils.pop();
                            } catch (e) {
                              StarlightUtils.pop();
                              log("Error is : ${e.toString()}");
                              StarlightUtils.snackbar(SnackBar(
                                  content: Text("Error is : ${e.toString()}")));
                            }
                          })
                      : widget.message.type == Type.video
                          ? OptionItem(
                              name: "Save Video",
                              icon: const Icon(
                                Icons.download_outlined,
                                color: Colors.blue,
                              ),
                              onTap: () async {
                                try {
                                  log(widget.message.message);
                                  await GallerySaver.saveVideo(
                                          "${widget.message.message}.mp4",
                                          albumName: "Farmer Hub")
                                      .then((success) {
                                    if (success != null && success) {
                                      StarlightUtils.snackbar(const SnackBar(
                                          content: Text("Saved Video")));
                                    }
                                  });

                                  StarlightUtils.pop();
                                } catch (e) {
                                  StarlightUtils.pop();
                                  log("Error is : ${e.toString()}");
                                  StarlightUtils.snackbar(SnackBar(
                                      content:
                                          Text("Error is : ${e.toString()}")));
                                }
                              })
                          : const SizedBox(),
              if (widget.message.type == Type.text ||
                  widget.message.type == Type.image ||
                  widget.message.type == Type.video)
                Divider(
                  color: Colors.black54,
                  endIndent: MediaQuery.of(context).size.width * 0.04,
                  indent: MediaQuery.of(context).size.width * 0.04,
                ),
              if (isMe &&
                  widget.message.type == Type.text &&
                  (widget.message.isPostID == false))
                OptionItem(
                    name: "Edit Message",
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
                    name: "Delete Message",
                    icon: const Icon(
                      Icons.delete_outline_outlined,
                      color: Colors.red,
                    ),
                    onTap: () async {
                      ChatDeleteService().deleteMessage(widget.message);

                      StarlightUtils.pop();
                    }),
              if (isMe &&
                  (widget.message.type == Type.text ||
                      widget.message.type == Type.image ||
                      widget.message.type == Type.video))
                Divider(
                  color: Colors.black54,
                  endIndent: MediaQuery.of(context).size.width * 0.04,
                  indent: MediaQuery.of(context).size.width * 0.04,
                ),
              OptionItem(
                  name:
                      "Sent At :${MyUtil.getPostedTime(context: context, time: widget.message.sentTime)} ",
                  icon: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.blue,
                  ),
                  onTap: () {}),
              OptionItem(
                  name: widget.message.readTime.isEmpty
                      ? "Read At : Not seen yet"
                      : "Read At : ${MyUtil.getPostedTime(
                          context: context,
                          time: widget.message.readTime,
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
    String updateMessage = widget.message.message;
    return StarlightUtils.dialog(AlertDialog(
      title: const Row(
        children: [
          Icon(
            Icons.message,
            color: Colors.blue,
          ),
          Text("Update Message")
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
          ),
        ),
        MaterialButton(
          onPressed: () {
            ChatCreateService().updateMessage(widget.message, updateMessage);
            StarlightUtils.pop();
          },
          child: const Text(
            "Update",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
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
            return const Text("No lkhjhjUser");
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
                color: Colors.black54,
                letterSpacing: 0.5,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
