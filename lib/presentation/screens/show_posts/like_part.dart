import 'package:blog_app/data/datasources/remote/db_crud_service/firebase_store_db.dart';
import 'package:blog_app/data/models/like_model/like_model.dart';
import 'package:blog_app/presentation/blocs/post_crud_bloc/create_post_cubit/post_create_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/post_action_button.dart';

class LikePart extends StatelessWidget {
  const LikePart({
    super.key,
    required this.postId,
    required this.createCubit,
  });

  final String postId;
  final CreateCubit createCubit;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LikeModel>>(
        stream: FirebaseStoreDb().likes(postId),
        builder: (context, likeSnap) {
          if (likeSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (likeSnap.data == null) {
            return Center(
              child: const Text("No Data").tr(),
            );
          }
          var likes = likeSnap.data!;
          bool? liked = false;
          for (var element in likes) {
            if (element.userId == createCubit.auth.currentUser!.uid) {
              liked = true;
            }
          }
          return PostActionButton(
            color: likes.isEmpty
                ? null
                : liked!
                    ? Colors.blue
                    : null,
            icon: likes.isEmpty
                ? Icons.thumb_up_outlined
                : liked!
                    ? Icons.thumb_up_alt_rounded
                    : Icons.thumb_up_outlined,
            label: likes.isEmpty
                ? "like".tr()
                : liked!
                    ? "liked ${likes.length}".tr()
                    : "likes${likes.length}".tr(),
            onTap: () async {
              createCubit.likeAction(postId);
            },
          );
        });
  }
}
