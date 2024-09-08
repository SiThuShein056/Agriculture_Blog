import 'package:blog_app/data/datasources/remote/db_crud_service/db_update_service.dart/db_read_service.dart';
import 'package:blog_app/data/models/sub_category_modle/sub_category_model.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../../../data/datasources/local/utils/my_util.dart';

class ReadSubCategory extends StatelessWidget {
  final String id;
  const ReadSubCategory({
    super.key,
    required this.id,
  });

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
          title: const Text("Sub Categories").tr(),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchScreen(id));
                },
                icon: const Icon(Icons.search))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            StarlightUtils.pushNamed(RouteNames.createSubCategories,
                arguments: id);
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: DatabaseReadService().subcategories(id),
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
            List<SubCategoryModel> subCategories = snap.data!.toList();

            if (subCategories.isEmpty) {
              return const Center(
                child: Text("No Data"),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                  itemCount: subCategories.length,
                  itemBuilder: (_, i) {
                    return Card(
                      color: Theme.of(context).primaryColor,
                      child: ListTile(
                        title: Text(subCategories[i].name),
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
                                              .collection("subCategories")
                                              .doc(subCategories[i].id)
                                              .delete()
                                              .then((_) {
                                            MyUtil.showToast(context);

                                            StarlightUtils.pop();
                                          });
                                        },
                                        title: const Text("Delete").tr(),
                                        trailing: const Icon(Icons.delete),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          StarlightUtils.pushNamed(
                                              RouteNames
                                                  .updateSubCategoryScreen,
                                              arguments: subCategories[i]);
                                        },
                                        title: const Text("Update").tr(),
                                        trailing: const Icon(Icons.update),
                                      )
                                    ],
                                  );
                                });
                          },
                          icon: const Icon(Icons.more_vert),
                        ),
                      ),
                    );
                  }),
            );
          },
        ));
  }
}

class SearchScreen extends SearchDelegate {
  String id;
  SearchScreen(this.id);
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
        stream: DatabaseReadService().subcategories(id),
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
          List<SubCategoryModel> subCategories = snap.data!.toList();
          final searchSubCategory =
              subCategories.where((e) => e.name.contains(query)).toList();

          if (searchSubCategory.isEmpty) {
            return const Center(
              child: Text("လို ချင်တာ မရှိ လျှင်  အသစ် ထည့်ပါ"),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
                itemCount: searchSubCategory.length,
                itemBuilder: (_, i) {
                  return Card(
                    color: Theme.of(context).primaryColor,
                    child: ListTile(
                      title: Text(searchSubCategory[i].name),
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
                                            .collection("subCategories")
                                            .doc(subCategories[i].id)
                                            .delete()
                                            .then((_) {
                                          StarlightUtils.pop();
                                        });
                                      },
                                      title: const Text("Delete").tr(),
                                      trailing: const Icon(Icons.delete),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        StarlightUtils.pushNamed(
                                            RouteNames.updateSubCategoryScreen,
                                            arguments: subCategories[i]);
                                      },
                                      title: const Text("Update").tr(),
                                      trailing: const Icon(Icons.update),
                                    )
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.more_vert),
                      ),
                      onTap: () {
                        StarlightUtils.pop();
                      },
                    ),
                  );
                }),
          );
        });
  }
}
