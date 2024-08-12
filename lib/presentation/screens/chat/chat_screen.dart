part of 'chat_import.dart';

class ChatHome extends StatelessWidget {
  const ChatHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Chat",
          style: TextStyle(
              fontSize: 25, letterSpacing: 1, fontWeight: FontWeight.w900),
        ),
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
                  return const Center(
                    child: Text("Data is null value"),
                  );
                } else {
                  // List<ChatModel> chats = snap.data!.reversed.toList();
                  final data = snap.data!.docs;
                  List<ChatModel> chats =
                      data.map((e) => ChatModel.fromJson(e.data())).toList();

                  if (chats.isEmpty) {
                    return const Center(
                      child: Text("Search User to Start"),
                    );
                  }

                  return ListView.builder(
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
                            stream: FirebaseStoreDb().getUser(recerverID),
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
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                                      : message.message
                                              : "No message",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: message == null
                                            ? null
                                            : message.readTime.isEmpty &&
                                                    message.fromId !=
                                                        Injection<AuthService>()
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
                                                                .circular(10)),
                                                  )
                                                : Text(
                                                    MyUtil.getPostedTime(
                                                        context: context,
                                                        time: message.sentTime),
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

class UserAvatar extends StatelessWidget {
  final String name;
  const UserAvatar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Column(children: [
        const CircleAvatar(
          radius: 29,
          child: Text("NA"),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          name,
          style: const TextStyle(
              color: Color.fromARGB(255, 22, 22, 22), fontSize: 12),
        ),
      ]),
    );
  }
}
