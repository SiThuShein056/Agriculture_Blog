part of 'home_import.dart';

class DrawerWidget extends StatelessWidget {
  HomeBloc bloc;
  DrawerWidget({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
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
                        title: "Setting".tr(),
                        onpress: () {
                          StarlightUtils.pop();
                          StarlightUtils.pushNamed(RouteNames.settingScreen,
                              arguments: bloc);
                        },
                      ),
                      ReuseListTileWidget(
                        icon: const Icon(Icons.rule_outlined),
                        title: "Lisence".tr(),
                        onpress: () {
                          showLicensePage(context: context);
                        },
                      ),
                      ReuseListTileWidget(
                        icon: const Icon(Icons.info_rounded),
                        title: "About".tr(),
                        onpress: () {
                          StarlightUtils.pushNamed(RouteNames.aboutScreen);
                        },
                      ),
                      if (user!.role != "admin")
                        StreamBuilder(
                            stream: FirebaseStoreDb()
                                .getUser("Dp7jPbZJ6eeFrVfJf9LkYBcJOun1"),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                //TODO LIKE POSTS
                                return const CupertinoActivityIndicator();
                              }
                              if (snapshot.data == null) {
                                return const Text("NONAME");
                              }
                              UserModel? user;
                              for (var element in snapshot.data!.docs) {
                                user = UserModel.fromJson(element);
                              }
                              if (user == null) {
                                return const Text("No lkhjhjUser");
                              }
                              return ReuseListTileWidget(
                                icon: const Icon(Icons.help_center_outlined),
                                title: "Help-Center".tr(),
                                onpress: () {
                                  StarlightUtils.pushNamed(
                                      RouteNames.singleChat,
                                      arguments: user);
                                },
                              );
                            }),
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
              title: "Logout".tr(),
              onpress: () {
                Injection<AuthService>().signOut();
              })
        ],
      ),
    );
  }
}
