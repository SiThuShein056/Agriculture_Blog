part of 'show_post_import.dart';

class ShowPost extends StatelessWidget {
  final Function() onTap;
  final HomeBloc bloc;
  const ShowPost({super.key, required this.onTap, required this.bloc});

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
              StarlightUtils.pushNamed(RouteNames.searchPost,
                  arguments: "Chat with User");
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              StarlightUtils.pushNamed(RouteNames.noti);
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: StreamBuilder<List<PostModel>>(
          stream: bloc.posts,
          builder: (_, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (snap.data == null) {
              return const Center(
                child: Text("No Data"),
              );
            }
            // List<PostModel> posts = [];
            // for (var i in snap.data!.docs) {
            //   var model = PostModel.fromJson(i.data());
            //   if (!posts.contains(model)) {
            //     posts.add(model);
            //   }
            // }
            List<PostModel> posts = snap.data!.reversed.toList();

            if (posts.isEmpty) {
              return const Center(
                child: Text("No Data"),
              );
            }

            return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (_, i) {
                  // return Card(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       ListTile(
                  //         leading: const CircleAvatar(
                  //           radius: 30,
                  //         ),
                  //         title: Text(posts[i].userId[0]),
                  //         subtitle: Text(posts[i].category),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Text(posts[i].description),
                  //       )
                  //     ],
                  //   ),
                  // );
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: onTap,
                            child: StreamBuilder(
                                stream:
                                    FirebaseStoreDb().getUser(posts[i].userId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
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
                                  return Row(
                                    children: [
                                      // CircleProfile(
                                      //   name: user.profielUrl ?? user.name[0],
                                      // ),
                                      CircleAvatar(
                                        radius: 17,
                                        backgroundImage:
                                            (user.profielUrl.isEmpty ||
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
                                      // StreamBuilder<
                                      //         QuerySnapshot<Map<String, dynamic>>>(
                                      //     stream: Injection<FirebaseFirestore>()
                                      //         .collection("users")
                                      //         .where("id", isEqualTo: posts[i].userId)
                                      //         .snapshots(),
                                      //     builder: (_, snap) {
                                      //       if (snap.connectionState ==
                                      //           ConnectionState.waiting) {
                                      //         return const Center(
                                      //             child:
                                      //                 CupertinoActivityIndicator());
                                      //       }
                                      //       if (snap.data?.docs == null) {
                                      //         return const Center(
                                      //           child: Text("No Data"),
                                      //         );
                                      //       }
                                      //       var datais = snap.data!.docs;
                                      //       UserModel userData =
                                      //           UserModel.fromJson(datais);
                                      //       return Column(
                                      //         children: [
                                      //           Text(userData.name),
                                      //           Text(userData.email),
                                      //         ],
                                      //       );
                                      //     })
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(user.name),
                                          Text(TimeOfDay.fromDateTime(DateTime
                                                  .fromMicrosecondsSinceEpoch(
                                                      int.parse(
                                                          posts[i].createdAt)))
                                              .format(context)
                                              .toString())
                                        ],
                                      )
                                    ],
                                  );
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 5, left: 3, right: 3),
                            child: Text(
                              posts[i].category,
                              textAlign: TextAlign.justify,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                              StarlightUtils.pushNamed(RouteNames.postDetail,
                                  arguments: posts[i]);
                            },
                          ),
                          if (posts[i].image.isEmpty || posts[i].image == "")
                            const SizedBox()
                          else
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * .3,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const LikeButton(),
                                PostActionButton(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (_) => Container(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Column(
                                          children: [
                                            /////အတုံးလေးလုပ်တာ//////
                                            Container(
                                              width: 100,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    188, 188, 188, 0.4),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              margin: const EdgeInsets.only(
                                                  bottom: 20),
                                            ),
                                            Expanded(
                                              child: ListView.separated(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20,
                                                    left: 20,
                                                    right: 20),
                                                separatorBuilder: (_, __) =>
                                                    const Divider(),
                                                // itemCount: post.comments.length,
                                                itemCount: 12,
                                                itemBuilder: (_, i) {
                                                  // final comment =
                                                  //     post.comments[i];
                                                  return const Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          CircleProfile(
                                                            // name: comment
                                                            //     .name[0],
                                                            name: "A",
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          // Text(comment.email),
                                                          Text(
                                                              "hhtz12450@gmail.com")
                                                        ],
                                                      ),
                                                      // Text(comment.name),
                                                      // Text(comment.body),
                                                      SizedBox(height: 5),
                                                      Text("Sithu"),
                                                      Text(
                                                          "sjfidjif dkfdsh kdfdshd djfidjfi")
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icons.mode_comment_outlined,
                                  // label: "Comment ${post.comments.length}",
                                  label: "Comments",
                                ),
                                PostActionButton(
                                  icon: Icons.add_chart_outlined,
                                  label: "Chat",
                                  onTap: () {
                                    StarlightUtils.pushNamed(
                                        RouteNames.singleChat);
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
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

class LikeButton extends StatelessWidget {
  // final PostModel post;
  const LikeButton({
    super.key,
    // required this.post
  });

  @override
  Widget build(BuildContext context) {
    return PostActionButton(
      color:
          //  LikeRepository.get(widget.post.id.toString()) ?
          Colors.grey,
      //  : null,
      icon:
          //  LikeRepository.get(widget.post.id.toString())
          Icons.thumb_up_outlined,
      label: "like",
      onTap: () async {
        // await LikeRepository.action(widget.post.id.toString());
        // setState(() {});
      },
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
