import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const IconButton(
            onPressed: (StarlightUtils.pop),
            icon: Icon(Icons.chevron_left_outlined)),
        title: const Text("Admin DashBoard"),
      ),
      body: GridView(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
        children: [
          const Card(
            child: Center(
              child: Text(
                "Users",
              ),
            ),
          ),
          const Card(
            child: Center(
              child: Text(
                "Posts",
              ),
            ),
          ),
          InkWell(
            onTap: () {
              StarlightUtils.pushNamed(
                RouteNames.categories,
              );
            },
            child: const Card(
              child: Center(
                child: Text(
                  "Categories",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
