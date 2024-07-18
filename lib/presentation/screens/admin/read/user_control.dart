import 'package:blog_app/data/datasources/remote/db_crud_service/firebase_store_db.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../../../data/datasources/remote/db_crud_service/db_update_service.dart/db_update_service.dart';

class UserControl extends StatelessWidget {
  const UserControl({super.key});

  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context)!.settings.arguments as String;
    return StreamBuilder(
        stream: FirebaseStoreDb().getUser(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
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

          return Scaffold(
            appBar: AppBar(
              title: Text("${user.name}'s Permission"),
              leading: IconButton(
                  onPressed: () => StarlightUtils.pop(),
                  icon: const Icon(Icons.chevron_left)),
            ),
            body: Column(
              children: [
                SwitchListTile(
                    value: user.postStatus,
                    onChanged: (v) async {
                      await DatabaseUpdateService()
                          .updateUserData(id: user!.id, postStatus: v);
                    },
                    title: const Text("Enable Posts")),
                SwitchListTile(
                    value: user.commentStatus,
                    onChanged: (v) async {
                      await DatabaseUpdateService()
                          .updateUserData(id: user!.id, commentStatus: v);
                    },
                    title: const Text("Enable Comments")),
                SwitchListTile(
                    value: user.messageStatus,
                    onChanged: (v) async {
                      await DatabaseUpdateService()
                          .updateUserData(id: user!.id, messageStatus: v);
                    },
                    title: const Text("Enable Messages")),
              ],
            ),
          );
        });
  }
}
