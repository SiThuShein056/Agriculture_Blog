import 'package:blog_app/data/datasources/local/utils/my_util.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/db_update_service.dart/db_update_service.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/firebase_store_db.dart';
import 'package:blog_app/data/models/notification_model/notification_model.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:starlight_utils/starlight_utils.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            StarlightUtils.pop();
          },
        ),
        title: const Text("Notifications"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder(
            stream: FirebaseStoreDb().notis,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error Occurred"),
                );
              }
              List<NotificationModel> notis = snapshot.data!.toList();
              if (notis.isEmpty) {
                return const Center(
                  child: Text("No noti data"),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: notis.length,
                      itemBuilder: (context, i) {
                        return Slidable(
                          endActionPane: ActionPane(
                              extentRatio: .3,
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    DatabaseUpdateService()
                                        .deleteNoti(notis[i].id);
                                  },
                                  icon: Icons.delete,
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red[700]!,
                                ),
                              ]),
                          child: StreamBuilder(
                              stream:
                                  FirebaseStoreDb().getUser(notis[i].ownerId),
                              builder: (_, snap) {
                                if (snap.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CupertinoActivityIndicator());
                                }
                                if (snap.hasError) {
                                  return const Center(
                                      child: Text("Error Occurred"));
                                }
                                UserModel? user;
                                for (var element in snap.data!.docs) {
                                  user = UserModel.fromJson(element);
                                }
                                if (user == null) {
                                  return const Text("No User");
                                }

                                return StreamBuilder(
                                    stream: FirebaseStoreDb()
                                        .singlePosts(notis[i].postId),
                                    builder: (context, postSnap) {
                                      if (postSnap.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child:
                                                CupertinoActivityIndicator());
                                      }
                                      if (postSnap.data == null) {
                                        return const Center(
                                          child: Text("Post No Dkkkata"),
                                        );
                                      }
                                      List<PostModel> notiPost =
                                          postSnap.data!.toList();

                                      if (notiPost.isEmpty) {
                                        return const Center(
                                          child: Text("No Post Data"),
                                        );
                                      }

                                      return ListTile(
                                        // isThreeLine: true,
                                        onTap: () {
                                          StarlightUtils.pushNamed(
                                              RouteNames.postDetail,
                                              arguments: notiPost[0]);

                                          DatabaseUpdateService()
                                              .updateNotiData(id: notis[i].id);
                                        },
                                        leading: (user?.profielUrl == null ||
                                                user?.profielUrl == "")
                                            ? CircleAvatar(
                                                radius: 25,
                                                child: Text(user!.email[0]),
                                              )
                                            : CircleAvatar(
                                                radius: 25,
                                                backgroundImage: NetworkImage(
                                                    user!.profielUrl),
                                                child: Text(user.name[0]),
                                              ),
                                        title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                user.name,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                        subtitle: Text(
                                          notiPost[0].category,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              MyUtil.getPostedTime(
                                                  context: context,
                                                  time: notiPost[0].createdAt),
                                            ),
                                            Text(
                                              notis[i].read ? "" : "New",
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              }),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[400],
                        // indent: size.width * .08,
                        // endIndent: size.width * .08,
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
