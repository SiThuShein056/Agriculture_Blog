part of 'home_import.dart';

class DrawerWidget extends StatelessWidget {
  HomeBloc bloc;
  DrawerWidget({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            // decoration:
            //     const BoxDecoration(color: Color.fromARGB(255, 66, 70, 65)),
            currentAccountPicture:
                BlocBuilder<HomeBloc, HomeBaseState>(builder: (_, state) {
              var user = state.user;

              final isNotUploaded = user?.photoURL == null;
              final value = (user?.displayName ?? user?.email ?? "");

              if (isNotUploaded) {
                return CircleAvatar(
                  child: Text(
                    (value.isNotEmpty ? value[0] : "NA").toUpperCase(),
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              }

              return FutureBuilder(
                  future: Injection<FirebaseStorage>()
                      .ref(user?.photoURL)
                      .getDownloadURL(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingAnimationWidget.hexagonDots(
                        color: Colors.green,
                        size: 20,
                      );
                    }
                    final url = snapshot.data;
                    if (url == null) {
                      return CircleAvatar(
                        child: Text(
                          (user?.displayName ?? user?.email ?? "NA")[0]
                              .toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      );
                    }
                    return ClipOval(
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        loadingBuilder: (_, child, c) {
                          if (c == null) return child;
                          return const CupertinoActivityIndicator();
                        },
                      ),
                    );
                  });
            }),
            accountName: BlocBuilder<HomeBloc, HomeBaseState>(
                // buildWhen: (previous, current) =>
                //     previous.user?.displayName != current.user?.displayName,
                builder: (_, state) {
              return Text((state.user?.displayName ?? state.user?.email ?? "NA")
                  .toString());
            }),
            accountEmail: BlocBuilder<HomeBloc, HomeBaseState>(
              // buildWhen: (previous, current) =>
              //     previous.user?.email != current.user?.email,
              builder: (_, state) {
                return Text((state.user?.email ?? "NA"));
              },
            ),
          ),
          Expanded(
            child: Column(
              children: [
                ReuseListTileWidget(
                  icon: const Icon(Icons.person),
                  title: "Profile",
                  onpress: () {
                    StarlightUtils.pop();
                    StarlightUtils.pushNamed(RouteNames.profileScreen,
                        arguments: bloc);
                  },
                ),
                ReuseListTileWidget(
                  icon: const Icon(Icons.settings),
                  title: "Setting",
                  onpress: () {
                    StarlightUtils.pop();
                    StarlightUtils.pushNamed(RouteNames.settingScreen);
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}