part of 'home_import.dart';

class HomeBloc extends Bloc<HomeBaseEvent, HomeBaseState> {
  final AuthService _auth = Injection<AuthService>();
  StreamSubscription? _streamSubscription;

  HomeBloc(super.initialState) {
    _streamSubscription = _auth.authState().listen(
      (user) {
        if (user == null) {
          add(const HomeUserSignOutEvent());
          return;
        } else {
          add(HomeUserChangeEvent(user));
          return;
        }
      },
    );
    on<HomeUserChangeEvent>((event, emit) {
      return emit(HomeUserChangeState(event.user));
    });

    on<HomeUserSignOutEvent>((event, emit) async {
      await _auth.signOut();

      return emit(const HomeUserSignOutState());
    });
  }
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  @override
  Future<void> close() async {
    drawerKey.currentState?.dispose();
    await _streamSubscription?.cancel();
    return super.close();
  }
}
