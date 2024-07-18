import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/presentation/screens/profile/profile_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../../injection.dart';
import '../../routes/route_import.dart';

class PostDetail extends StatelessWidget {
  const PostDetail({super.key});

  @override
  Widget build(BuildContext context) {
    PostModel posts = ModalRoute.of(context)!.settings.arguments as PostModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(posts.category),
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
                                onTap: () {
                                  Injection<FirebaseFirestore>()
                                      .collection("posts")
                                      .doc(posts.id)
                                      .delete()
                                      .then((_) {
                                    StarlightUtils.pop();
                                  });
                                },
                                title: const Text("Delete"),
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
                                title: const Text("Update"),
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
          ],
        ),
      ),
    );
  }
}
