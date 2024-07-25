part of 'chat_import.dart';

class ChatHome extends StatelessWidget {
  const ChatHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Chat"),
      ),
      body: StreamBuilder(
          stream: FirebaseStoreDb().users,
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
                  List<UserModel> users = snap.data!.toList();

                  if (users.isEmpty) {
                    return const Center(
                      child: Text("Say hi 👋"),
                    );
                  }

                  return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (_, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            onTap: () {
                              StarlightUtils.pushNamed(RouteNames.singleChat,
                                  arguments: users[index]);
                            },
                            leading: CircleAvatar(
                              radius: 17,
                              backgroundImage:
                                  (users[index].profielUrl.isEmpty ||
                                          users[index].profielUrl == '')
                                      ? null
                                      : NetworkImage(users[index].profielUrl),
                              child: (users[index].profielUrl.isEmpty ||
                                      users[index].profielUrl == '')
                                  ? Text(users[index].name[0])
                                  : null,
                            ),
                            title: Text(users[index].name),
                            subtitle: Text(
                              users[index].email,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
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
