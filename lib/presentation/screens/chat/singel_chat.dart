import 'dart:developer';
import 'dart:io';

import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/db_create_service/chat_create_service/chat_create_service.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/db_read_service/chat_read_service.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/firebase_store_db.dart';
import 'package:blog_app/data/models/message_model/message_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/blocs/chat_bloc/chat_bloc.dart';
import 'package:blog_app/presentation/blocs/chat_bloc/chat_event.dart';
import 'package:blog_app/presentation/blocs/chat_bloc/chat_state.dart';
import 'package:blog_app/presentation/screens/chat/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class SingleChat extends StatelessWidget {
  const SingleChat({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ChatBloc>();

    final user = ModalRoute.of(context)!.settings.arguments as UserModel;
    var chatID = ChatCreateService().generateChatID(
        uid1: Injection<AuthService>().currentUser!.uid, uid2: user.id);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    StarlightUtils.pop();
                  },
                  icon: const Icon(Icons.chevron_left)),
              CircleAvatar(
                radius: 17,
                backgroundImage:
                    (user.profielUrl.isEmpty || user.profielUrl == '')
                        ? null
                        : NetworkImage(user.profielUrl),
                child: (user.profielUrl.isEmpty || user.profielUrl == '')
                    ? Text(user.name[0])
                    : null,
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Unable last online time",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Column(children: [
          Expanded(
            child: StreamBuilder(
                stream: ChatReadService().getAllMessages(chatID),
                builder: (_, snap) {
                  log("Read Stream");
                  switch (snap.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snap.data == null) {
                        return const Center(
                          child: Text("Data is null value"),
                        );
                      } else {
                        // List<MessageModel> messages = snap.data ?? [];
                        var data = snap.data!.docs;
                        List<MessageModel> messages =
                            data.map((e) => MessageModel.fromJson(e)).toList();

                        if (messages.isEmpty) {
                          return const Center(
                            child: Text("Say hi 👋"),
                          );
                        }

                        return ListView.builder(
                            reverse: true,
                            controller: bloc.commentScrollController,
                            itemCount: messages.length,
                            cacheExtent: 100,
                            itemBuilder: (_, index) {
                              return MessageCard(message: messages[index]);
                            });
                      }
                  }
                }),
          ),
          _chatInput(context, bloc, user, chatID),
          if (bloc.isShowEmoji.value)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.34,
              child: EmojiPicker(
                textEditingController: bloc
                    .messageController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                config: Config(
                  height: 256,
                  checkPlatformCompatibility: true,
                  emojiViewConfig: EmojiViewConfig(
                    columns: 7,
                    emojiSizeMax: 28 *
                        (Platform.isAndroid == TargetPlatform.iOS ? 1.20 : 1.0),
                  ),
                  // swapCategoryAndBottomBar: false,
                  // skinToneConfig: const SkinToneConfig(),
                  // categoryViewConfig: const CategoryViewConfig(),
                  // bottomActionBarConfig: const BottomActionBarConfig(),
                  // searchViewConfig: const SearchViewConfig(),
                ),
              ),
            )
        ]),
        // bottomSheet: Padding(
        //   padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
        //   child: Container(
        //     height: MediaQuery.of(context).size.height * .07,
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(20),
        //         color: const Color.fromRGBO(221, 225, 228, 1),
        //         boxShadow: [
        //           BoxShadow(
        //             color: Colors.grey.withOpacity(0.5),
        //             spreadRadius: 2,
        //             offset: const Offset(0, 3),
        //           )
        //         ]),
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
        //       child: Row(
        //         children: [
        //           Expanded(
        //             child: TextFormField(
        //               controller: textController,
        //               maxLines: 3,
        //               minLines: 1,
        //               decoration: const InputDecoration(
        //                   hintText: "type something", border: InputBorder.none),
        //             ),
        //           ),
        //           const Padding(
        //             padding: EdgeInsets.symmetric(horizontal: 8.0),
        //             child: Icon(
        //               Icons.image_outlined,
        //               size: 30,
        //               color: Color.fromARGB(255, 39, 126, 197),
        //             ),
        //           ),
        //           IconButton(
        //             onPressed: () {},
        //             icon: const Icon(
        //               Icons.send,
        //               color: Color.fromARGB(255, 39, 126, 197),
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }

  Widget _chatInput(
      BuildContext context, ChatBloc bloc, UserModel user, String chatID) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03,
          vertical: MediaQuery.of(context).size.height * 0.01),
      child: Form(
        key: bloc.formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                FocusScope.of(context).unfocus();

                bloc.toggle();
              },
              icon: const Icon(Icons.emoji_emotions_outlined),
            ),
            IconButton(
                onPressed: () {
                  StarlightUtils.bottomSheet(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      builder: (_) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 100,
                                height: 8,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(102, 184, 181, 211),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                margin: const EdgeInsets.only(bottom: 20),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                        onTap: () async {
                                          bool enable = await FirebaseStoreDb()
                                              .checkMessageStatus();

                                          if (enable) {
                                            bloc.add(
                                                SentCameraImageMessageEvent(
                                                    user.id));
                                            ChatCreateService()
                                                .updateChatListCreatedTime(
                                                    chatID);
                                          } else {
                                            StarlightUtils.snackbar(const SnackBar(
                                                content: Text(
                                                    "Your account has been blocked")));
                                          }

                                          StarlightUtils.pop();
                                        },
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .15,
                                          child: const Card(
                                            child:
                                                Icon(Icons.camera_alt_outlined),
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                        onTap: () async {
                                          bool enable = await FirebaseStoreDb()
                                              .checkMessageStatus();

                                          if (enable) {
                                            bloc.add(SentFileImageMessageEvent(
                                                user.id));
                                            ChatCreateService()
                                                .updateChatListCreatedTime(
                                                    chatID);
                                          } else {
                                            StarlightUtils.snackbar(const SnackBar(
                                                content: Text(
                                                    "Your account has been blocked")));
                                          }
                                          StarlightUtils.pop();
                                        },
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .15,
                                          child: const Card(
                                            child: Icon(Icons.image_outlined),
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                        onTap: () async {
                                          bool enable = await FirebaseStoreDb()
                                              .checkMessageStatus();

                                          if (enable) {
                                            bloc.add(
                                                SentVideoMessageEvent(user.id));
                                            ChatCreateService()
                                                .updateChatListCreatedTime(
                                                    chatID);
                                          } else {
                                            StarlightUtils.snackbar(const SnackBar(
                                                content: Text(
                                                    "Your account has been blocked")));
                                          }
                                          StarlightUtils.pop();
                                        },
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .3,
                                          child: const Card(
                                            child:
                                                Icon(Icons.video_file_outlined),
                                          ),
                                        )),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      });
                },
                icon: const Icon(Icons.link_outlined)),
            Expanded(
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expanded(
                      child: TextField(
                        onTap: () {
                          if (bloc.isShowEmoji.value) {
                            bloc.toggle();
                          }
                        },
                        controller: bloc.messageController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                            hintText: "Type Here", border: InputBorder.none),
                      ),
                    ),
                  )),
            ),
            MaterialButton(
              minWidth: 0,
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 10, right: 5),
              shape: const CircleBorder(),
              onPressed: () async {
                bool enable = await FirebaseStoreDb().checkMessageStatus();

                if (enable) {
                  bloc.add(SentTextMessageEvent(user.id));
                  ChatCreateService().updateChatListCreatedTime(chatID);
                } else {
                  StarlightUtils.snackbar(const SnackBar(
                      content: Text("Your account has been blocked")));
                }
              },
              color: const Color.fromARGB(255, 120, 240, 164),
              child: BlocBuilder<ChatBloc, ChatBaseState>(builder: (_, state) {
                if (state is DataSendingState) {
                  log("sentFileImageMessage)))))))))))))))))))))))))))))");

                  return const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                }

                return const Icon(
                  Icons.send_outlined,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
