part of 'home_import.dart';

class DrawerWidget extends StatelessWidget {
  HomeBloc bloc;
  DrawerWidget({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // UserAccountsDrawerHeader(
          //   // decoration:
          //   //     const BoxDecoration(color: Color.fromARGB(255, 66, 70, 65)),
          //   currentAccountPicture:
          //       BlocBuilder<HomeBloc, HomeBaseState>(builder: (_, state) {
          //     var user = state.user;

          //     final isNotUploaded = user?.photoURL == null;
          //     final value = (user?.displayName ?? user?.email ?? "");

          //     if (isNotUploaded) {
          //       return CircleAvatar(
          //         child: Text(
          //           (value.isNotEmpty ? value[0] : "NA").toUpperCase(),
          //           style: const TextStyle(fontSize: 18),
          //         ),
          //       );
          //     }

          //     return FutureBuilder(
          //         future: Injection<FirebaseStorage>()
          //             .ref(user?.photoURL)
          //             .getDownloadURL(),
          //         builder: (_, snapshot) {
          //           if (snapshot.connectionState == ConnectionState.waiting) {
          //             return LoadingAnimationWidget.hexagonDots(
          //               color: Colors.green,
          //               size: 20,
          //             );
          //           }
          //           final url = snapshot.data;
          //           if (url == null) {
          //             return CircleAvatar(
          //               child: Text(
          //                 (user?.displayName ?? user?.email ?? "NA")[0]
          //                     .toUpperCase(),
          //                 style: const TextStyle(
          //                   fontSize: 18,
          //                 ),
          //               ),
          //             );
          //           }
          //           return ClipOval(
          //             child: Image.network(
          //               url,
          //               fit: BoxFit.cover,
          //               loadingBuilder: (_, child, c) {
          //                 if (c == null) return child;
          //                 return const CupertinoActivityIndicator();
          //               },
          //             ),
          //           );
          //         });
          //   }),
          //   accountName: BlocBuilder<HomeBloc, HomeBaseState>(
          //       // buildWhen: (previous, current) =>
          //       //     previous.user?.displayName != current.user?.displayName,
          //       builder: (_, state) {
          //     return Text((state.user?.displayName ?? state.user?.email ?? "NA")
          //         .toString());
          //   }),
          //   accountEmail: BlocBuilder<HomeBloc, HomeBaseState>(
          //     // buildWhen: (previous, current) =>
          //     //     previous.user?.email != current.user?.email,
          //     builder: (_, state) {
          //       return Text((state.user?.email ?? "NA"));
          //     },
          //   ),
          // ),
          SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.14,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "FarmerHub",
                    style: TextStyle(
                      letterSpacing: 2,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(
            color: Colors.grey,
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseStoreDb().checkUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CupertinoActivityIndicator();
                  }
                  if (snapshot.data == null) {
                    return const Text("NONAME");
                  }
                  UserModel? user;
                  for (var element in snapshot.data!.docs) {
                    user = UserModel.fromJson(element);
                  }

                  return Column(
                    children: [
                      ReuseListTileWidget(
                        icon: const Icon(Icons.settings),
                        title: "Setting",
                        onpress: () {
                          StarlightUtils.pop();
                          StarlightUtils.pushNamed(RouteNames.settingScreen,
                              arguments: bloc);
                        },
                      ),
                      ReuseListTileWidget(
                        icon: const Icon(Icons.rule_outlined),
                        title: "Lisence",
                        onpress: () {
                          showLicensePage(context: context);
                        },
                      ),
                      ReuseListTileWidget(
                        icon: const Icon(Icons.info_rounded),
                        title: "About",
                        onpress: () {
                          StarlightUtils.aboutDialog(
                              applicationName: "AGF",
                              applicationIcon: const FlutterLogo());
                        },
                      ),
                      ReuseListTileWidget(
                        icon: const Icon(Icons.contact_phone_outlined),
                        title: "Contacu Us",
                        onpress: () {
                          launchUrl(Uri.parse("tel:+95909766758487"));
                        },
                      ),
                      // ReuseListTileWidget(
                      //   icon: const Icon(Icons.help_center_outlined),
                      //   title: "Profile",
                      //   onpress: () {
                      //     StarlightUtils.pop();
                      //     StarlightUtils.pushNamed(RouteNames.profileScreen,
                      //         arguments: bloc);
                      //   },
                      // ),
                      if (user!.role != "admin")
                        ReuseListTileWidget(
                          icon: const Icon(Icons.help_center_outlined),
                          title: "HelpCenter",
                          onpress: () {
                            StarlightUtils.pop();
                          },
                        ),
                      if (user.role == "admin")
                        ReuseListTileWidget(
                          icon: const Icon(Icons.admin_panel_settings_outlined),
                          title: "AdminDashBoard",
                          onpress: () {
                            StarlightUtils.pushNamed(RouteNames.adminDashBoard);
                          },
                        ),
                    ],
                  );
                }),
          ),

          ReuseListTileWidget(
              icon: const Icon(Icons.logout_rounded),
              title: "Logout",
              onpress: () {
                Injection<AuthService>().signOut();
              })
        ],
      ),
    );
  }
}
