part of 'setting_import.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeCubit themeCubit = context.read<ThemeCubit>();

    return Scaffold(
        appBar: AppBar(title: const Text("setting").tr()),
        body: Column(
          children: [
            ListTile(
              title: const Text("Languages"),
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
            // BlocBuilder<ThemeCubit, ThemeMode>(builder: (_, state) {
            //   return CheckboxListTile(
            //     onChanged: (_) {
            //       themeCubit.toggleTheme(_);
            //     },
            //     value: state == ThemeMode.dark,
            //     title: const Text("Dark Theme"),
            //   );
            // }),
            ListTile(
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
            )
          ],
        ));
  }
}
