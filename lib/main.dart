import 'package:blog_app/core/theme/dark_theme.dart';
import 'package:blog_app/core/theme/light_theme.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/blocs/post_media_save_bloc/post_media_save_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:toastification/toastification.dart';

import 'presentation/blocs/theme_cubit/theme_cubit_import.dart';
import 'presentation/routes/route_import.dart';

void main() async {
  await setup();
  // await LikeRepository.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('my', 'MM')],
      path: 'assets/languages', // <-- change the path of the translation files
      fallbackLocale: const Locale('en', 'US'),
      // assetLoader: loader(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeCubit(
              Injection<SharedPreferences>().getBool("current_theme") == true
                  ? ThemeMode.dark
                  : ThemeMode.light),
        ),
        BlocProvider(
          create: (_) => PostMediaSaveBloc(),
        )
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(builder: (context, state) {
        return ToastificationWrapper(
          child: MaterialApp(
            navigatorKey: StarlightUtils.navigatorKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: LightTheme().theme,
            darkTheme: DarkTheme().theme,
            themeMode: state,
            onGenerateRoute: router,
            initialRoute: RouteNames.splash,
          ),
        );
      }),
    );
  }
}
