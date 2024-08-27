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
        padding:
            const EdgeInsets.only(left: 10.0, right: 10, bottom: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GestureDetector(
            //   onTap: () async {
            //     await Injection<AuthService>().updatePickProfilePhoto();
            //   },
            //   child: Stack(
            //     clipBehavior: Clip.none,
            //     alignment: Alignment.center,
            //     children: [
            //       BlocBuilder<HomeBloc, HomeBaseState>(builder: (_, state) {
            //         final isNotUploaded = state.user?.photoURL == null;
            //         final name =
            //             state.user?.displayName ?? state.user?.email ?? "NA";

            //         if (isNotUploaded) {
            //           return CircleAvatar(
            //             radius: 50,
            //             child: Text(
            //               (name)[0].toUpperCase(),
            //               style: const TextStyle(
            //                 fontSize: 18,
            //               ),
            //             ),
            //           );
            //         }

            //         return FutureBuilder(
            //             future: Injection<FirebaseStorage>()
            //                 .ref(state.user?.photoURL)
            //                 .getDownloadURL(),
            //             builder: (_, snapshot) {
            //               log("before Download url ${state.user?.photoURL}");
            //               if (snapshot.connectionState ==
            //                   ConnectionState.waiting) {
            //                 return LoadingAnimationWidget.hexagonDots(
            //                     color: Colors.green, size: 20);
            //               }
            //               // if (snapshot.error != null) {
            //               //   StarlightUtils.snackbar(
            //               //       const SnackBar(content: Text("URL Error")));
            //               // }

            //               final url = snapshot.data;
            //               if (url == null) {
            //                 return CircleAvatar(
            //                   radius: 50,
            //                   child: Text(
            //                     (name)[0].toUpperCase(),
            //                     style: const TextStyle(
            //                       fontSize: 18,
            //                     ),
            //                   ),
            //                 );
            //               }
            //               log("profile image url is $url");
            //               return Container(
            //                 width: 100,
            //                 height: 100,
            //                 decoration: BoxDecoration(
            //                   border: Border.all(
            //                     width: 1.5,
            //                     color: const Color.fromARGB(255, 152, 192, 153),
            //                   ),
            //                   shape: BoxShape.circle,
            //                 ),
            //                 child: ClipOval(
            //                   child: Image.network(
            //                     url,
            //                     fit: BoxFit.cover,
            //                     loadingBuilder: (_, child, c) {
            //                       if (c == null) return child;
            //                       return const CupertinoActivityIndicator();
            //                     },
            //                   ),
            //                 ),
            //               );
            //             });
            //       }),
            //       const Positioned(
            //           bottom: -10,
            //           child: Icon(
            //             Icons.add_circle_outline,
            //             color: Color.fromARGB(255, 22, 49, 18),
            //           ))
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   child: BlocBuilder<HomeBloc, HomeBaseState>(
            //       buildWhen: (previous, current) =>
            //           previous.user?.displayName != current.user?.displayName,
            //       builder: (_, state) {
            //         return Text(
            //           (state.user?.displayName ??
            //               state.user?.email?[0] ??
            //               "NA"),
            //           style: const TextStyle(
            //             fontSize: 18,
            //           ),
            //         );
            //       }),
            // ),
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
                      var provider = Injection<AuthService>().checkProvider();
                      log(provider);
                      if (provider == "google.com") {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("ပြောင်းလဲမှု မအောင်မြင်ပါ"),
                                content: const Text(
                                    "Google Acc ဖြင့် ၀င်ရောက်ထားသဖြင့် ‌ပြောင်းလဲမရပါ။Googleထဲတွင်သာ ပြောင်းလဲနိုင်ပါသည်။"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        StarlightUtils.pop();
                                      },
                                      child: const Text("OK").tr())
                                ],
                              );
                            });
                      } else {
                        StarlightUtils.pushNamed(RouteNames.mailChangeScreen,
                            arguments: bloc);
                      }
                    },
                  );
                }),

            ReuseListTileWidget(
              icon: const Icon(Icons.lock_open_outlined),
              title: "Change-Password".tr(),
              onpress: () {
                var provider = Injection<AuthService>().checkProvider();
                if (provider == "google.com") {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("ပြောင်းလဲမှု မအောင်မြင်ပါ"),
                          content: const Text(
                              "Google Acc ဖြင့် ၀င်ရောက်ထားသဖြင့် ‌ပြောင်းလဲမရပါ။Googleထဲတွင်သာ ပြောင်းလဲနိုင်ပါသည်။"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  StarlightUtils.pop();
                                },
                                child: const Text("Ok"))
                          ],
                        );
                      });
                } else {
                  StarlightUtils.pushNamed(RouteNames.passswordChangeScreen,
                      arguments: bloc);
                }
              },
            ),
            Card(
              child: ListTile(
                title: const Text("Languages").tr(),
                trailing: SizedBox(
                  width: 60,
                  child: DropdownButton(
                      alignment: Alignment.center,
                      borderRadius: BorderRadius.circular(5),
                      value: context.locale.languageCode == "en" ? "en" : "my",
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
                title: const Text("Theme").tr(),
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
            ),

            StreamBuilder(
                stream: FirebaseStoreDb().getUser(bloc.auth.currentUser!.uid),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  if (snapshot.data == null) {
                    return const Text("NONAME");
                  }
                  UserModel? user;
                  for (var element in snapshot.data!.docs) {
                    user = UserModel.fromJson(element);
                  }
                  if (user == null) {
                    return const Text("No User").tr();
                  }
                  return Card(
                    child: SwitchListTile(
                        value: user.commentPermission,
                        onChanged: (v) async {
                          await DatabaseUpdateService().updateUserData(
                              id: user!.id, commentPermission: v);
                        },
                        title:
                            const Text("Allow-To-Comment-On-Your-Posts").tr()),
                  );
                }),
            StreamBuilder(
                stream: FirebaseStoreDb()
                    .mySavedPosts(Injection<AuthService>().currentUser!.uid),
                builder: (context, savePostSnap) {
                  if (savePostSnap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  if (savePostSnap.data == null) {
                    return Center(
                      child: const Text("No Data").tr(),
                    );
                  }
                  var savedPosts = savePostSnap.data!;
                  return Card(
                    child: ListTile(
                      onTap: () {
                        StarlightUtils.pushNamed(RouteNames.savedPostScreen,
                            arguments: savedPosts);
                      },
                      leading: const Icon(
                        Icons.bookmark,
                      ),
                      title:
                          Text(savedPosts.isEmpty ? "Not-Save-Yet" : "My Posts")
                              .tr(),
                      trailing: savedPosts.isEmpty
                          ? const SizedBox()
                          : Text(
                              savedPosts.length.toString(),
                            ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
