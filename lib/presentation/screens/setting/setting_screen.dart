part of 'setting_import.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    final ThemeCubit themeCubit = context.read<ThemeCubit>();

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: const IconButton(
              onPressed: (StarlightUtils.pop),
              icon: Icon(Icons.chevron_left_outlined)),
          title: const Text(
            "setting",
            style: TextStyle(fontSize: 20),
          ).tr()),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                await Injection<AuthService>().updatePickProfilePhoto();
              },
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  BlocBuilder<HomeBloc, HomeBaseState>(builder: (_, state) {
                    final isNotUploaded = state.user?.photoURL == null;
                    final name =
                        state.user?.displayName ?? state.user?.email ?? "NA";

                    if (isNotUploaded) {
                      return CircleAvatar(
                        radius: 50,
                        child: Text(
                          (name)[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      );
                    }

                    return FutureBuilder(
                        future: Injection<FirebaseStorage>()
                            .ref(state.user?.photoURL)
                            .getDownloadURL(),
                        builder: (_, snapshot) {
                          log("before Download url ${state.user?.photoURL}");
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return LoadingAnimationWidget.hexagonDots(
                                color: Colors.green, size: 20);
                          }
                          // if (snapshot.error != null) {
                          //   StarlightUtils.snackbar(
                          //       const SnackBar(content: Text("URL Error")));
                          // }

                          final url = snapshot.data;
                          if (url == null) {
                            return CircleAvatar(
                              radius: 50,
                              child: Text(
                                (name)[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            );
                          }
                          log("profile image url is $url");
                          return Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.5,
                                color: const Color.fromARGB(255, 152, 192, 153),
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                                loadingBuilder: (_, child, c) {
                                  if (c == null) return child;
                                  return const CupertinoActivityIndicator();
                                },
                              ),
                            ),
                          );
                        });
                  }),
                  const Positioned(
                      bottom: -10,
                      child: Icon(
                        Icons.add_circle_outline,
                        color: Color.fromARGB(255, 22, 49, 18),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: BlocBuilder<HomeBloc, HomeBaseState>(
                  buildWhen: (previous, current) =>
                      previous.user?.displayName != current.user?.displayName,
                  builder: (_, state) {
                    return Text(
                      (state.user?.displayName ??
                          state.user?.email?[0] ??
                          "NA"),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    );
                  }),
            ),
            Expanded(
                child: Column(
              children: [
                BlocBuilder<HomeBloc, HomeBaseState>(
                    buildWhen: (previous, current) =>
                        previous.user?.displayName != current.user?.displayName,
                    builder: (_, state) {
                      log("NAME BLOC BUILDER BUILD");

                      return ReuseListTileWidget(
                        icon: const Icon(Icons.person_outline),
                        title: state.user?.displayName ??
                            state.user?.email?[0] ??
                            "NA",
                        onpress: () {
                          StarlightUtils.pushNamed(RouteNames.nameChangeScreen,
                              arguments: bloc);
                        },
                      );
                    }),
                BlocBuilder<HomeBloc, HomeBaseState>(
                    buildWhen: (previous, current) =>
                        previous.user?.email != current.user?.email,
                    builder: (_, state) {
                      log("Mail BLOC BUILDER BUILD");
                      return ReuseListTileWidget(
                        icon: const Icon(Icons.email_outlined),
                        title: state.user?.email ?? "",
                        onpress: () {
                          StarlightUtils.pushNamed(RouteNames.mailChangeScreen,
                              arguments: bloc);
                        },
                      );
                    }),
                // ReuseListTileWidget(
                //   icon: const Icon(Icons.mail_outline),
                //   title: "Change Mail",
                //   onpress: () {
                //     StarlightUtils.pushNamed(RouteNames.mailChangeScreen,
                //         arguments: bloc);
                //   },
                // ),
                ReuseListTileWidget(
                  icon: const Icon(Icons.lock_open_outlined),
                  title: "Change Password",
                  onpress: () {
                    StarlightUtils.pushNamed(RouteNames.passswordChangeScreen,
                        arguments: bloc);
                  },
                ),
                Card(
                  child: ListTile(
                    title: const Text("Languages"),
                    trailing: SizedBox(
                      width: 60,
                      child: DropdownButton(
                          alignment: Alignment.center,
                          borderRadius: BorderRadius.circular(5),
                          value:
                              context.locale.languageCode == "en" ? "en" : "my",
                          items: ["en", "my"]
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (_) {
                            context.setLocale(_ == "en"
                                ? const Locale("en", "US")
                                : const Locale("my", "MM"));
                          }),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text("Theme"),
                    trailing: SizedBox(
                      width: 60,
                      child: BlocBuilder<ThemeCubit, ThemeMode>(
                          builder: (context, state) {
                        return AnimatedToggleSwitch.dual(
                          style: ToggleStyle(
                            backgroundColor: Injection<SharedPreferences>()
                                        .getBool("current_theme") ==
                                    true
                                ? const Color.fromRGBO(71, 84, 103, 1)
                                : const Color.fromRGBO(234, 236, 240, 1),
                            indicatorColor: Colors.transparent,
                          ),
                          onTap: (props) {
                            themeCubit.toggleTheme();
                          },
                          animationOffset: const Offset(10, 0),
                          indicatorSize: const Size(30, 30),
                          current: Injection<SharedPreferences>()
                                      .getBool("current_theme") ==
                                  true
                              ? 1
                              : 0,
                          first: 0,
                          second: 1,
                          height: 35,
                          borderWidth: 0,
                          spacing: 20,
                          iconBuilder: (i) {
                            return [
                              const Icon(Icons.light_mode_outlined),
                              const Icon(
                                Icons.brightness_2_outlined,
                                color: Colors.amber,
                              )
                            ][i];
                          },
                        );
                      }),
                    ),
                  ),
                )
                // BlocBuilder<ThemeCubit, ThemeMode>(builder: (_, state) {
                //   return CheckboxListTile(
                //     onChanged: (_) {
                //       themeCubit.toggleTheme(_);
                //     },
                //     value: state == ThemeMode.dark,
                //     title: const Text("Dark Theme"),
                //   );
                // }),

                // ReuseListTileWidget(
                //     icon: const Icon(Icons.logout_outlined),
                //     title: "logout",
                //     onpress: () {
                //       bloc.add(const HomeUserSignOutEvent());
                //     }),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
