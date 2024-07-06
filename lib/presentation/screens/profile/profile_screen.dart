part of 'profile_import.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? userId = ModalRoute.of(context)!.settings.arguments as String?;
    final createCubit = context.read<CreateCubit>();

    log("User Id is $userId");
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
              .getUser(userId ?? Injection<AuthService>().currentUser!.uid),
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

            return ListView(
              children: [
                ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Container(
                      color: Colors.white,
                      height: 230,
                      child: Stack(
                        children: [
                          InkWell(
                              onTap: () {
                                log("Select Cover Url");
                              },
                              child:
                                  // CachedNetworkImage(
                                  //     imageUrl: user.profielUrl,
                                  //     height: 200,
                                  //     width: MediaQuery.of(context).size.width,
                                  //     fit: BoxFit.cover,
                                  //   )
                                  Card(
                                child: CachedNetworkImage(
                                  imageUrl: user.profielUrl,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        // colorFilter: const ColorFilter.mode(
                                        //     Colors.red, BlendMode.colorBurn),
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator()
                                          .centered(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.upload).centered(),
                                ),
                              )),
                          Positioned(
                              left: 10,
                              bottom: 0,
                              child: InkWell(
                                child: (user.profielUrl.isEmpty ||
                                        user.profielUrl == "")
                                    ? CircleAvatar(
                                        radius: 60,
                                        child:
                                            const Icon(Icons.upload).centered(),
                                      )
                                    : CircleAvatar(
                                        radius: 60,
                                        backgroundImage:
                                            NetworkImage(user.profielUrl),
                                      ),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      height: 90,
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 20,
                              right: 10,
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
                                if (userId !=
                                        Injection<AuthService>()
                                            .currentUser!
                                            .uid &&
                                    userId != null)
                                  CustomOutlinedButton(
                                    function: () {
                                      StarlightUtils.pushNamed(
                                          RouteNames.singleChat,
                                          arguments: user!.name.toString());
                                    },
                                    lable: "Chat",
                                    icon: Icons.comment_outlined,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                StreamBuilder<List<PostModel>>(
                    stream: FirebaseStoreDb().profilePosts(user.id),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CupertinoActivityIndicator());
                      }
                      if (snap.data == null) {
                        return const Center(
                          child: Text("No Data"),
                        );
                      }
                      List<PostModel> myPosts = snap.data!.toList();

                      if (myPosts.isEmpty) {
                        return const Text("No Data").centered();
                      }

                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: myPosts.length,
                          itemBuilder: (_, index) {
                            return Card(
                              color: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              margin: const EdgeInsets.only(top: 10),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                          // onTap: onTap,
                                          child: Row(
                                        children: [
                                          // CircleProfile(
                                          //   name: user.profielUrl ?? user.name[0],
                                          // ),
                                          CircleAvatar(
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
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(user.name),
                                              Text(MyDateUtil.getPostedTime(
                                                  context: context,
                                                  time: myPosts[index]
                                                      .createdAt)),
                                            ],
                                          )
                                        ],
                                      )),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 5,
                                            left: 3,
                                            right: 3),
                                        child: Text(
                                          myPosts[index].category,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3.0, vertical: 5),
                                          child: Text(
                                            myPosts[index].description,
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                        onTap: () {
                                          StarlightUtils.pushNamed(
                                              RouteNames.postDetail,
                                              arguments: myPosts[index]);
                                        },
                                      ),
                                      if (myPosts[index].image.isEmpty ||
                                          myPosts[index].image == "")
                                        const SizedBox()
                                      else
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .3,
                                            child: Card(
                                              child: Image.network(
                                                myPosts[index].image,
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                      const Divider(),
                                      SizedBox(
                                        height: 40,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            LikePart(
                                                postId: myPosts[index].id,
                                                createCubit: createCubit),
                                            CommentPart(
                                                postsId: myPosts[index].id,
                                                createBloc: createCubit),
                                            (userId !=
                                                        Injection<AuthService>()
                                                            .currentUser!
                                                            .uid &&
                                                    userId != null)
                                                ? PostActionButton(
                                                    icon: Icons
                                                        .add_chart_outlined,
                                                    label: "Chat",
                                                    onTap: () {
                                                      StarlightUtils.pushNamed(
                                                          RouteNames.singleChat,
                                                          arguments: user?.name
                                                                  .toString() ??
                                                              "NA");
                                                    },
                                                  )
                                                : const Text("This's Me"),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                            );
                          });
                    })
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
