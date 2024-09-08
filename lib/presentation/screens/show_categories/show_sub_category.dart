import 'package:blog_app/data/datasources/remote/db_crud_service/db_update_service.dart/db_read_service.dart';
import 'package:blog_app/data/models/sub_category_modle/sub_category_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ShowSubCategory extends StatelessWidget {
  final String id;
  const ShowSubCategory({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseReadService().checkUser(),
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
                title: const Text("Sub Categories").tr(),
                actions: [
                  IconButton(
                      onPressed: () {
                        showSearch(context: context, delegate: SearchScreen(id))
                            .then((value) {
                          StarlightUtils.pop(result: value);
                        });
                      },
                      icon: const Icon(Icons.search))
                ],
              ),
              floatingActionButton:
                  //  user!.role != "admin"
                  //     ? const SizedBox()
                  //     :
                  FloatingActionButton(
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
                    return Center(
                      child: const Text("Error").tr(),
                    );
                  }
                  if (snap.data == null) {
                    return Center(
                      child: const Text("Data is null value").tr(),
                    );
                  }
                  List<SubCategoryModel> subCategories = snap.data!.toList();

                  if (subCategories.isEmpty) {
                    return Center(
                      child: const Text("No Data Found").tr(),
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
                              onTap: () {
                                StarlightUtils.pop(
                                    result: subCategories[i].name);
                              },
                              title: Text(subCategories[i].name),
                            ),
                          );
                        }),
                  );
                },
              ));
        });
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
    return Center(
      child: const Text("Choose existed categories").tr(),
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
            return Center(
              child: const Text("Error").tr(),
            );
          }
          if (snap.data == null) {
            return Center(
              child: const Text("Data is null value").tr(),
            );
          }
          List<SubCategoryModel> subCategories = snap.data!.toList();
          final searchSubCategory =
              subCategories.where((e) => e.name.contains(query)).toList();

          if (searchSubCategory.isEmpty) {
            return Center(
              child: const Text("Don't have any data? Add new data").tr(),
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
                      onTap: () {
                        StarlightUtils.pop(result: searchSubCategory[i].name);
                      },
                    ),
                  );
                }),
          );
        });
  }
}
