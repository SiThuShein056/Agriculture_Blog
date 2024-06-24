import 'dart:developer';

import 'package:blog_app/data/datasources/remote/db_service/firebase_store_db.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

// class ShowCategories extends StatelessWidget {
//   const ShowCategories({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final bloc = context.read<HomeBloc>();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Categories"),
//       ),
//       body: StreamBuilder<List<CategoryModel>>(
//           stream: bloc.categories,
//           builder: (_, snap) {
//             if (snap.connectionState == ConnectionState.waiting) {
//               return const Center(child: CupertinoActivityIndicator());
//             }
//             if (snap.data == null) {
//               return const Center(
//                 child: Text("No Data"),
//               );
//             }

//             List<CategoryModel> categories = snap.data!.reversed.toList();

//             if (categories.isEmpty) {
//               return const Center(
//                 child: Text("No Data"),
//               );
//             }
//             return ListView.builder(
//                 itemCount: categories.length,
//                 itemBuilder: (_, i) {
//                   return Card(
//                     child: ListTile(
//                       onTap: () {
//                         StarlightUtils.pop(result: categories[i].name);
//                       },
//                       title: Text(categories[i].name),
//                     ),
//                   );
//                 });
//           }),
//     );
//   }
// }
class SearchSubCategory extends StatefulWidget {
  final String id;
  const SearchSubCategory({
    super.key,
    required this.id,
  });

  @override
  State<SearchSubCategory> createState() => _SearchProductsState();
}

class _SearchProductsState extends State<SearchSubCategory> {
  List allResult = [];
  List resultList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    log(_searchController.text);
    searchResultList();
  }

  searchResultList() {
    var showResult = [];
    if (_searchController.text != "") {
      for (var clientSnapshot in allResult) {
        var name = clientSnapshot['name'].toString().toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())) {
          showResult.add(clientSnapshot);
        } else {
          resultList = [];
        }
      }
    } else {
      showResult = List.from(allResult);
    }

    setState(() {
      resultList = showResult;
    });
  }

  getClientStream() async {
    log("Your id is ${widget.id}");

    var data = await FirebaseFirestore.instance
        .collection("subCategories")
        .where("category_id", isEqualTo: widget.id)
        .orderBy("name")
        .get();

    setState(() {
      allResult = data.docs;
      log("${allResult.length}");
    });
    searchResultList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: CupertinoSearchTextField(
          controller: _searchController,
        ),
        centerTitle: true,
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
            if (user!.role != "admin") {
              return const SizedBox();
            }
            return FloatingActionButton(
              onPressed: () {
                StarlightUtils.pushNamed(RouteNames.createSubCategories,
                    arguments: widget.id);
              },
              child: const Icon(Icons.add),
            );
          }),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: resultList.isEmpty
            ? const Center(
                child:
                    Text("သင်လိုချင်တာမရှီလျှင် 'အခြားမျိုးစား' ကို ရွေး ပါ။"),
              )
            : ListView.builder(
                itemCount: resultList.length,
                itemBuilder: (context, indext) {
                  return Card(
                    color: Theme.of(context).primaryColor,
                    child: ListTile(
                      title: Text(
                        resultList[indext]['name'],
                      ),
                      onTap: () {
                        StarlightUtils.pop(result: resultList[indext]['name']);
                      },
                    ),
                  );
                }),
      ),
    );
  }
}
