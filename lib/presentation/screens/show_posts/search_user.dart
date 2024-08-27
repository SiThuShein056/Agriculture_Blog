import 'dart:developer';

import 'package:blog_app/data/datasources/remote/db_crud_service/firebase_store_db.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../routes/route_import.dart';

class SearchUser extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [const SizedBox()];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          StarlightUtils.pop();
        },
        icon: const Icon(Icons.chevron_left));
  }

  @override
  Widget buildResults(BuildContext context) {
    log("Build Result Part");

    return Center(
      child: const Text("Build Result").tr(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    log("Build Suggestion Part");
    return StreamBuilder(
        stream: FirebaseStoreDb().users,
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snap.hasError) {
            return Center(
              child: const Text("Error  Occurred").tr(),
            );
          }
          if (snap.data == null) {
            return Center(
              child: const Text("Data is null value").tr(),
            );
          }
          List<UserModel> users = snap.data!.toList();

          if (users.isEmpty) {
            return Center(
              child: const Text("No Data").tr(),
            );
          }
          final searchUser = users
              .where((e) => e.name.contains(query) || e.name.contains(query))
              .toList();
          if (searchUser.isEmpty) {
            return const Center(
              child: Text("ရှာ သော နာမည် မတွေ့ ပါ"),
            );
          }
          return ListView.builder(
              itemCount: searchUser.length,
              itemBuilder: (_, i) {
                return ListTile(
                  onTap: () {
                    StarlightUtils.pushNamed(RouteNames.profileScreen,
                        arguments: searchUser[i].id);
                  },
                  leading: CircleAvatar(
                    radius: 17,
                    backgroundImage: (searchUser[i].profielUrl.isEmpty ||
                            searchUser[i].profielUrl == '')
                        ? null
                        : NetworkImage(searchUser[i].profielUrl),
                    child: (searchUser[i].profielUrl.isEmpty ||
                            searchUser[i].profielUrl == '')
                        ? Text(searchUser[i].name[0])
                        : null,
                  ),
                  title: Text(searchUser[i].name),
                  subtitle: Text(
                    searchUser[i].email,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              });
        });
  }
}
