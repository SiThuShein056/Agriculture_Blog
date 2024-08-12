import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/presentation/common_widgets/post_action_button.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:blog_app/presentation/screens/profile/profile_import.dart';
import 'package:blog_app/presentation/screens/show_posts/search_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../../../data/datasources/local/utils/my_util.dart';
import '../../../../data/datasources/remote/auth_services/authu_service_import.dart';
import '../../../../data/datasources/remote/db_crud_service/firebase_store_db.dart';
import '../../../../data/models/post_model/post_model.dart';
import '../../../../injection.dart';
import '../../../blocs/post_crud_bloc/create_post_cubit/post_create_cubit.dart';
import '../../show_posts/comment_part.dart';
import '../../show_posts/like_part.dart';

class ReadPost extends StatelessWidget {
  const ReadPost({super.key});

  @override
  Widget build(BuildContext context) {
    var createBloc = context.read<CreateCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
        leading: IconButton(
          onPressed: () {
            StarlightUtils.pop();
          },
          icon: const Icon(Icons.chevron_left),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              showSearch(context: context, delegate: SearchPost());
            },
            icon: const Icon(Icons.search),
          ),
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
                                            Text(MyUtil.getPostedTime(
                                                context: context,
                                                time: posts[i].createdAt)),
                                          ],
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (_) {
                                                  return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      ListTile(
                                                        onTap: () {
                                                          Injection<
                                                                  FirebaseFirestore>()
                                                              .collection(
                                                                  "posts")
                                                              .doc(posts[i].id)
                                                              .delete()
                                                              .then((_) {
                                                            MyUtil.showToast(
                                                                context);

                                                            StarlightUtils
                                                                .pop();
                                                          });
                                                        },
                                                        title: const Text(
                                                            "Delete"),
                                                        trailing: const Icon(
                                                            Icons.delete),
                                                      ),
                                                      ListTile(
                                                        onTap: () {
                                                          StarlightUtils.pushNamed(
                                                              RouteNames
                                                                  .updatePostScreen,
                                                              arguments:
                                                                  posts[i]);
                                                        },
                                                        title: const Text(
                                                            "Update"),
                                                        trailing: const Icon(
                                                            Icons.update),
                                                      )
                                                    ],
                                                  );
                                                });
                                          },
                                          icon: const Icon(Icons.more_vert),
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
                                        ),
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
                                // if (posts[i].image.isEmpty ||
                                //     posts[i].image == "")
                                //   const SizedBox()
                                // else
                                //   SizedBox(
                                //       width: MediaQuery.of(context).size.width,
                                //       height:
                                //           MediaQuery.of(context).size.height *
                                //               .3,
                                //       child: InkWell(
                                //         onTap: () {
                                //           StarlightUtils.pushNamed(
                                //               RouteNames.imageViewerScreen,
                                //               arguments: posts[i].image);
                                //         },
                                //         child: Card(
                                //           child: CachedNetworkImage(
                                //             imageUrl: posts[i].image,
                                //             imageBuilder:
                                //                 (context, imageProvider) =>
                                //                     Container(
                                //               decoration: BoxDecoration(
                                //                 image: DecorationImage(
                                //                     image: imageProvider,
                                //                     fit: BoxFit.cover),
                                //               ),
                                //             ),
                                //             placeholder: (context, url) =>
                                //                 const CircularProgressIndicator()
                                //                     .centered(),
                                //             errorWidget: (context, url,
                                //                     error) =>
                                //                 const Icon(Icons.error_outline)
                                //                     .centered(),
                                //           ),
                                //         ),
                                //       )),
                                MultiPhotoShow(postId: posts[i].id),
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
                                          createBloc: createBloc),
                                      user.id !=
                                              Injection<AuthService>()
                                                  .currentUser!
                                                  .uid
                                          ? PostActionButton(
                                              icon: Icons.add_chart_outlined,
                                              label: "Chat",
                                              onTap: () {
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
