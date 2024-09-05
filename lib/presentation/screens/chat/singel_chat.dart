import 'dart:developer';
import 'dart:io';

import 'package:blog_app/data/datasources/local/utils/my_util.dart';
import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/conservation_crud_service/chat_create_service.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/conservation_crud_service/chat_read_service.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/conservation_crud_service/chat_update_service.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/firebase_store_db.dart';
import 'package:blog_app/data/models/chat_model/chat_model.dart';
import 'package:blog_app/data/models/message_model/message_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/blocs/chat_bloc/chat_bloc.dart';
import 'package:blog_app/presentation/blocs/chat_bloc/chat_event.dart';
import 'package:blog_app/presentation/blocs/chat_bloc/chat_state.dart';
import 'package:blog_app/presentation/blocs/user_image_bloc/user_image_state.dart';
import 'package:blog_app/presentation/screens/chat/message_card.dart';
import 'package:blog_app/presentation/screens/chat/video_call.dart';
import 'package:blog_app/presentation/screens/chat/voice_call.dart';
import 'package:easy_localization/easy_localization.dart';
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
    bool blocker = false;

    final user = ModalRoute.of(context)!.settings.arguments as UserModel;
    var chatID = ChatCreateService().generateChatID(
        uid1: Injection<AuthService>().currentUser!.uid, uid2: user.id);
    var callID = DateTime.now().microsecondsSinceEpoch.toString();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            StreamBuilder(
                stream: ChatReadService().singleChat(chatID),
                builder: (_, snap) {
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
                          child: SizedBox(),
                        );
                      } else {
                        final data = snap.data!.docs;
                        ChatModel chats = ChatModel.fromJson(data[0].data());
                        if (chats.isBlocked) {
                          blocker = chats.blockerId ==
                              Injection<AuthService>().currentUser!.uid;
                        }

                        return PopupMenuButton<int>(
                            color: Theme.of(context).cardColor,
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                      value: 0,
                                      child: ListTile(
                                        onTap: () async {
                                          if (chats.isBlocked) {
                                            StarlightUtils.snackbar(SnackBar(
                                                content: const Text(
                                                        "Unavailable now")
                                                    .tr()));
                                          } else {
                                            bloc.add(SentVideoCallLinkEvent(
                                                user, callID));
                                            StarlightUtils.push(VideoCallScreen(
                                                    callID: callID))
                                                .then((v) {
                                              ChatUpdateService()
                                                  .updateMessageExpired(callID);
                                            });
                                          }
                                        },
                                        leading: const Icon(
                                            Icons.video_call_outlined),
                                        title: Text(chats.isBlocked
                                                ? "Unavailable now"
                                                : "Video Call")
                                            .tr(),
                                      )),
                                  PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: () async {
                                        if (chats.isBlocked) {
                                          StarlightUtils.snackbar(SnackBar(
                                              content:
                                                  const Text("Unavailable now")
                                                      .tr()));
                                        } else {
                                          bloc.add(SentVoiceCallLinkEvent(
                                              user, callID));
                                          StarlightUtils.push(VoiceCallScreen(
                                                  callID: callID))
                                              .then((v) {
                                            ChatUpdateService()
                                                .updateMessageExpired(callID);
                                          });
                                        }
                                      },
                                      leading: const Icon(Icons.call_outlined),
                                      title: Text(chats.isBlocked
                                          ? "Unavailable now".tr()
                                          : "Voice Call".tr()),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: ListTile(
                                      onTap: () {
                                        if (chats.isBlocked) {
                                          if (blocker) {
                                            ChatUpdateService().updateChatData(
                                                id: chatID,
                                                isBlocked: false,
                                                blockerId: "");
                                          } else {
                                            StarlightUtils.snackbar(SnackBar(
                                                content: const Text(
                                                        "You are blocked by this user")
                                                    .tr()));
                                          }
                                        } else {
                                          ChatUpdateService().updateChatData(
                                              id: chatID,
                                              isBlocked: true,
                                              blockerId:
                                                  Injection<AuthService>()
                                                      .currentUser!
                                                      .uid);
                                        }
                                        StarlightUtils.pop();
                                      },
                                      leading: const Icon(Icons.block_outlined),
                                      title: Text(blocker
                                              ? "UnBlock This user"
                                              : "Block This User")
                                          .tr(),
                                    ),
                                  )
                                ]);
                      }
                  }
                })
          ],
          automaticallyImplyLeading: false,
          title: StreamBuilder(
              stream: FirebaseStoreDb().getUser(user.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CupertinoActivityIndicator());
                }
                if (snapshot.data == null) {
                  return const Text("NONAME");
                }
                UserModel? chatUser;
                for (var element in snapshot.data!.docs) {
                  chatUser = UserModel.fromJson(element);
                }
                if (chatUser == null) {
                  return const SizedBox();
                }
                return Row(
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
                          chatUser.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          chatUser.isOnline
                              ? "Online"
                              : MyUtil().getLastActiveTime(
                                  context: context,
                                  lastActive: chatUser.lastActive),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
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
                          child: SizedBox(),
                        );
                      } else {
                        // List<MessageModel> messages = snap.data ?? [];
                        var data = snap.data!.docs;
                        List<MessageModel> messages =
                            data.map((e) => MessageModel.fromJson(e)).toList();

                        if (messages.isEmpty) {
                          return Center(
                            child: TextButton(
                                onPressed: () {
                                  bloc.messageController.text = "Hi 👋";
                                  bloc.add(SentTextMessageEvent(user));
                                },
                                child: const Text("Say hi 👋").tr()),
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
                textEditingController: bloc.messageController,
                config: Config(
                  height: 256,
                  checkPlatformCompatibility: true,
                  emojiViewConfig: EmojiViewConfig(
                    columns: 7,
                    emojiSizeMax: 28 *
                        (Platform.isAndroid == TargetPlatform.iOS ? 1.20 : 1.0),
                  ),
                ),
              ),
            )
        ]),
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
          child: StreamBuilder(
              stream: ChatReadService().singleChat(chatID),
              builder: (_, snap) {
                if (snap.data == null) {
                  return const Center(
                    child: SizedBox(),
                  );
                } else {
                  final data = snap.data!.docs;
                  ChatModel chats = ChatModel.fromJson(data[0].data());

                  return chats.isBlocked
                      ? const Text("Unavailabel to send message").tr()
                      : Column(
                          children: [
                            BlocBuilder<ChatBloc, ChatBaseState>(
                                builder: (context, state) {
                              if (state is ChatLoadingState) {
                                log("Loading ${state is ChatLoadingState}");

                                return const Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                      ),
                                    ));
                              }
                              if (state is SuccessState) {
                                log("Loading ${state is ChatLoadingState}");
                              }

                              return const SizedBox();
                            }),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();

                                    bloc.toggle();
                                  },
                                  icon:
                                      const Icon(Icons.emoji_emotions_outlined),
                                ),
                                IconButton(
                                    onPressed: () {
                                      _messageType(context, bloc, user, chatID);
                                    },
                                    icon: const Icon(Icons.link_outlined)),
                                Expanded(
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
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
                                              hintText: "Type Here",
                                              border: InputBorder.none),
                                        ),
                                      )),
                                ),
                                MaterialButton(
                                  minWidth: 0,
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 5),
                                  shape: const CircleBorder(),
                                  onPressed: () async {
                                    bool enable = await FirebaseStoreDb()
                                        .checkMessageStatus();

                                    if (enable) {
                                      bloc.add(SentTextMessageEvent(user));

                                      ChatUpdateService().updateChatData(
                                          id: chatID,
                                          createdTime: DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString());
                                    } else {
                                      StarlightUtils.snackbar(const SnackBar(
                                          content: Text(
                                              "Your account has been blocked")));
                                    }
                                  },
                                  color: const Color.fromRGBO(59, 170, 92, 1),
                                  child: const Icon(
                                    Icons.send_outlined,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                }
              })),
    );
  }

  Future<dynamic> _messageType(
      BuildContext context, ChatBloc bloc, UserModel user, String chatID) {
    return StarlightUtils.bottomSheet(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    color: const Color.fromARGB(102, 94, 171, 103),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.only(bottom: 20),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                          onTap: () async {
                            bool enable =
                                await FirebaseStoreDb().checkMessageStatus();

                            if (enable) {
                              bloc.add(SentCameraImageMessageEvent(user));
                              ChatUpdateService().updateChatData(
                                  id: chatID,
                                  createdTime: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString());
                            } else {
                              StarlightUtils.snackbar(const SnackBar(
                                  content:
                                      Text("Your account has been blocked")));
                            }

                            StarlightUtils.pop();
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.height * .15,
                            height: MediaQuery.of(context).size.height * .15,
                            child: const Card(
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 80,
                              ),
                            ),
                          )),
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: () async {
                            bool enable =
                                await FirebaseStoreDb().checkMessageStatus();

                            if (enable) {
                              bloc.add(SentFileImageMessageEvent(user));

                              ChatUpdateService().updateChatData(
                                  id: chatID,
                                  createdTime: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString());
                            } else {
                              StarlightUtils.snackbar(const SnackBar(
                                  content:
                                      Text("Your account has been blocked")));
                            }
                            StarlightUtils.pop();
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.height * .15,
                            height: MediaQuery.of(context).size.height * .15,
                            child: const Card(
                              child: Icon(
                                Icons.image_outlined,
                                size: 80,
                              ),
                            ),
                          )),
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: () async {
                            bool enable =
                                await FirebaseStoreDb().checkMessageStatus();

                            if (enable) {
                              bloc.add(SentVideoMessageEvent(user));
                              ChatUpdateService().updateChatData(
                                  id: chatID,
                                  createdTime: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString());
                            } else {
                              StarlightUtils.snackbar(const SnackBar(
                                  content:
                                      Text("Your account has been blocked")));
                            }
                            StarlightUtils.pop();
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.height * .15,
                            height: MediaQuery.of(context).size.height * .15,
                            child: const Card(
                              child: Icon(
                                Icons.video_collection,
                                size: 80,
                              ),
                            ),
                          )),
                    ),
                    // Expanded(
                    //   child: InkWell(
                    //       onTap: () async {
                    //         bool enable =
                    //             await FirebaseStoreDb().checkMessageStatus();

                    //         if (enable) {
                    //           bloc.add(SentVideoMessageEvent(user));
                    //           ChatUpdateService().updateChatData(
                    //               id: chatID,
                    //               createdTime: DateTime.now()
                    //                   .millisecondsSinceEpoch
                    //                   .toString());
                    //         } else {
                    //           StarlightUtils.snackbar(const SnackBar(
                    //               content:
                    //                   Text("Your account has been blocked")));
                    //         }
                    //         StarlightUtils.pop();
                    //       },
                    //       child: SizedBox(
                    //         width: MediaQuery.of(context).size.height * .15,
                    //         height: MediaQuery.of(context).size.height * .15,
                    //         child: const Card(
                    //           child: Icon(Icons.link_outlined),
                    //         ),
                    //       )),
                    // )
                  ],
                )
              ],
            ),
          );
        });
  }
}
