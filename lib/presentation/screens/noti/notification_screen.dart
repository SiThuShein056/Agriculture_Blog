import 'package:blog_app/data/datasources/local/utils/my_util.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/db_update_service.dart/db_delete_service.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/db_update_service.dart/db_read_service.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/db_update_service.dart/db_update_service.dart';
import 'package:blog_app/data/models/notification_model/notification_model.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:easy_localization/easy_localization.dart';
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
        title: const Text("Notifications").tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder(
            stream: DatabaseReadService().notis,
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
                return Center(
                  child: const Text("No noti data").tr(),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: notis.length,
                      itemBuilder: (context, i) {
                        return Card(
                          child: Slidable(
                            endActionPane: ActionPane(
                                extentRatio: .2,
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      Injection<DatabaseDeleteService>()
                                          .deleteNoti(notis[i].id);
                                    },
                                    icon: Icons.delete,
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red[700]!,
                                  ),
                                ]),
                            child: StreamBuilder(
                                stream: DatabaseReadService()
                                    .getUser(notis[i].ownerId),
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
                                      stream: DatabaseReadService()
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
                                          return Center(
                                            child:
                                                const Text("No Post Data").tr(),
                                          );
                                        }

                                        return ListTile(
                                          // isThreeLine: true,
                                          onTap: () {
                                            StarlightUtils.pushNamed(
                                                RouteNames.postDetail,
                                                arguments: notiPost[0]);

                                            DatabaseUpdateService()
                                                .updateNotiData(
                                                    id: notis[i].id);
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
                                                ),
                                          title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        59, 170, 92, 1)),
                                                MyUtil.getPostedTime(
                                                    context: context,
                                                    time:
                                                        notiPost[0].createdAt),
                                              ),
                                              Text(
                                                notis[i].read ? "" : "New",
                                                style: const TextStyle(
                                                    color: Colors.red),
                                              ).tr()
                                            ],
                                          ),
                                        );
                                      });
                                }),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
