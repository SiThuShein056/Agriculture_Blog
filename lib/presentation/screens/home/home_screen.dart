part of 'home_import.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    DatabaseUpdateService().updateUserData(
        id: Injection<AuthService>().currentUser!.uid,
        isOnline: true,
        lastActive: DateTime.now().millisecondsSinceEpoch.toString());

    SystemChannels.lifecycle.setMessageHandler((message) {
      log("Message : $message");
      if (message.toString().contains("pause")) {
        DatabaseUpdateService().updateUserData(
            id: Injection<AuthService>().currentUser!.uid,
            isOnline: false,
            lastActive: DateTime.now().millisecondsSinceEpoch.toString());
      }
      if (message.toString().contains("resume")) {
        DatabaseUpdateService().updateUserData(
            id: Injection<AuthService>().currentUser!.uid,
            isOnline: true,
            lastActive: DateTime.now().millisecondsSinceEpoch.toString());
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    final bottomNav = context.read<NavigationBloc>();
    final postCreateBloc = context.read<CreateCubit>();

    return BlocListener<HomeBloc, HomeBaseState>(
      listener: (context, state) {
        if (state is HomeUserSignOutState) {
          log("User SignOut State");
          StarlightUtils.pushReplacementNamed(RouteNames.splash);
        } else if (state is HomeUserChangeState) {
          log("UserChange State");
        }
      },
      child: Scaffold(
        key: bloc.drawerKey,
        drawer: DrawerWidget(bloc: bloc),
        bottomNavigationBar: BottomNavWidget(bottomNav: bottomNav),
        body: BlocBuilder<NavigationBloc, NavigationState>(builder: (_, state) {
          return [
            ShowPost(
              onTap: () {
                bloc.drawerKey.currentState?.openDrawer();
              },
              createBloc: postCreateBloc,
            ),
            const CreatePost(),
            const ChatHome(),
            const ProfileScreen(),
          ][state.i];
        }),
      ),
    );
  }
}
