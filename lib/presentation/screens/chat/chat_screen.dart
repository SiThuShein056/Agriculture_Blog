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
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FormBox(
            height: MediaQuery.of(context).size.height * .15,
            child: SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  UserAvatar(
                      color: Color.fromARGB(255, 156, 45, 45), name: "soe "),
                  UserAvatar(
                      color: Color.fromARGB(255, 219, 193, 193), name: "si "),
                  UserAvatar(
                      color: Color.fromARGB(255, 185, 182, 182), name: "John"),
                  UserAvatar(
                      color: Color.fromARGB(255, 99, 161, 93), name: "smith"),
                  UserAvatar(
                      color: Color.fromARGB(255, 109, 153, 179),
                      name: "joelay"),
                  UserAvatar(
                      color: Color.fromARGB(255, 185, 174, 174), name: "sweet"),
                  UserAvatar(
                      color: Color.fromARGB(255, 33, 167, 100), name: " chti"),
                  UserAvatar(
                      color: Color.fromARGB(255, 169, 202, 21), name: "Khant"),
                  UserAvatar(
                      color: Color.fromARGB(255, 2, 173, 159), name: "doe"),
                  UserAvatar(
                      color: Color.fromARGB(255, 167, 141, 141), name: "naing"),
                ],
              ),
            ),
          ),
        ),

        //userlist
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: const [
              UserListtite(
                  color: Color.fromARGB(255, 156, 45, 45),
                  username: "soe min naing"),
              UserListtite(
                  color: Color.fromARGB(255, 219, 193, 193),
                  username: "si thu shein"),
              UserListtite(
                  color: Color.fromARGB(255, 185, 182, 182), username: "John"),
              UserListtite(
                  color: Color.fromARGB(255, 99, 161, 93), username: "smith"),
              UserListtite(
                  color: Color.fromARGB(255, 109, 153, 179),
                  username: "joelay"),
              UserListtite(
                  color: Color.fromARGB(255, 185, 174, 174),
                  username: "may sweet"),
              UserListtite(
                  color: Color.fromARGB(255, 33, 167, 100),
                  username: "chit chti"),
              UserListtite(
                  color: Color.fromARGB(255, 169, 202, 21),
                  username: "Min Khant"),
              UserListtite(
                  color: Color.fromARGB(255, 2, 173, 159),
                  username: "doe lone"),
              UserListtite(
                  color: Color.fromARGB(255, 167, 141, 141),
                  username: "soe min naing"),
              UserListtite(
                  color: Color.fromARGB(255, 156, 45, 45),
                  username: "soe min naing"),
              UserListtite(
                  color: Color.fromARGB(255, 219, 193, 193),
                  username: "si thu shein"),
              UserListtite(
                  color: Color.fromARGB(255, 185, 182, 182), username: "John"),
              UserListtite(
                  color: Color.fromARGB(255, 99, 161, 93), username: "smith"),
              UserListtite(
                  color: Color.fromARGB(255, 109, 153, 179),
                  username: "joelay"),
              UserListtite(
                  color: Color.fromARGB(255, 185, 174, 174),
                  username: "may sweet"),
              UserListtite(
                  color: Color.fromARGB(255, 33, 167, 100),
                  username: "chit chti"),
              UserListtite(
                  color: Color.fromARGB(255, 169, 202, 21),
                  username: "Min Khant"),
              UserListtite(
                  color: Color.fromARGB(255, 2, 173, 159),
                  username: "doe lone"),
              UserListtite(
                  color: Color.fromARGB(255, 167, 141, 141),
                  username: "soe min naing"),
            ],
          ),
        ),
      ]),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final Color color;
  final String name;
  const UserAvatar({super.key, required this.color, required this.name});

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

class UserListtite extends StatelessWidget {
  final Color color;
  final String username;
  const UserListtite({super.key, required this.color, required this.username});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color,
            child: const Text("A"),
          ),
          title: Text(username),
          trailing: const Icon(Icons.notifications_none_outlined)),
    );
  }
}
