import 'package:blog_app/data/datasources/local/utils/my_util.dart';
import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/db_create_service/chat_create_service/chat_create_service.dart';
import 'package:blog_app/data/models/message_model/message_model.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/screens/chat/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:velocity_x/velocity_x.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Injection<AuthService>().currentUser!.uid == message.fromId
        ? _greenMessage(context)
        : _blueMessage(context);
  }

  Widget _blueMessage(BuildContext context) {
    if (message.readTime.isEmpty) {
      ChatCreateService().updateMessageReadStatus(message);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(message.type != Type.text
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
          child: message.type != Type.text
              ? ClipRRect(
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
                )
              : Text(
                  message.message,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
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
            padding: EdgeInsets.all(message.type != Type.text
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
            child: message.type == Type.image
                ? ClipRRect(
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
                  )
                : message.type == Type.video
                    ? IconButton(
                        onPressed: () {
                          StarlightUtils.push(VideoPlayerWidget(
                            uri: message.message,
                          ));
                        },
                        icon: const Icon(Icons.video_file_outlined))
                    : Text(
                        message.message,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
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
}
