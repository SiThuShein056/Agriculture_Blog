import 'package:blog_app/data/datasources/local/utils/my_util.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/firebase_store_db.dart';
import 'package:blog_app/data/models/main_category_model/main_cateory_model.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ReadMainCategory extends StatelessWidget {
  const ReadMainCategory({super.key});

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
          title: const Text("အဓိကအမျိုးအစားများ"),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchScreen());
                },
                icon: const Icon(Icons.search))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            StarlightUtils.pushNamed(RouteNames.createMainCategories);
            // .then((e) => StarlightUtils.pop);
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: FirebaseStoreDb().mainCategories,
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
            List<MainCategoryModel> mainCategories = snap.data!.toList();

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
                              RouteNames.readCategories,
                              arguments: mainCategories[i].id,
                            );
                          },
                          title: Text(mainCategories[i].name),
                          trailing: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            Injection<FirebaseFirestore>()
                                                .collection("mainCategories")
                                                .doc(mainCategories[i].id)
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
                                                RouteNames.updateCategoryScreen,
                                                arguments: mainCategories[i]);
                                          },
                                          title: const Text("Update"),
                                          trailing: const Icon(Icons.update),
                                        )
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(Icons.more_vert),
                          ),
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
    return const Center(
      child: Text("Choose existed Main categories"),
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
            return const Center(
              child: Text("Error"),
            );
          }
          if (snap.data == null) {
            return const Center(
              child: Text("Data is null value"),
            );
          }
          List<MainCategoryModel> mainCategories = snap.data!.toList();
          final searchCategory =
              mainCategories.where((e) => e.name.contains(query)).toList();

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
                      trailing: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (_) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        Injection<FirebaseFirestore>()
                                            .collection("categories")
                                            .doc(mainCategories[i].id)
                                            .delete()
                                            .then((_) {
                                          MyUtil.showToast(context);
                                          StarlightUtils.pop();
                                        });
                                      },
                                      title: const Text("Delete"),
                                      trailing: const Icon(Icons.delete),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        StarlightUtils.pushNamed(
                                            RouteNames.updateCategoryScreen,
                                            arguments: mainCategories[i]);
                                      },
                                      title: const Text("Update"),
                                      trailing: const Icon(Icons.update),
                                    )
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.more_vert),
                      ),
                      onTap: () {
                        StarlightUtils.pushNamed(
                          RouteNames.readCategories,
                          arguments: mainCategories[i].id,
                        );
                      },
                    ),
                  );
                }),
          );
        });
  }
}
