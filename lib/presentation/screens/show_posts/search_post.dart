import 'dart:developer';

import 'package:blog_app/data/datasources/remote/db_crud_service/db_update_service.dart/db_read_service.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../routes/route_import.dart';

class SearchPost extends SearchDelegate {
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
        icon: const Icon(
          Icons.chevron_left,
        ));
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
        stream: DatabaseReadService().posts,
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
          List<PostModel> posts = snap.data!.toList();

          if (posts.isEmpty) {
            return Center(
              child: const Text("No Data").tr(),
            );
          }
          final searchPosts = posts
              .where((e) =>
                  e.category.contains(query) || e.description.contains(query))
              .toList();
          if (searchPosts.isEmpty) {
            return const Center(
              child: Text("ရှာ သော ပို့စ် မတွေ့ ပါ"),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
                itemCount: searchPosts.length,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemBuilder: (_, i) {
                  return ListTile(
                    onTap: () {
                      StarlightUtils.pushNamed(RouteNames.postDetail,
                          arguments: searchPosts[i]);
                    },
                    title: Text(searchPosts[i].category),
                    subtitle: Text(
                      searchPosts[i].description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
          );
        });
  }
}
