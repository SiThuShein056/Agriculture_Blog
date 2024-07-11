import 'package:blog_app/presentation/screens/show_posts/search_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../../../data/datasources/remote/db_crud_service/firebase_store_db.dart';
import '../../../../data/models/user_model/user_model.dart';
import '../../../routes/route_import.dart';

class ReadUser extends StatelessWidget {
  const ReadUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        leading: IconButton(
          onPressed: () {
            StarlightUtils.pop();
          },
          icon: const Icon(Icons.chevron_left),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              showSearch(context: context, delegate: SearchUser());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseStoreDb().users,
          builder: (_, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (snap.hasError) {
              return const Center(
                child: Text("Error  Occurred"),
              );
            }
            if (snap.data == null) {
              return const Center(
                child: Text("Data is null value"),
              );
            }
            List<UserModel> users = snap.data!.toList();

            if (users.isEmpty) {
              return const Center(
                child: Text("No Data"),
              );
            }

            if (users.isEmpty) {
              return const Center(
                child: Text("နာမည် မတွေ့ ပါ"),
              );
            }
            return GridView.builder(
                itemCount: users.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2),
                itemBuilder: (_, i) {
                  return InkWell(
                    onTap: () {
                      StarlightUtils.pushNamed(RouteNames.profileScreen,
                          arguments: users[i].id);
                    },
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: (users[i].profielUrl == "")
                                ? null
                                : NetworkImage(users[i].profielUrl),
                            child: (users[i].profielUrl == "" ||
                                    users[i].profielUrl.isEmpty)
                                ? const Icon(Icons.person_outlined)
                                : null,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(users[i].name),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
