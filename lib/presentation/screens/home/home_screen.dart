part of 'home_import.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              bloc: bloc,
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
