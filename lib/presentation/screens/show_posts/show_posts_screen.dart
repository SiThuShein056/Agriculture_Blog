part of 'show_post_import.dart';

class ShowPost extends StatelessWidget {
  final Function() onTap;
  final HomeBloc homeBloc;
  final CreateCubit createBloc;
  const ShowPost(
      {super.key,
      required this.onTap,
      required this.homeBloc,
      required this.createBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agriculture Blog"),
        leading: IconButton(
          onPressed: onTap,
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchPost());
            },
            icon: const Icon(Icons.search),
          ),
          StreamBuilder<List<NotificationModel>>(
              stream: FirebaseStoreDb().notis,
              builder: (_, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                if (snap.hasError) {
                  return const SizedBox();
                }
                if (snap.data == null) {
                  return const Center(
                    child: Text("No Data"),
                  );
                }
                List<NotificationModel> notis = snap.data!.toList();
                log("local length${createBloc.readCounts.value}");
                log("Globle length${createBloc.notiCounts.value}");
                log("noti length${notis.length}");
                log("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\");
                // if (createBloc.readCounts.value == 0 &&
                //     createBloc.notiCounts.value == notis.length) {
                //   createBloc.readCounts.value = 0;
                // } else
                if (createBloc.notiCounts.value != notis.length) {
                  createBloc.notiCounts.value = notis.length;
                  createBloc.readCounts.value += 1;
                } else {
                  createBloc.notiCounts.value = createBloc.notiCounts.value;
                  createBloc.readCounts.value = createBloc.readCounts.value;
                }
                log("local length${createBloc.readCounts.value}");
                log("Globle length${createBloc.notiCounts.value}");
                log("noti length${notis.length}");
                log("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\");

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          StarlightUtils.pushNamed(RouteNames.noti)
                              .then((onValue) {
                            createBloc.readCounts.value = 0;
                            // log("local count$readCounts");
                          });
                        },
                        icon: const Icon(Icons.notifications_outlined),
                      ),
                      ValueListenableBuilder(
                          valueListenable: createBloc.readCounts,
                          builder: (_, v, s) {
                            return createBloc.readCounts.value == 0
                                ? const SizedBox()
                                : Text(createBloc.readCounts.value.toString());
                          })
                    ],
                  ),
                );
              }),
        ],
      ),
      body: StreamBuilder<List<PostModel>>(
          stream: FirebaseStoreDb().posts,
          builder: (_, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (snap.data == null) {
              return const Center(
                child: Text("No Data"),
              );
            }
            List<PostModel> posts = snap.data!.toList();

            if (posts.isEmpty) {
              return const Center(
                child: Text("No Data"),
              );
            }

            return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (_, i) {
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
                      child: StreamBuilder(
                          stream: FirebaseStoreDb().getUser(posts[i].userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              //TODO LIKE POSTS
                              return const CupertinoActivityIndicator();
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      StarlightUtils.pushNamed(
                                          RouteNames.profileScreen,
                                          arguments: user!.id.toString());
                                    },
                                    child: Row(
                                      children: [
                                        // CircleProfile(
                                        //   name: user.profielUrl ?? user.name[0],
                                        // ),
                                        CircleAvatar(
                                          radius: 17,
                                          backgroundImage: (user
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
                                                time: posts[i].createdAt)),
                                          ],
                                        ),
                                        // const Spacer(),
                                        // IconButton(
                                        //     onPressed: () {
                                        //       createBloc
                                        //           .deletePost(posts[i].id);
                                        //     },
                                        //     icon: const Icon(Icons.delete))
                                      ],
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 5, left: 3, right: 3),
                                  child: Text(
                                    posts[i].category,
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
                                      posts[i].description,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                  onTap: () {
                                    StarlightUtils.pushNamed(
                                        RouteNames.postDetail,
                                        arguments: posts[i]);
                                  },
                                ),
                                if (posts[i].image.isEmpty ||
                                    posts[i].image == "")
                                  const SizedBox()
                                else
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .3,
                                      child: Card(
                                        child: Image.network(
                                          posts[i].image,
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                const Divider(),
                                SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      StreamBuilder(
                                          stream: FirebaseStoreDb()
                                              .likes(posts[i].id),
                                          builder: (context, likeSnap) {
                                            if (likeSnap.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CupertinoActivityIndicator());
                                            }
                                            if (likeSnap.data == null) {
                                              return const Center(
                                                child: Text("No Data"),
                                              );
                                            }
                                            List<LikeModel> likes =
                                                likeSnap.data!.toList();
                                            log(likes.toString());
                                            return likes.isEmpty
                                                ? PostActionButton(
                                                    onTap: () {
                                                      createBloc.likeAction(
                                                          posts[i].id);
                                                    },
                                                    icon:
                                                        Icons.thumb_up_outlined,
                                                    label: "Likes",
                                                  )
                                                : likes[0].userId ==
                                                        createBloc.auth
                                                            .currentUser!.uid
                                                    ? PostActionButton(
                                                        onTap: () {
                                                          createBloc.likeAction(
                                                              posts[i].id);
                                                        },
                                                        color: Colors.blue,
                                                        icon: Icons
                                                            .thumb_up_rounded,
                                                        label:
                                                            "Liked ${likes.length}",
                                                      )
                                                    : PostActionButton(
                                                        onTap: () {
                                                          createBloc.likeAction(
                                                              posts[i].id);
                                                        },
                                                        icon: Icons
                                                            .thumb_up_outlined,
                                                        label:
                                                            "Likes ${likes.length}",
                                                      );
                                            // return ValueListenableBuilder(
                                            //     valueListenable:
                                            //         createBloc.myLike,
                                            //     builder: (_, v, child) {
                                            //       return PostActionButton(
                                            //         onTap: () {
                                            //           createBloc.likeAction(
                                            //               posts[i].id);
                                            //         },
                                            //         color: v
                                            //             ? Colors.blue
                                            //             : Colors.black,
                                            //         icon:
                                            //             Icons.thumb_up_outlined,
                                            //         label: likes.isEmpty
                                            //             ? "Likes"
                                            //             : "Likes ${likes.length}",
                                            //       );
                                            //     });
                                          }),
                                      CommentPart(
                                          postsId: posts[i].id,
                                          createBloc: createBloc),
                                      PostActionButton(
                                        icon: Icons.add_chart_outlined,
                                        label: "Chat",
                                        onTap: () {
                                          StarlightUtils.pushNamed(
                                              RouteNames.singleChat,
                                              arguments:
                                                  user?.name.toString() ??
                                                      "NA");
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                  );
                });
          }),
    );
  }
}

class CircleProfile extends StatelessWidget {
  final String name;
  final double radius;
  const CircleProfile({
    super.key,
    // this.url,
    this.name = "A",
    this.radius = 17,
  })
  // : assert((name == null && (url != null || url != "")) ||
  //           (name != null && (url == null || url == "")))
  ;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      // backgroundImage: (url != null || url != "") ? NetworkImage(url!) : null,
      child:
          // name == null
          //     ? const SizedBox()
          //     :
          Text(
        // name ?? "NA",
        name,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
