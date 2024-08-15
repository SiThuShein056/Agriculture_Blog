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
      forgetPasswordSentOTPScreen = "/forget-password-sent-otp-screen",
      forgetPasswordVerifyOtpScreen = "/forget-password-verify-otp-screen",
      aboutScreen = "/about-screen",
      savedPostScreen = "/saved-post-screen",

      // registerOTPScreen = "/register-otp-screen",
      // registerVerifyOTPScreen = "/register-verify-otp-screen",
      userControlScreen = "/user-control-screen",
      imageViewerScreen = "/image-viewer-screen",
      mailChangeScreen = "/mail-change-screen",
      settingScreen = "/setting-screen",
      updateUserScreen = "/update-user-screen",
      updatePostScreen = "/update-post-screen",
      updateCategoryScreen = "/update-category-screen",
      updateSubCategoryScreen = "/update-sub-category-screen",
      profileScreen = "/profile-screen",
      createPostScreen = "/create-post-screen",
      postDetail = "/post-detail",
      categories = "/categories",
      createCategories = "/createCategories",
      createSubCategories = "/createSubCategories",
      adminDashBoard = "/admin-dash-board",
      noti = "/notification-screen",
      singleChat = "/single-chat",
      messageCard = "/message-card",
      readPosts = "/read-post",
      readUsers = "/read-user",
      readCategories = "/read-category",
      readSubCategories = "/read-sub-category",
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
            BlocProvider(
              create: (_) => UserImageBloc(),
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
            child: const ShowCategories(),
          ),
          settings);
    case RouteNames.subCategories:
      return _protectedRoute(
          incomingRoute,
          ShowSubCategory(
            id: settings.arguments.toString(),
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
    case RouteNames.forgetPasswordSentOTPScreen:
      return _protectedRoute(
        incomingRoute,
        BlocProvider<UpdateUserInfoBloc>(
          create: (_) => UpdateUserInfoBloc(),
          child: const ForgetPasswordScreen(),
        ),
        settings,
      );
    case RouteNames.forgetPasswordVerifyOtpScreen:
      return _protectedRoute(
        incomingRoute,
        BlocProvider<UpdateUserInfoBloc>(
          create: (_) => UpdateUserInfoBloc(),
          child: OtpVerifyScreen(
            isRegister: false,
            email: settings.arguments.toString(),
          ),
        ),
        settings,
      );
    // case RouteNames.registerOTPScreen:
    //   return _protectedRoute(
    //     incomingRoute,
    //     BlocProvider<UpdateUserInfoBloc>(
    //       create: (_) => UpdateUserInfoBloc(),
    //       child: const ForgetPasswordScreen(
    //         isRegister: true,
    //       ),
    //     ),
    //     settings,
    //   );
    // case RouteNames.registerVerifyOTPScreen:
    //   return _protectedRoute(
    //     incomingRoute,
    //     BlocProvider<UpdateUserInfoBloc>(
    //       create: (_) => UpdateUserInfoBloc(),
    //       child: OtpVerifyScreen(
    //         isRegister: true,
    //         email: settings.arguments["email"],
    //       ),
    //     ),
    //     settings,
    //   );

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
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => CreateCubit()),
          ],
          child: const PostDetail(),
        ),
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
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => CreateCubit()),
            BlocProvider(create: (_) => UserImageBloc())
          ],
          child: const ProfileScreen(),
        ),
        settings,
      );
    case RouteNames.savedPostScreen:
      return _protectedRoute(
        incomingRoute,
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => CreateCubit()),
          ],
          child: const SavedPostScreen(),
        ),
        settings,
      );
    case RouteNames.updatePostScreen:
      return _protectedRoute(
        incomingRoute,
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => UpdateDataCubit()),
          ],
          child: const UpdatePostScreen(),
        ),
        settings,
      );
    case RouteNames.updateCategoryScreen:
      return _protectedRoute(
        incomingRoute,
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => UpdateDataCubit()),
          ],
          child: const UpdateCategoryScreen(),
        ),
        settings,
      );
    case RouteNames.updateSubCategoryScreen:
      return _protectedRoute(
        incomingRoute,
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => UpdateDataCubit()),
          ],
          child: const UpdateSubCategoryScreen(),
        ),
        settings,
      );
    case RouteNames.readPosts:
      return _protectedRoute(
        incomingRoute,
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => CreateCubit()),
          ],
          child: const ReadPost(),
        ),
        settings,
      );
    case RouteNames.readUsers:
      return _protectedRoute(
        incomingRoute,
        const ReadUser(),
        settings,
      );
    case RouteNames.readCategories:
      return _protectedRoute(
        incomingRoute,
        const ReadCategory(),
        settings,
      );
    case RouteNames.userControlScreen:
      return _protectedRoute(
        incomingRoute,
        const UserControl(),
        settings,
      );
    case RouteNames.imageViewerScreen:
      return _protectedRoute(
        incomingRoute,
        const ImageViewer(),
        settings,
      );

    case RouteNames.readSubCategories:
      return _protectedRoute(
        incomingRoute,
        ReadSubCategory(
          id: settings.arguments.toString(),
        ),
        settings,
      );

    case RouteNames.adminDashBoard:
      return _protectedRoute(
        incomingRoute,
        const AdminDashboard(),
        settings,
      );
    case RouteNames.aboutScreen:
      return _protectedRoute(
        incomingRoute,
        const AboutScreen(),
        settings,
      );
    case RouteNames.singleChat:
      return _protectedRoute(
        incomingRoute,
        MultiBlocProvider(
          providers: [
            BlocProvider<ChatBloc>(create: (_) => ChatBloc()),
          ],
          child: const SingleChat(),
        ),
        settings,
      );
    // case RouteNames.messageCard:
    //   return _protectedRoute(
    //     incomingRoute,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<ChatBloc>(create: (_) => ChatBloc()),
    //       ],
    //       child: const MessageCard(),
    //     ),
    //     settings,
    //   );

    case RouteNames.createPostScreen:
      final value = settings.arguments;
      if (value is! PostModel) {
        return _pageRoute(ErrorWidget("Post Model is not found!!"), settings);
      }
      return _protectedRoute(
        incomingRoute,
        MultiBlocProvider(
          providers: [
            BlocProvider<UpdateDataCubit>(create: (_) => UpdateDataCubit()),
            BlocProvider<CreateCubit>(create: (_) => CreateCubit()),
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
