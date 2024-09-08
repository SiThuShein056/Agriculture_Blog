part of 'chat_import.dart';

class ChatHome extends StatelessWidget {
  const ChatHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Chat".tr(),
          style: const TextStyle(
              fontSize: 25, letterSpacing: 1, fontWeight: FontWeight.w900),
        ).tr(),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearcChathUser());
              },
              icon: const Icon(Icons.search_outlined))
        ],
      ),
      body: StreamBuilder(
          stream: ChatReadService().getChats(),
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
                  return Center(
                    child: const Text("Data is null value").tr(),
                  );
                } else {
                  // List<ChatModel> chats = snap.data!.reversed.toList();
                  final data = snap.data!.docs;
                  List<ChatModel> chats =
                      data.map((e) => ChatModel.fromJson(e.data())).toList();

                  if (chats.isEmpty) {
                    return Center(
                      child: const Text("Search User to Start").tr(),
                    );
                  }

                  return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: chats.length,
                      itemBuilder: (_, index) {
                        var myID = Injection<AuthService>().currentUser!.uid;
                        var user1 = chats[index].participants[0];
                        var user2 = chats[index].participants[1];
                        String recerverID = "";

                        if (user1 == myID) {
                          recerverID = user2;
                        } else if (user2 == myID) {
                          recerverID = user1;
                        }
                        return StreamBuilder(
                            stream: DatabaseReadService().getUser(recerverID),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CupertinoActivityIndicator());
                              }
                              if (snapshot.data == null) {
                                return const Text("NONAME");
                              }
                              UserModel? user;
                              for (var element in snapshot.data!.docs) {
                                user = UserModel.fromJson(element);
                              }
                              if (user == null) {
                                return const SizedBox();
                              }
                              return StreamBuilder(
                                  stream: ChatReadService()
                                      .getLastMessages(chats[index].id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CupertinoActivityIndicator());
                                    }
                                    if (snapshot.data == null) {
                                      return const Text("NONAME");
                                    }
                                    final data = snapshot.data!.docs;
                                    MessageModel? message;
                                    List<MessageModel> last = data
                                        .map((e) =>
                                            MessageModel.fromJson(e.data()))
                                        .toList();

                                    if (last.isNotEmpty) {
                                      message = last[0];
                                    }
                                    return Card(
                                      child: Slidable(
                                        endActionPane: ActionPane(
                                            extentRatio: .2,
                                            motion: const ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) {
                                                  ChatDeleteService()
                                                      .deleteChat(
                                                          chats[index].id);
                                                },
                                                icon: Icons.delete,
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    Colors.red[700]!,
                                              ),
                                            ]),
                                        child: ListTile(
                                          onTap: () {
                                            ChatCreateService()
                                                .createChat(toId: user!.id);
                                            StarlightUtils.pushNamed(
                                              RouteNames.singleChat,
                                              arguments: user,
                                            );
                                          },
                                          leading: CircleAvatar(
                                            radius: 17,
                                            backgroundImage: (user!
                                                        .profielUrl.isEmpty ||
                                                    user.profielUrl == '')
                                                ? null
                                                : NetworkImage(user.profielUrl),
                                            child: (user.profielUrl.isEmpty ||
                                                    user.profielUrl == '')
                                                ? Text(user.name[0])
                                                : null,
                                          ),
                                          title: Text(user.name),
                                          subtitle: Text(
                                            message != null
                                                ? message.type == Type.image
                                                    ? "Image"
                                                    : message.type == Type.video
                                                        ? "Video"
                                                        : message.type ==
                                                                Type
                                                                    .videoCallLink
                                                            ? "Video Call"
                                                            : message.type ==
                                                                    Type
                                                                        .voiceCallLink
                                                                ? "Voice Call"
                                                                : message
                                                                    .message
                                                : "No message",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ).tr(),
                                          trailing: message == null
                                              ? null
                                              : message.readTime.isEmpty &&
                                                      message.fromId !=
                                                          Injection<
                                                                  AuthService>()
                                                              .currentUser!
                                                              .uid
                                                  ? Container(
                                                      width: 15,
                                                      height: 15,
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .greenAccent
                                                              .shade100,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                    )
                                                  : Text(
                                                      style: const TextStyle(
                                                          color: Color.fromRGBO(
                                                              59, 170, 92, 1)),
                                                      MyUtil.getPostedTime(
                                                          context: context,
                                                          time:
                                                              message.sentTime),
                                                    ),
                                        ),
                                      ),
                                    );
                                  });
                            });
                      });
                }
            }
          }),
    );
  }
}
