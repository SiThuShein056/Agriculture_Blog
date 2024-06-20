part of 'home_import.dart';

class HomeBloc extends Bloc<HomeBaseEvent, HomeBaseState> {
  final AuthService _auth = Injection<AuthService>();
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();
  StreamSubscription? _streamSubscription,
      _otherUserPostSubscription,
      _currentUserSubscription;
  final StreamController<List<PostModel>> postStream =
      StreamController<List<PostModel>>.broadcast();
  final List<PostModel> _posts = [];
  void postParser(event) {
    for (var i in event.docs) {
      var model = PostModel.fromJson(i.data());
      if (!_posts.contains(model)) {
        _posts.add(model);
      }
    }
    postStream.add(_posts);
  }

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
    _otherUserPostSubscription = _db
        .collection("posts")
        .where("userId", isNotEqualTo: _auth.currentUser!.uid)
        .snapshots()
        .listen(postParser);
    // _currentUserSubscription = _db
    //     .collection("posts")
    //     .where("userId", isEqualTo: _auth.currentUser!.uid)
    //     .snapshots()
    //     .listen(postParser);
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
  Future<void> close() {
    drawerKey.currentState?.dispose();
    _streamSubscription?.cancel();
    _otherUserPostSubscription?.cancel();
    _currentUserSubscription?.cancel();
    return super.close();
  }
}
