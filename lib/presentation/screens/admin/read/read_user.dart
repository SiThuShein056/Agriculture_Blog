import 'package:blog_app/presentation/screens/show_posts/search_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../../../data/datasources/remote/db_crud_service/db_update_service.dart/db_read_service.dart';
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
          stream: DatabaseReadService().users,
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
                padding: const EdgeInsets.all(10),
                itemCount: users.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2),
                itemBuilder: (_, i) {
                  return InkWell(
                    onTap: () {
                      StarlightUtils.pushNamed(RouteNames.profileScreen,
                          arguments: users[i].id);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(2, 1),
                              blurRadius: 2,
                              color: Color.fromARGB(255, 47, 113, 37),
                            )
                          ],
                          gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color.fromARGB(255, 173, 239, 163),
                                Color.fromRGBO(59, 170, 92, 1)
                              ])),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                StarlightUtils.pushNamed(
                                    RouteNames.userControlScreen,
                                    arguments: users[i].id);
                              },
                              icon: const Icon(Icons.read_more_outlined),
                            ),
                          ),
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
