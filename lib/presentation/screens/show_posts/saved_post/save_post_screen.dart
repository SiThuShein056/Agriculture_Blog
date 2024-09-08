part of 'saved_post_import.dart';

class SavedPostScreen extends StatelessWidget {
  const SavedPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List<SavePostModel> savedPosts =
    //     ModalRoute.of(context)!.settings.arguments as List<SavePostModel>;
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
      body: StreamBuilder(
          stream: DatabaseReadService()
              .mySavedPosts(Injection<AuthService>().currentUser!.uid),
          builder: (context, savePostSnap) {
            if (savePostSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (savePostSnap.data == null) {
              return Center(
                child: const Text("No Data").tr(),
              );
            }
            var savedPosts = savePostSnap.data!;
            if (savedPosts.isEmpty) {
              return const Center(child: Text("No Saved"));
            }
            return ListView.builder(
                itemCount: savedPosts.length,
                itemBuilder: (_, i) {
                  return StreamBuilder(
                      stream: DatabaseReadService()
                          .singlePosts(savedPosts[i].postId),
                      builder: (context, singlePostSnap) {
                        if (singlePostSnap.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CupertinoActivityIndicator());
                        }
                        if (singlePostSnap.data == null) {
                          return const Center(
                            child: Text("Post No Dkkkata"),
                          );
                        }
                        List<PostModel> singlePost = singlePostSnap.data!;

                        if (singlePost.isEmpty) {
                          return const SizedBox();
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
                                stream: DatabaseReadService()
                                    .getUser(singlePost[0].userId),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          savedPostID: savedPosts[i].id,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 5,
                                            left: 3,
                                            right: 3),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                              arguments: singlePost[0]);
                                        },
                                      ),
                                      MultiPhotoShow(postId: singlePost[0].id),
                                      PostVideoShow(postId: singlePost[0].id),
                                      const Divider(
                                        color: Color.fromRGBO(59, 170, 92, 1),
                                      ),
                                      SizedBox(
                                        height: 40,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            LikePart(
                                              postId: singlePost[0].id,
                                              createCubit: createBloc,
                                            ),
                                            CommentPart(
                                              postsId: singlePost[0].id,
                                              createBloc: createBloc,
                                              postedUserID:
                                                  singlePost[0].userId,
                                            ),
                                            user.id !=
                                                    Injection<AuthService>()
                                                        .currentUser!
                                                        .uid
                                                ? PostActionButton(
                                                    icon: Icons
                                                        .add_chart_outlined,
                                                    label: "Chat",
                                                    onTap: () {
                                                      ChatCreateService()
                                                          .createChat(
                                                              toId: user!.id);

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
                });
          }),
    );
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
        stream: DatabaseReadService().postImages(postId),
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
    required this.savedPostID,
  });

  final UserModel? user;
  final PostModel post;
  final CreateCubit createCubit;
  final String savedPostID;

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
        OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color.fromRGBO(59, 170, 92, 1)),
            ),
            onPressed: () async {
              await Injection<FirebaseFirestore>()
                  .collection("savePosts")
                  .doc(savedPostID)
                  .delete()
                  .then((e) {
                log("Done");
              });
            },
            child: const Text("UnSave").tr())
      ],
    );
  }
}
