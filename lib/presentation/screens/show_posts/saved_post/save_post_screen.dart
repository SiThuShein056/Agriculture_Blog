part of 'saved_post_import.dart';

class SavedPostScreen extends StatelessWidget {
  const SavedPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<SavePostModel> posts =
        ModalRoute.of(context)!.settings.arguments as List<SavePostModel>;
    final createBloc = context.read<CreateCubit>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "My Saved Posts",
          style: TextStyle(
              fontSize: 20, letterSpacing: 1, fontWeight: FontWeight.w900),
        ).tr(),
      ),
      body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (_, i) {
            return StreamBuilder(
                stream: FirebaseStoreDb().singlePosts(posts[i].postId),
                builder: (context, singlePostSnap) {
                  if (singlePostSnap.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  if (singlePostSnap.data == null) {
                    return const Center(
                      child: Text("Post No Dkkkata"),
                    );
                  }
                  List<PostModel> singlePost = singlePostSnap.data!;

                  if (singlePost.isEmpty) {
                    return Center(
                      child: const Text("No Post Data").tr(),
                    );
                  }

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
                          stream:
                              FirebaseStoreDb().getUser(singlePost[0].userId),
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

                            var phone = singlePost[0].phone;
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
                                    post: singlePost[0],
                                    createCubit: createBloc,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 5, left: 3, right: 3),
                                  child: Text(
                                    singlePost[0].category,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                if (phone == "") const SizedBox(),
                                if (phone != "")
                                  InkWell(
                                      onTap: () {
                                        createBloc.callNumber(
                                            "${singlePost[0].phone}");
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
                                      singlePost[0].description,
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
                                MultiPhotoShow(postId: posts[i].postId),
                                const Divider(),
                                SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      LikePart(
                                        postId: posts[i].postId,
                                        createCubit: createBloc,
                                      ),
                                      CommentPart(
                                        postsId: posts[i].postId,
                                        createBloc: createBloc,
                                        postedUserID: posts[i].userId,
                                      ),
                                      user.id !=
                                              Injection<AuthService>()
                                                  .currentUser!
                                                  .uid
                                          ? PostActionButton(
                                              icon: Icons.add_chart_outlined,
                                              label: "Chat".tr(),
                                              onTap: () {
                                                ChatCreateService()
                                                    .createChat(toId: user!.id);

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
                            );
                          }),
                    ),
                  );
                });
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
                          ? context.width
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
        // const Spacer(),
        // PopupMenuButton<int>(
        //     color: Theme.of(context).scaffoldBackgroundColor,
        //     onSelected: (value) => onSelected(
        //           context,
        //           value,
        //           post.id,
        //           createCubit,
        //         ),
        //     itemBuilder: (context) => [
        //           PopupMenuItem(
        //               value: 0,
        //               child: StreamBuilder<List<SavePostModel>>(
        //                   stream: FirebaseStoreDb().savedPosts(post.id),
        //                   builder: (context, savePostSnap) {
        //                     if (savePostSnap.connectionState ==
        //                         ConnectionState.waiting) {
        //                       return const Center(
        //                           child: CupertinoActivityIndicator());
        //                     }
        //                     if (savePostSnap.data == null) {
        //                       return const Center(
        //                         child: Text("No Data"),
        //                       );
        //                     }
        //                     var savedPosts = savePostSnap.data!;
        //                     bool saved = false;
        //                     for (var element in savedPosts) {
        //                       if (element.userId ==
        //                           Injection<AuthService>().currentUser!.uid) {
        //                         saved = true;
        //                       }
        //                     }
        //                     return Row(
        //                       children: [
        //                         Icon(
        //                           saved
        //                               ? Icons.bookmark
        //                               : Icons.bookmark_add_outlined,
        //                           color: saved ? Colors.blue : null,
        //                         ),
        //                         const SizedBox(
        //                           width: 5,
        //                         ),
        //                         Text(savedPosts.isEmpty
        //                             ? "Save Post"
        //                             : saved
        //                                 ? "Saved"
        //                                 : "Save Post"),
        //                       ],
        //                     );
        //                   })),
        //           const PopupMenuItem(
        //               value: 1,
        //               child: Row(
        //                 children: [
        //                   Icon(Icons.copy_all_outlined),
        //                   SizedBox(
        //                     width: 5,
        //                   ),
        //                   Text("Copy Post Link"),
        //                 ],
        //               ))
        //         ])
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
              SnackBar(
                content: const Text("Copied").tr(),
              ),
            ),
          );

          break;
        default:
      }
    } else {
      StarlightUtils.snackbar(
        SnackBar(
          content: const Text("Your account has been banned").tr(),
        ),
      );
    }
  }
}
