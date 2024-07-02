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
                                        )
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

                                            return PostActionButton(
                                              onTap: () {
                                                createBloc
                                                    .likeAction(posts[i].id);
                                              },
                                              icon: Icons.thumb_up_outlined,
                                              label: likes.isEmpty
                                                  ? "Likes"
                                                  : "Likes ${likes.length}",
                                            );
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

class CommentPart extends StatelessWidget {
  const CommentPart({
    super.key,
    required this.postsId,
    required this.createBloc,
  });

  final String postsId;
  final CreateCubit createBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseStoreDb().comments(postsId),
        builder: (context, cmtSnap) {
          if (cmtSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (cmtSnap.data == null) {
            return const Center(
              child: Text("No Data"),
            );
          }
          List<CommentModel> comments = cmtSnap.data!.toList();
          return PostActionButton(
            onTap: () {
              showBottomSheet(
                context: context,
                builder: (_) => Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: StreamBuilder(
                      stream: FirebaseStoreDb().comments(postsId),
                      builder: (context, cmtSnap) {
                        if (cmtSnap.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CupertinoActivityIndicator());
                        }
                        if (cmtSnap.data == null) {
                          return const Center(
                            child: Text("No Data"),
                          );
                        }
                        List<CommentModel> comments = cmtSnap.data!.toList();
                        return Column(
                          children: [
                            /////အတုံးလေးလုပ်တာ//////
                            Container(
                              width: 100,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(102, 92, 87, 87),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              margin: const EdgeInsets.only(bottom: 20),
                            ),
                            Expanded(
                                child: comments.isEmpty
                                    ? const Center(
                                        child: Text("No Data"),
                                      )
                                    : ListView.separated(
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        padding: const EdgeInsets.only(
                                            bottom: 20, left: 20, right: 20),
                                        separatorBuilder: (_, __) =>
                                            const Divider(),
                                        itemCount: comments.length,
                                        itemBuilder: (_, i) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              StreamBuilder(
                                                  stream: FirebaseStoreDb()
                                                      .getUser(
                                                          comments[i].userId),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      //TODO LIKE POSTS
                                                      return const CupertinoActivityIndicator();
                                                    }
                                                    if (snapshot.data == null) {
                                                      return const Text(
                                                          "NONAME");
                                                    }
                                                    UserModel? user;
                                                    for (var element in snapshot
                                                        .data!.docs) {
                                                      user = UserModel.fromJson(
                                                          element);
                                                    }
                                                    if (user == null) {
                                                      return const Text(
                                                          "No User");
                                                    }
                                                    return Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 17,
                                                          backgroundImage: (user
                                                                      .profielUrl
                                                                      .isEmpty ||
                                                                  user.profielUrl ==
                                                                      '')
                                                              ? null
                                                              : NetworkImage(user
                                                                  .profielUrl),
                                                          child: (user.profielUrl
                                                                      .isEmpty ||
                                                                  user.profielUrl ==
                                                                      '')
                                                              ? Text(
                                                                  user.name[0])
                                                              : null,
                                                        ),

                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        // Text(comment.email),
                                                        Text(user.name.isEmpty
                                                            ? user.email[0]
                                                            : user.name),
                                                        // const Spacer(),
                                                        // comments[i].userId ==
                                                        //         createBloc
                                                        //             .auth
                                                        //             .currentUser!
                                                        //             .uid
                                                        //     ? IconButton(
                                                        //         onPressed: () {
                                                        //           createBloc
                                                        //               .editable
                                                        //               .value = true;

                                                        //           createBloc
                                                        //                   .commentController
                                                        //                   .text =
                                                        //               comments[
                                                        //                       i]
                                                        //                   .body;
                                                        //           createBloc
                                                        //                   .cmtId =
                                                        //               comments[
                                                        //                       i]
                                                        //                   .id;
                                                        //         },
                                                        //         icon: const Icon(
                                                        //             Icons.edit))
                                                        //     : const SizedBox()
                                                      ],
                                                    );
                                                  }),
                                              const SizedBox(height: 5),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40.0),
                                                child: Text(comments[i].body),
                                              )
                                            ],
                                          );
                                        },
                                      )),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10.0, left: 10, right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color:
                                        const Color.fromRGBO(221, 225, 228, 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 198, 188, 188)
                                            .withOpacity(0.5),
                                        spreadRadius: 2,
                                        offset: const Offset(0, 1),
                                      )
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Form(
                                          key: createBloc.formKey,
                                          child: TextFormField(
                                            controller:
                                                createBloc.commentController,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "";
                                              }
                                              return null;
                                            },
                                            minLines: 1,
                                            maxLines: 3,
                                            decoration: const InputDecoration(
                                                hintText: "type something",
                                                border: InputBorder.none),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            createBloc.createComment(
                                                postsId,
                                                createBloc
                                                    .commentController.text);
                                            log("Add Commented");
                                          },
                                          icon: const Icon(Icons.send_outlined))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              );
            },
            icon: Icons.mode_comment_outlined,
            label: comments.isEmpty ? "Comment" : "Comments ${comments.length}",
          );
        });
  }
}

class SearchPost extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [const SizedBox()];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          StarlightUtils.pop();
        },
        icon: const Icon(Icons.chevron_left));
  }

  @override
  Widget buildResults(BuildContext context) {
    log("Build Result Part");

    return const Center(
      child: Text("Build Result"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    log("Build Suggestion Part");
    return StreamBuilder(
        stream: FirebaseStoreDb().posts,
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snap.hasError) {
            return const Center(
              child: Text("Error  Occurred"),
            );
          }
          if (snap.data == null) {
            return const Center(
              child: Text("Data is null value"),
            );
          }
          List<PostModel> posts = snap.data!.toList();

          if (posts.isEmpty) {
            return const Center(
              child: Text("No Data"),
            );
          }
          final searchPosts = posts
              .where((e) =>
                  e.category.contains(query) || e.description.contains(query))
              .toList();
          if (searchPosts.isEmpty) {
            return const Center(
              child: Text("ရှာ သော ပို့စ် မတွေ့ ပါ"),
            );
          }
          return ListView.builder(
              itemCount: searchPosts.length,
              itemBuilder: (_, i) {
                return ListTile(
                  onTap: () {
                    StarlightUtils.pushNamed(RouteNames.postDetail,
                        arguments: searchPosts[i]);
                  },
                  title: Text(searchPosts[i].category),
                  subtitle: Text(
                    searchPosts[i].description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              });
        });
  }
}

class PostActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function()? onTap;
  final Color? color;
  const PostActionButton(
      {super.key,
      required this.label,
      required this.icon,
      this.onTap,
      this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(label),
          ],
        ),
      ),
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
