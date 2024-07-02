import 'package:blog_app/data/datasources/remote/db_service/firebase_store_db.dart';
import 'package:blog_app/data/models/sub_category_modle/sub_category_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class SearchSubCategory extends StatelessWidget {
  final String id;
  const SearchSubCategory({
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
          title: const Text("အမျိုးအစားခွဲများ"),
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
              if (user!.role == "admin") {
                return const SizedBox();
              }
              return FloatingActionButton(
                onPressed: () {
                  StarlightUtils.pushNamed(RouteNames.createSubCategories,
                      arguments: id);
                },
                child: const Icon(Icons.add),
              );
            }),
        body: StreamBuilder(
          stream: FirebaseStoreDb().subcategories(id),
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
                        onTap: () {
                          StarlightUtils.pop(result: subCategories[i].name);
                        },
                        title: Text(subCategories[i].name),
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
        stream: FirebaseStoreDb().subcategories(id),
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
