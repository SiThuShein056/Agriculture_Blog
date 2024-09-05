part of 'profile_import.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? userId = ModalRoute.of(context)!.settings.arguments as String?;
    final createCubit = context.read<CreateCubit>();
    // final userImageBloc = context.read<UserImageBloc>();

    log("User Id is $userId");
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Profile",
          style: TextStyle(
              fontSize: 25, letterSpacing: 1, fontWeight: FontWeight.w900),
        ).tr(),
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
              return const Text("No User").tr();
            }

            return ListView(
              children: [
                ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Container(
                      color: Theme.of(context).cardColor,
                      height: 230,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: user.id != createCubit.auth.currentUser!.uid
                                ? () {
                                    user!.coverUrl == ""
                                        ? null
                                        : StarlightUtils.pushNamed(
                                            RouteNames.imageViewerScreen,
                                            arguments: user.coverUrl);
                                  }
                                : () {
                                    user!.coverUrl == ""
                                        ? createCubit.auth.pickCoverPhoto()
                                        : chooseAction(context, user.coverUrl,
                                            createCubit, true);
                                  },
                            child: Card(
                              child: user.coverUrl == ""
                                  ? const Center(
                                      child: Icon(Icons.person_2_outlined),
                                    )
                                  : Hero(
                                      tag: user.coverUrl,
                                      child: CachedNetworkImage(
                                        imageUrl: user.coverUrl,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator()
                                                .centered(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.upload).centered(),
                                      ),
                                    ),
                            ),
                          ),
                          Positioned(
                            left: 10,
                            bottom: 0,
                            child: InkWell(
                                onTap: user.id !=
                                        createCubit.auth.currentUser!.uid
                                    ? () {
                                        user!.profielUrl == ""
                                            ? null
                                            : StarlightUtils.pushNamed(
                                                RouteNames.imageViewerScreen,
                                                arguments: user.profielUrl);
                                      }
                                    : () {
                                        user!.profielUrl == ""
                                            ? createCubit.auth
                                                .updatePickProfilePhoto()
                                            : chooseAction(
                                                context,
                                                user.profielUrl,
                                                createCubit,
                                                false,
                                              );
                                      },
                                child: CircleAvatar(
                                  radius: 60,
                                  child: user.profielUrl == ""
                                      ? (userId !=
                                                  Injection<AuthService>()
                                                      .currentUser!
                                                      .uid &&
                                              userId != null)
                                          ? const Center(
                                              child:
                                                  Icon(Icons.person_2_outlined),
                                            )
                                          : const Center(
                                              child: Icon(Icons.upload),
                                            )
                                      : CachedNetworkImage(
                                          imageUrl: user.profielUrl,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator()
                                                  .centered(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error)
                                                  .centered(),
                                        ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 90,
                      color: Theme.of(context).cardColor,
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
                                      ChatCreateService()
                                          .createChat(toId: user!.id);

                                      StarlightUtils.pushNamed(
                                          RouteNames.singleChat,
                                          arguments: user);
                                    },
                                    lable: "Chat".tr(),
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
                    stream: user.id != createCubit.auth.currentUser!.uid
                        ? FirebaseStoreDb().profilePosts(user.id)
                        : FirebaseStoreDb().myProfilePosts(user.id),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 150.0, bottom: 150),
                          child: Center(child: CupertinoActivityIndicator()),
                        );
                      }
                      if (snap.data == null) {
                        return Center(
                          child: const Text("No-Posted-Data").tr(),
                        );
                      }
                      List<PostModel> myPosts = snap.data!.toList();

                      if (myPosts.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 150.0),
                          child: const Text("No-Posted-Data").tr().centered(),
                        );
                      }

                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: myPosts.length,
                          itemBuilder: (_, index) {
                            var phone = myPosts[index].phone;
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                          child: Row(
                                        children: [
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
                                              Row(
                                                children: [
                                                  Text(MyUtil.getPostedTime(
                                                      context: context,
                                                      time: myPosts[index]
                                                          .createdAt)),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Icon(
                                                    myPosts[index].privacy ==
                                                            "public"
                                                        ? Icons.public_outlined
                                                        : Icons.lock,
                                                    size: 15,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          user.id ==
                                                  createCubit
                                                      .auth.currentUser!.uid
                                              ? IconButton(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                        context: context,
                                                        builder: (_) {
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              ListTile(
                                                                onTap:
                                                                    () async {
                                                                  var isEnabled =
                                                                      await FirebaseStoreDb()
                                                                          .checkPostStatus();
                                                                  if (isEnabled) {
                                                                    // Injection<
                                                                    //         FirebaseFirestore>()
                                                                    //     .collection(
                                                                    //         "posts")
                                                                    //     .doc(myPosts[index]
                                                                    //         .id)
                                                                    //     .delete()
                                                                    await createCubit
                                                                        .deletePost(myPosts[index]
                                                                            .id)
                                                                        .then(
                                                                            (_) {
                                                                      StarlightUtils
                                                                          .pop();
                                                                    });
                                                                    MyUtil.showToast(
                                                                        context);
                                                                  } else {
                                                                    StarlightUtils.snackbar(SnackBar(
                                                                        content:
                                                                            Text("Your account has been blocked.".tr())));
                                                                    StarlightUtils
                                                                        .pop();
                                                                  }
                                                                },
                                                                title: const Text(
                                                                        "Delete")
                                                                    .tr(),
                                                                trailing:
                                                                    const Icon(Icons
                                                                        .delete),
                                                              ),
                                                              ListTile(
                                                                onTap:
                                                                    () async {
                                                                  var isEnabled =
                                                                      await FirebaseStoreDb()
                                                                          .checkPostStatus();
                                                                  if (isEnabled) {
                                                                    StarlightUtils.pushNamed(
                                                                            RouteNames
                                                                                .updatePostScreen,
                                                                            arguments: myPosts[
                                                                                index])
                                                                        .then(
                                                                            (_) {
                                                                      StarlightUtils
                                                                          .pop();
                                                                    });
                                                                  } else {
                                                                    StarlightUtils.snackbar(SnackBar(
                                                                        content:
                                                                            const Text("Your account has been blocked.").tr()));
                                                                    StarlightUtils
                                                                        .pop();
                                                                  }
                                                                },
                                                                title: const Text(
                                                                        "Update")
                                                                    .tr(),
                                                                trailing:
                                                                    const Icon(Icons
                                                                        .update),
                                                              )
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  icon: const Icon(
                                                      Icons.more_vert),
                                                )
                                              : const SizedBox()
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
                                      if (phone == "") const SizedBox(),
                                      if (phone != "")
                                        InkWell(
                                            onTap: () {
                                              createCubit.callNumber("$phone");
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3.0),
                                              child: Text(
                                                "Phone Number: ${myPosts[index].phone}",
                                                style: const TextStyle(
                                                    color: Colors.blue),
                                              ).tr(),
                                            )),
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
                                      // if (myPosts[index].image.isEmpty ||
                                      //     myPosts[index].image == "")
                                      //   const SizedBox()
                                      // else
                                      //   SizedBox(
                                      //       width: MediaQuery.of(context)
                                      //           .size
                                      //           .width,
                                      //       height: MediaQuery.of(context)
                                      //               .size
                                      //               .height *
                                      //           .3,
                                      //       child: InkWell(
                                      //         onTap: () {
                                      //           StarlightUtils.pushNamed(
                                      //               RouteNames
                                      //                   .imageViewerScreen,
                                      //               arguments:
                                      //                   myPosts[index].image);
                                      //         },
                                      //         child: Card(
                                      //           child: CachedNetworkImage(
                                      //             imageUrl:
                                      //                 myPosts[index].image,
                                      //             imageBuilder: (context,
                                      //                     imageProvider) =>
                                      //                 Container(
                                      //               decoration: BoxDecoration(
                                      //                 image: DecorationImage(
                                      //                   image: imageProvider,
                                      //                   fit: BoxFit.cover,
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //             placeholder: (context, url) =>
                                      //                 const CircularProgressIndicator()
                                      //                     .centered(),
                                      //             errorWidget: (context, url,
                                      //                     error) =>
                                      //                 const Icon(Icons
                                      //                         .error_outline)
                                      //                     .centered(),
                                      //           ),
                                      //         ),
                                      //       )),
                                      MultiPhotoShow(postId: myPosts[index].id),
                                      PostVideoShow(postId: myPosts[index].id),
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
                                              createBloc: createCubit,
                                              postedUserID:
                                                  myPosts[index].userId,
                                            ),
                                            (userId !=
                                                        Injection<AuthService>()
                                                            .currentUser!
                                                            .uid &&
                                                    userId != null)
                                                ? PostActionButton(
                                                    icon: Icons
                                                        .add_chart_outlined,
                                                    label: "Chat".tr(),
                                                    onTap: () {
                                                      ChatCreateService()
                                                          .createChat(
                                                              toId: user!.id);

                                                      StarlightUtils.pushNamed(
                                                          RouteNames.singleChat,
                                                          arguments: user);
                                                    },
                                                  )
                                                : const Text("This's Me").tr(),
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

  Future<dynamic> chooseAction(BuildContext context, String url,
      CreateCubit createCubit, bool isCoverPhoto) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    StarlightUtils.pop();
                  },
                  child: const Text("Exit").tr())
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    StarlightUtils.pop();
                    StarlightUtils.pushNamed(RouteNames.imageViewerScreen,
                        arguments: url);
                  },
                  title: const Text("View Image").tr(),
                  trailing: const Icon(Icons.remove_red_eye_outlined),
                ),
                const Divider(),
                ListTile(
                  title: const Text("Upload Image").tr(),
                  trailing: const Icon(Icons.upload_outlined),
                  onTap: () {
                    StarlightUtils.pop();
                    isCoverPhoto
                        ? createCubit.auth.pickCoverPhoto()
                        : createCubit.auth.updatePickProfilePhoto();
                  },
                )
              ],
            ),
          );
        });
  }
}

class MultiPhotoShow extends StatelessWidget {
  const MultiPhotoShow({
    super.key,
    required this.postId,
  });

  final String postId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseStoreDb().postImages(postId),
        builder: (_, postImageSnap) {
          if (postImageSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (postImageSnap.data == null) {
            return Center(
              child: const Text("No Data").tr(),
            );
          }
          List<PostImageModel> postImages = postImageSnap.data!.toList();
          if (postImages.isEmpty) {
            return const SizedBox();
          }
          return SizedBox(
            width: context.width,
            height: 150,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: postImages.length,
                itemBuilder: (_, i) {
                  return InkWell(
                    onTap: () {
                      StarlightUtils.pushNamed(RouteNames.imageViewerScreen,
                          arguments: postImages[i].imageUrl);
                    },
                    child: SizedBox(
                      height: 150,
                      width: postImages.length == 1
                          ? context.width * .93
                          : context.width * 0.5,
                      child: Card(
                        child: CachedNetworkImage(
                          imageUrl: postImages[i].imageUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator().centered(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error).centered(),
                        ),
                      ),
                    ),
                  );
                }),
          );
        });
  }
}

class PostVideoShow extends StatelessWidget {
  const PostVideoShow({
    super.key,
    required this.postId,
  });

  final String postId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseStoreDb().postVideos(postId),
        builder: (_, postVideoSnap) {
          if (postVideoSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (postVideoSnap.data == null) {
            return Center(
              child: const Text("No Data").tr(),
            );
          }
          List<PostVideoModel> postVideos = postVideoSnap.data!.toList();
          if (postVideos.isEmpty) {
            return const SizedBox();
          }
          return SizedBox(
            width: context.width,
            height: 150,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: postVideos.length,
                itemBuilder: (_, i) {
                  return InkWell(
                    onTap: () {
                      StarlightUtils.pushNamed(RouteNames.imageViewerScreen,
                          arguments: postVideos[i].videoUrl);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(2, 1),
                              blurRadius: 2,
                              color: Color.fromARGB(255, 47, 113, 37),
                            )
                          ],
                          gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color.fromARGB(255, 197, 246, 190),
                                Color.fromARGB(255, 173, 239, 163),
                                Color.fromARGB(255, 89, 196, 65),
                              ])),
                      height: 150,
                      width: postVideos.length == 1
                          ? context.width * .93
                          : context.width * 0.5,
                      child: IconButton(
                        onPressed: () {
                          StarlightUtils.push(
                              VideoPlayerWidget(uri: postVideos[i].videoUrl));
                        },
                        icon: const Icon(Icons.play_circle_outline, size: 50),
                      ),
                    ),
                  );
                }),
          );
        });
  }
}
