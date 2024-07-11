import 'dart:developer';

import 'package:blog_app/data/datasources/remote/db_crud_service/firebase_store_db.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/presentation/blocs/db_crud_bloc/create_post_cubit/post_create_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/comment_model/comment_model.dart';
import '../../common_widgets/post_action_button.dart';

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
                                    : CommentBody(
                                        comments: comments,
                                        createBloc: createBloc)),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10.0, left: 10, right: 10),
                              child: CommentTextField(
                                createBloc: createBloc,
                                postsId: postsId,
                                comments: comments,
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

class CommentBody extends StatelessWidget {
  const CommentBody({
    super.key,
    required this.comments,
    required this.createBloc,
  });

  final List<CommentModel> comments;
  final CreateCubit createBloc;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // shrinkWrap: true,
      // physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      separatorBuilder: (_, __) => const Divider(
        color: Colors.grey,
      ),
      itemCount: comments.length,
      itemBuilder: (_, i) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
                stream: FirebaseStoreDb().getUser(comments[i].userId),
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
                    return const Text("No User");
                  }
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundImage:
                            (user.profielUrl.isEmpty || user.profielUrl == '')
                                ? null
                                : NetworkImage(user.profielUrl),
                        child:
                            (user.profielUrl.isEmpty || user.profielUrl == '')
                                ? Text(user.name[0])
                                : null,
                      ),

                      const SizedBox(
                        width: 10,
                      ),
                      // Text(comment.email),
                      Text(user.name.isEmpty ? user.email[0] : user.name),
                      const Spacer(),
                      comments[i].userId == createBloc.auth.currentUser!.uid
                          ? PopupMenuButton<int>(
                              onSelected: (value) => onSelected(context, value,
                                  comments[i].id, comments[i].body),
                              itemBuilder: (context) => [
                                    const PopupMenuItem(
                                        value: 0, child: Text("Delete")),
                                    const PopupMenuItem(
                                        value: 1, child: Text("Edit"))
                                  ])
                          : const SizedBox()
                    ],
                  );
                }),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Text(comments[i].body),
            )
          ],
        );
      },
    );
  }

  onSelected(c, v, commentId, body) {
    switch (v) {
      case 0:
        createBloc.deleteComment(commentId);
        break;
      case 1:
        createBloc.ediable.value = true;
        createBloc.commentId = commentId;

        createBloc.commentController.text = body;
        break;
      default:
    }
  }
}

class CommentTextField extends StatelessWidget {
  const CommentTextField({
    super.key,
    required this.createBloc,
    required this.postsId,
    required this.comments,
  });

  final CreateCubit createBloc;
  final String postsId;
  final List<CommentModel> comments;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(221, 225, 228, 1),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 198, 188, 188).withOpacity(0.5),
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
                  controller: createBloc.commentController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                    return null;
                  },
                  minLines: 1,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      hintText: "type something", border: InputBorder.none),
                ),
              ),
            ),
            ValueListenableBuilder(
                valueListenable: createBloc.ediable,
                builder: (_, v, child) {
                  return v
                      ? IconButton(
                          onPressed: () {
                            createBloc.updateComment();
                            createBloc.ediable.value = false;
                            createBloc.commentController.text = "";
                          },
                          icon: const Icon(Icons.check))
                      : IconButton(
                          onPressed: () {
                            createBloc.createComment(
                                postsId, createBloc.commentController.text);
                            log("Add Commented");
                          },
                          icon: const Icon(Icons.send_outlined));
                })
          ],
        ),
      ),
    );
  }
}
