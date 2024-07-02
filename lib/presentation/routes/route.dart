part of 'route_import.dart';

// for middleware
List<String> protectedRoutes = ["/home"];

class RouteNames {
  static const String splash = "/",
      home = "/home",
      // auth = "/auth",
      loginScreen = "/loin-screen",
      registerScreen = "/register-screen",
      nameChangeScreen = "/name-change-Screen",
      passswordChangeScreen = "/password-change-screen",
      forgetPassword = "/forget-password-screen",
      verifyOtpScreen = "/verifyOtpScreen",
      mailChangeScreen = "/mail-change-screen",
      settingScreen = "/setting-screen",
      updateUserScreen = "/update-user-screen",
      profileScreen = "/profile-screen",
      createPostScreen = "/create-post-screen",
      postDetail = "/post-detail",
      categories = "/categories",
      createCategories = "/createCategories",
      createSubCategories = "/createSubCategories",
      adminDashBoard = "/admin-dash-board",
      noti = "/notification-screen",
      singleChat = "/single-chat",
      searchPost = "/search-post",
      subCategories = "/sub-categories";
}

Route? router(RouteSettings settings) {
  final String incomingRoute = settings.name ?? "/";

  switch (incomingRoute) {
    case RouteNames.splash:
      return _protectedRoute(incomingRoute, const SplashScreen(), settings);

    case RouteNames.home:
      return _protectedRoute(
          incomingRoute,
          MultiBlocProvider(providers: [
            BlocProvider<HomeBloc>(
              create: (_) => HomeBloc(
                HomeInitialState(Injection<AuthService>().currentUser),
              ),
            ),
            BlocProvider(
              create: (_) => NavigationBloc(
                const NavigationState(0),
              ),
            ),
            BlocProvider(
              create: (_) => CreateCubit(),
            ),
          ], child: const HomeScreen()),
          settings);
    case RouteNames.loginScreen:
      return _protectedRoute(
          incomingRoute,
          BlocProvider(
            create: (_) => LoginBloc(),
            child: const LoginScreen(),
          ),
          settings);
    case RouteNames.categories:
      return _protectedRoute(
          incomingRoute,
          BlocProvider(
            create: (_) => HomeBloc(
              HomeInitialState(Injection<AuthService>().currentUser),
            ),
            child: const SearchCategory(),
          ),
          settings);
    case RouteNames.subCategories:
      return _protectedRoute(
          incomingRoute,
          BlocProvider(
            create: (_) => HomeBloc(
              HomeInitialState(Injection<AuthService>().currentUser),
            ),
            child: SearchSubCategory(
              id: settings.arguments.toString(),
            ),
          ),
          settings);

    case RouteNames.registerScreen:
      return _protectedRoute(
        incomingRoute,
        BlocProvider<RegisterBloc>(
          create: (_) => RegisterBloc(),
          child: const RegisterScreen(),
        ),
        settings,
      );
    case RouteNames.forgetPassword:
      return _protectedRoute(
        incomingRoute,
        BlocProvider<UpdateUserInfoBloc>(
          create: (_) => UpdateUserInfoBloc(),
          child: const ForgetPasswordScreen(),
        ),
        settings,
      );
    case RouteNames.verifyOtpScreen:
      return _protectedRoute(
        incomingRoute,
        BlocProvider<UpdateUserInfoBloc>(
          create: (_) => UpdateUserInfoBloc(),
          child: OtpVerifyScreen(
            email: settings.arguments.toString(),
          ),
        ),
        settings,
      );

    case RouteNames.settingScreen:
      final value = settings.arguments;
      if (value is! HomeBloc) {
        return _pageRoute(ErrorWidget("Home bloc is not found!!"), settings);
      }
      return _protectedRoute(
        incomingRoute,
        BlocProvider.value(
          value: value,
          child: const SettingScreen(),
        ),
        settings,
      );
    case RouteNames.nameChangeScreen:
      final value = settings.arguments;
      if (value is! HomeBloc) {
        return _pageRoute(ErrorWidget("Home bloc is not found!!"), settings);
      }
      return _protectedRoute(
        incomingRoute,
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: value),
            BlocProvider(create: (_) => UpdateUserInfoBloc())
          ],
          child: const UpdateUserScreen(
            title: "Update Name",
            label: "Enter your name",
            // value: Injection<AuthService>().currentUser?.displayName ?? "NA",
          ),
        ),
        settings,
      );
    case RouteNames.mailChangeScreen:
      final value = settings.arguments;
      if (value is! HomeBloc) {
        return _pageRoute(ErrorWidget("Home bloc is not found!!"), settings);
      }
      return _protectedRoute(
        incomingRoute,
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: value),
            BlocProvider(create: (_) => UpdateUserInfoBloc())
          ],
          child: const UpdateUserScreen(
            title: "Update Mail",
            label: "Enter your new Mail",
            isMailChanged: true,
          ),
        ),
        settings,
      );
    case RouteNames.passswordChangeScreen:
      final value = settings.arguments;
      if (value is! HomeBloc) {
        return _pageRoute(ErrorWidget("Home bloc is not found!!"), settings);
      }
      return _protectedRoute(
        incomingRoute,
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: value),
            BlocProvider(create: (_) => UpdateUserInfoBloc())
          ],
          child: const UpdateUserScreen(
            title: "Update Password",
            label: "Enter your new Password",
            isPasswordChanged: true,
          ),
        ),
        settings,
      );

    case RouteNames.postDetail:
      return _protectedRoute(
        incomingRoute,
        const PostDetail(),
        settings,
      );
    case RouteNames.noti:
      return _protectedRoute(
        incomingRoute,
        const NotificationScreen(),
        settings,
      );
    case RouteNames.profileScreen:
      return _protectedRoute(
        incomingRoute,
        const ProfileScreen(),
        settings,
      );
    case RouteNames.adminDashBoard:
      return _protectedRoute(
        incomingRoute,
        const AdminDashboard(),
        settings,
      );
    case RouteNames.singleChat:
      return _protectedRoute(
        incomingRoute,
        const SingleChat(),
        settings,
      );
    case RouteNames.searchPost:
      return _protectedRoute(
        incomingRoute,
        const SearchPostScreen(),
        settings,
      );
    case RouteNames.createPostScreen:
      final value = settings.arguments;
      if (value is! CreateCubit) {
        return _pageRoute(ErrorWidget("Post bloc is not found!!"), settings);
      }
      return _protectedRoute(
        incomingRoute,
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: value),
          ],
          child: const CreatePost(),
        ),
        settings,
      );
    case RouteNames.createCategories:
      return _protectedRoute(
        incomingRoute,
        MultiBlocProvider(
          providers: [BlocProvider(create: (_) => CreateCubit())],
          child: const CreateCategory(),
        ),
        settings,
      );
    case RouteNames.createSubCategories:
      return _protectedRoute(
        incomingRoute,
        MultiBlocProvider(
          providers: [BlocProvider(create: (_) => CreateCubit())],
          child: const CreateSubCategory(),
        ),
        settings,
      );

    default:
      return _pageRoute(
          const Scaffold(
            body: Center(
              child: Text("Not Found Page"),
            ),
          ),
          settings);
  }
}

Route _pageRoute(Widget child, RouteSettings settings) {
  return CupertinoPageRoute(builder: (_) => child, settings: settings);
}

Route? _protectedRoute(String path, Widget child, RouteSettings settings) {
  return _pageRoute(
      Injection<AuthService>().currentUser == null &&
              protectedRoutes.contains(path)
          ? BlocProvider(
              create: (_) => LoginBloc(),
              child: const LoginScreen(),
            )
          : child,
      settings);
}
