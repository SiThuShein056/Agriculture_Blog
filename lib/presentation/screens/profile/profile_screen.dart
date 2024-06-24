part of 'profile_import.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Profile",
          style: TextStyle(
              fontSize: 25, letterSpacing: 1, fontWeight: FontWeight.w900),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseStoreDb()
              .getUser(Injection<AuthService>().currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (snapshot.data == null) {
              return const Text("NONAME");
            }
            UserModel? user;
            for (var element in snapshot.data!.docs) {
              user = UserModel.fromJson(element);
            }
            if (user == null) {
              return const Text("No User");
            }

            return Column(
              children: [
                Container(
                  color: Colors.white,
                  height: 230,
                  child: Stack(
                    children: [
                      InkWell(
                          onTap: () {},
                          child: user.profielUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: user.profielUrl,
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                )
                              : const SizedBox()),
                      Positioned(
                        left: 10,
                        bottom: 0,
                        child: (user.profielUrl.isEmpty ||
                                user.profielUrl == "")
                            ? const CircleProfile(
                                name: "NA",
                                radius: 60,
                              )
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(user.profielUrl),
                              ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 90,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 20,
                          right: 10,
                          bottom: 5,
                        ),
                        child: Row(
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            CustomOutlinedButton(
                              function: () {},
                              lable: "Chat",
                              icon: Icons.comment_outlined,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Expanded(
                //   child: ListView.builder(
                //       itemCount: 20,
                //       itemBuilder: (_, index) {
                //         return const ListTile(
                //           title: Text("data"),
                //         );
                //       }),
                // )
              ],
            );
          }),
    );
  }
}

class StaticCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String label;
  const StaticCard({
    super.key,
    required this.width,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(175, 177, 169, 0.2),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
