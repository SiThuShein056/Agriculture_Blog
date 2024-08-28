import 'dart:developer';

import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/firebase_store_db.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/presentation/blocs/post_crud_bloc/create_post_cubit/post_create_cubit.dart';
import 'package:blog_app/presentation/screens/show_posts/comment_part.dart';
import 'package:blog_app/presentation/screens/show_posts/like_part.dart';
import 'package:blog_app/presentation/screens/show_posts/profile/profile_import.dart';
import 'package:blog_app/presentation/screens/show_posts/show_post_import.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../../injection.dart';
import '../../routes/route_import.dart';

class PostDetail extends StatelessWidget {
  const PostDetail({super.key});

  @override
  Widget build(BuildContext context) {
    PostModel posts = ModalRoute.of(context)!.settings.arguments as PostModel;
    CreateCubit createCubit = context.read<CreateCubit>();
    var phone = posts.phone;

    log(phone.toString());

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        title: const Text("Post Detail").tr(),
        automaticallyImplyLeading: false,
        leading: const IconButton(
            onPressed: (StarlightUtils.pop),
            icon: Icon(Icons.chevron_left_outlined)),
        actions: [
          posts.userId != Injection<AuthService>().currentUser!.uid
              ? const SizedBox()
              : IconButton(
                  onPressed: () async {
                    await showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                onTap: () async {
                                  await createCubit
                                      .deletePost(posts.id)
                                      .then((_) {
                                    StarlightUtils.pop();
                                  });
                                },
                                title: const Text("Delete").tr(),
                                trailing: const Icon(Icons.delete),
                              ),
                              ListTile(
                                onTap: () {
                                  StarlightUtils.pushNamed(
                                          RouteNames.updatePostScreen,
                                          arguments: posts)
                                      .then((_) {
                                    StarlightUtils.pop();
                                  });
                                },
                                title: const Text("Update").tr(),
                                trailing: const Icon(Icons.update),
                              )
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.more_vert),
                )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            StreamBuilder(
                stream: FirebaseStoreDb().getUser(posts.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                  return GestureDetector(
                    onTap: () {
                      StarlightUtils.pushNamed(RouteNames.profileScreen,
                          arguments: user!.id.toString());
                    },
                    child: PostCardTopRow(
                      user: user,
                      post: posts,
                      createCubit: createCubit,
                    ),
                  );
                }),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10, bottom: 5, left: 3, right: 3),
              child: Text(
                posts.category,
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (phone == "") const SizedBox(),
            if (phone != "")
              InkWell(
                  onTap: () {
                    createCubit.callNumber("${posts.phone}");
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: Text(
                      "Phone Number: $phone",
                      style: const TextStyle(color: Colors.blue),
                    ).tr(),
                  )),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                posts.description,
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            MultiPhotoShow(postId: posts.id),
            PostVideoShow(postId: posts.id),
            const Divider(),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LikePart(
                    postId: posts.id,
                    createCubit: createCubit,
                  ),
                  CommentPart(
                    postsId: posts.id,
                    createBloc: createCubit,
                    postedUserID: posts.userId,
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
