import 'dart:developer';

import 'package:blog_app/data/datasources/remote/db_crud_service/firebase_store_db.dart';
import 'package:blog_app/data/models/category_model/category_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ShowCategories extends StatelessWidget {
  const ShowCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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

          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () {
                    StarlightUtils.pop();
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                title: const Text("အမျိုးအစားများ"),
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
                        StarlightUtils.pushNamed(RouteNames.createCategories)
                            .then((e) => StarlightUtils.pop);
                      },
                      child: const Icon(Icons.add),
                    );
                  }),
              body: StreamBuilder(
                stream: FirebaseStoreDb().categories,
                builder: (_, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  if (snap.hasError) {
                    return const Center(
                      child: Text("Error"),
                    );
                  }
                  if (snap.data == null) {
                    return const Center(
                      child: Text("Data is null value"),
                    );
                  }
                  List<CategoryModel> categories = snap.data!.toList();

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (_, i) {
                          return Card(
                              color: Theme.of(context).primaryColor,
                              child: ListTile(
                                onTap: () {
                                  StarlightUtils.pushNamed(
                                    RouteNames.subCategories,
                                    arguments: categories[i].id,
                                  ).then((v) {
                                    log("${categories[i].name}/$v");
                                    return StarlightUtils.pop(
                                        result: "${categories[i].name}/$v");
                                  });
                                },
                                title: Text(categories[i].name),
                              ));
                        }),
                  );
                },
              ));
        });
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
    return const Center(
      child: Text("Choose existed categories"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseStoreDb().categories,
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snap.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }
          if (snap.data == null) {
            return const Center(
              child: Text("Data is null value"),
            );
          }
          List<CategoryModel> categories = snap.data!.toList();
          final searchCategory =
              categories.where((e) => e.name.contains(query)).toList();

          if (searchCategory.isEmpty) {
            return const Center(
              child: Text("လို ချင်တာ မရှိ လျှင် အသစ် ထည့်ပါ"),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
                itemCount: searchCategory.length,
                itemBuilder: (_, i) {
                  return Card(
                    color: Theme.of(context).primaryColor,
                    child: ListTile(
                      title: Text(searchCategory[i].name),
                      onTap: () {
                        StarlightUtils.pushNamed(
                          RouteNames.subCategories,
                          arguments: categories[i].id,
                        ).then((v) {
                          log("${categories[i].name}/$v");
                          return StarlightUtils.pop(
                              result: "${categories[i].name}/$v");
                        });
                      },
                    ),
                  );
                }),
          );
        });
  }
}
