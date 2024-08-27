import 'dart:developer';

import 'package:blog_app/data/datasources/remote/db_crud_service/firebase_store_db.dart';
import 'package:blog_app/data/models/main_category_model/main_cateory_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ShowMainCategories extends StatelessWidget {
  const ShowMainCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              StarlightUtils.pop();
            },
            icon: const Icon(Icons.chevron_left),
          ),
          title: const Text("Main Categories").tr(),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchScreen())
                      .then((value) {
                    StarlightUtils.pop(result: value);
                  });
                },
                icon: const Icon(Icons.search))
          ],
        ),
        floatingActionButton: StreamBuilder(
            stream: FirebaseStoreDb().checkUser(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CupertinoActivityIndicator();
              }
              if (snapshot.data == null) {
                return const SizedBox();
              }
              UserModel? user;
              for (var element in snapshot.data!.docs) {
                user = UserModel.fromJson(element);
              }
              // if (user!.role != "admin") {
              //   return const SizedBox();
              // }
              return FloatingActionButton(
                onPressed: () {
                  StarlightUtils.pushNamed(RouteNames.createMainCategories)
                      .then((e) => StarlightUtils.pop);
                },
                child: const Icon(Icons.add),
              );
            }),
        body: StreamBuilder(
          stream: FirebaseStoreDb().mainCategories,
          builder: (_, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (snap.hasError) {
              return Center(
                child: const Text("Error").tr(),
              );
            }
            if (snap.data == null) {
              return Center(
                child: const Text("Data is null value").tr(),
              );
            }
            List<MainCategoryModel> mainCategories = snap.data!.toList();
            if (mainCategories.isEmpty) {
              return Center(
                child: const Text("No data found").tr(),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                  itemCount: mainCategories.length,
                  itemBuilder: (_, i) {
                    return Card(
                        color: Theme.of(context).primaryColor,
                        child: ListTile(
                          onTap: () {
                            StarlightUtils.pushNamed(
                              RouteNames.categories,
                              arguments: mainCategories[i].id,
                            ).then((v) {
                              log("${mainCategories[i].name}/$v");
                              return StarlightUtils.pop(
                                  result: "${mainCategories[i].name}/$v");
                            });
                          },
                          title: Text(mainCategories[i].name),
                        ));
                  }),
            );
          },
        ));
  }
}

class SearchScreen extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [const SizedBox()];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          StarlightUtils.pop();
        },
        icon: const Icon(Icons.chevron_left));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: const Text("Choose existed MainCategories").tr(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseStoreDb().mainCategories,
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snap.hasError) {
            return Center(
              child: const Text("Error").tr(),
            );
          }
          if (snap.data == null) {
            return Center(
              child: const Text("Data is null value").tr(),
            );
          }
          List<MainCategoryModel> mainCategories = snap.data!.toList();
          final searchMainCategory =
              mainCategories.where((e) => e.name.contains(query)).toList();

          if (searchMainCategory.isEmpty) {
            return Center(
              child: const Text("Don't have any data? Add new data").tr(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
                itemCount: searchMainCategory.length,
                itemBuilder: (_, i) {
                  return Card(
                    color: Theme.of(context).primaryColor,
                    child: ListTile(
                      title: Text(searchMainCategory[i].name),
                      onTap: () {
                        StarlightUtils.pushNamed(
                          RouteNames.categories,
                          arguments: mainCategories[i].id,
                        ).then((v) {
                          log("${mainCategories[i].name}/$v");
                          return StarlightUtils.pop(
                              result: "${mainCategories[i].name}/$v");
                        });
                      },
                    ),
                  );
                }),
          );
        });
  }
}
