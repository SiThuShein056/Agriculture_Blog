import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: const Color.fromARGB(255, 13, 146, 69).withOpacity(0.5),
        automaticallyImplyLeading: false,
        leading: const IconButton(
            onPressed: (StarlightUtils.pop),
            icon: Icon(Icons.chevron_left_outlined)),
        title: const Text("Admin DashBoard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .25,
                    child: Card(
                      elevation: 3,
                      shadowColor: const Color.fromARGB(255, 13, 146, 69)
                          .withOpacity(0.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.storage_outlined),
                          const Text("Posts").centered(),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .25,
                    child: InkWell(
                      onTap: () {
                        StarlightUtils.pushNamed(RouteNames.categories);
                      },
                      child: Card(
                        elevation: 3,
                        shadowColor: const Color.fromARGB(255, 13, 146, 69)
                            .withOpacity(0.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.category_outlined),
                            const Text("Categories").centered(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .25,
              child: Card(
                elevation: 3,
                shadowColor:
                    const Color.fromARGB(255, 13, 146, 69).withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.people_outline_outlined),
                    const Text("Users").centered(),
                  ],
                ),
              ),
            ),
            // Expanded(child: const Text("data").centered()),
          ],
        ),
      ),
    );
  }
}
