part of 'show_post_import.dart';

class ShowPost extends StatelessWidget {
  final Function() onTap;
  final CreateCubit createBloc;
  const ShowPost({super.key, required this.onTap, required this.createBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmer Hub"),
        leading: IconButton(
          onPressed: onTap,
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (context) => Center(
                        child: AlertDialog(
                          elevation: 0.01,
                          title: const Text("Select-Action").tr(),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton.icon(
                                  onPressed: () {
                                    StarlightUtils.pop();

                                    showSearch(
                                        context: context,
                                        delegate: SearchUser());
                                  },
                                  label: const Text("Search-User").tr(),
                                  icon: const Icon(
                                    Icons.people,
                                    color: Color.fromRGBO(59, 170, 92, 1),
                                  )),
                              TextButton.icon(
                                  onPressed: () {
                                    StarlightUtils.pop();

                                    showSearch(
                                        context: context,
                                        delegate: SearchPost());
                                  },
                                  label: const Text("Search-Post").tr(),
                                  icon: const Icon(
                                    Icons.post_add_outlined,
                                    color: Color.fromRGBO(59, 170, 92, 1),
                                  )),
                            ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  StarlightUtils.pop();
                                },
                                child: const Text("Close").tr())
                          ],
                        ),
                      ));
            },
            icon: const Icon(Icons.search),
          ),
          StreamBuilder(
              stream: FirebaseStoreDb().readNotis,
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
                  return Center(
                    child: const Text("No Data").tr(),
                  );
                }
                List<NotificationModel> notis = snap.data!.toList();

                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          StarlightUtils.pushNamed(RouteNames.noti);
                        },
                        icon: const Icon(Icons.notifications_outlined),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          notis.isEmpty ? "" : notis.length.toString(),
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseStoreDb().posts,
          builder: (_, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (snap.data == null) {
              return Center(
                child: const Text("No Data").tr(),
              );
            }
            List<PostModel> posts = snap.data!.toList();

            if (posts.isEmpty) {
              return Center(
                child: const Text("No Data").tr(),
              );
            }

            return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (_, i) {
                  return Card(
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
                              return const Text("No lkhjhjUser");
                            }
                            var phone = posts[i].phone;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    StarlightUtils.pushNamed(
                                        RouteNames.profileScreen,
                                        arguments: user!.id.toString());
                                  },
                                  child: PostCardTopRow(
                                    user: user,
                                    post: posts[i],
                                    createCubit: createBloc,
                                  ),
                                ),
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
                                if (phone == "") const SizedBox(),
                                if (phone != "")
                                  InkWell(
                                      onTap: () {
                                        createBloc
                                            .callNumber("${posts[i].phone}");
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3.0),
                                        child: Text(
                                          "Phone Number: $phone",
                                          style: const TextStyle(
                                              color: Colors.blue),
                                        ).tr(),
                                      )),
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
                                MultiPhotoShow(postId: posts[i].id),
                                PostVideoShow(postId: posts[i].id),
                                const Divider(),
                                SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      LikePart(
                                        postId: posts[i].id,
                                        createCubit: createBloc,
                                      ),
                                      CommentPart(
                                        postsId: posts[i].id,
                                        createBloc: createBloc,
                                        postedUserID: posts[i].userId,
                                      ),
                                      user.id !=
                                              Injection<AuthService>()
                                                  .currentUser!
                                                  .uid
                                          ? PostActionButton(
                                              icon: Icons.add_chart_outlined,
                                              label: "Chat",
                                              onTap: () {
                                                ChatCreateService()
                                                    .createChat(toId: user!.id);

                                                StarlightUtils.pushNamed(
                                                    RouteNames.singleChat,
                                                    arguments: user);
                                              },
                                            )
                                          : const Text("This's Me"),
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

class PostCardTopRow extends StatelessWidget {
  const PostCardTopRow({
    super.key,
    required this.user,
    required this.post,
    required this.createCubit,
  });

  final UserModel? user;
  final PostModel post;
  final CreateCubit createCubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // CircleProfile(
        //   name: user.profielUrl ?? user.name[0],
        // ),
        CircleAvatar(
          radius: 17,
          backgroundImage: (user!.profielUrl.isEmpty || user!.profielUrl == '')
              ? null
              : NetworkImage(user!.profielUrl),
          child: (user!.profielUrl.isEmpty || user!.profielUrl == '')
              ? Text(user!.name[0])
              : null,
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user!.name),
            Row(
              children: [
                Text(MyUtil.getPostedTime(
                    context: context, time: post.createdAt)),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.public_outlined,
                  size: 15,
                )
              ],
            ),
          ],
        ),
        const Spacer(),
        PopupMenuButton<int>(
            color: Theme.of(context).scaffoldBackgroundColor,
            onSelected: (value) => onSelected(
                  context,
                  value,
                  post.id,
                  createCubit,
                ),
            itemBuilder: (context) => [
                  PopupMenuItem(
                      value: 0,
                      child: StreamBuilder<List<SavePostModel>>(
                          stream: FirebaseStoreDb().savedPosts(post.id),
                          builder: (context, savePostSnap) {
                            if (savePostSnap.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CupertinoActivityIndicator());
                            }
                            if (savePostSnap.data == null) {
                              return const Center(
                                child: Text("No Data"),
                              );
                            }
                            var savedPosts = savePostSnap.data!;
                            bool saved = false;
                            for (var element in savedPosts) {
                              if (element.userId ==
                                  Injection<AuthService>().currentUser!.uid) {
                                saved = true;
                              }
                            }
                            return Row(
                              children: [
                                Icon(
                                  saved
                                      ? Icons.bookmark
                                      : Icons.bookmark_add_outlined,
                                  color: saved ? Colors.green : null,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  savedPosts.isEmpty
                                      ? "Save-Post"
                                      : saved
                                          ? "Saved"
                                          : "Save-Post",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ).tr(),
                              ],
                            );
                          })),
                  PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          const Icon(Icons.copy_all_outlined),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Copy-Post-Link",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ).tr(),
                        ],
                      ))
                ])
      ],
    );
  }

  onSelected(c, v, postID, CreateCubit createBloc) async {
    var isEnable = await FirebaseStoreDb().checkCommentStatus();
    if (isEnable) {
      switch (v) {
        case 0:
          createBloc.savedPostAction(postID);

          break;
        case 1:
          FlutterClipboard.copy(postID).then(
            (_) => StarlightUtils.snackbar(
              const SnackBar(
                content: Text("Copied"),
              ),
            ),
          );

          break;
        default:
      }
    } else {
      StarlightUtils.snackbar(
        const SnackBar(
          content: Text("Your account has been banned"),
        ),
      );
    }
  }
}
