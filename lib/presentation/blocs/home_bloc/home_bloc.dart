part of 'home_import.dart';

class HomeBloc extends Bloc<HomeBaseEvent, HomeBaseState> {
  final AuthService _auth = Injection<AuthService>();
  // final FirebaseFirestore _db = Injection<FirebaseFirestore>();
  StreamSubscription? _streamSubscription;
  // _otherUserPostSubscription,
  // _currentUserSubscription;
  // final StreamController<List<PostModel>> _postStream =
  //     StreamController<List<PostModel>>.broadcast();
  // final StreamController<List<CategoryModel>> _categoryStream =
  //     StreamController<List<CategoryModel>>.broadcast();
  // final StreamController<List<UserModel>> _userStream =
  //     StreamController<List<UserModel>>.broadcast();
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  // final TextEditingController searchText = TextEditingController();

  // final List<PostModel> _posts = [];
  // void postParser(event) {
  //   for (var i in event.docs) {
  //     var model = PostModel.fromJson(i.data());
  //     if (!_posts.contains(model)) {
  //       _posts.add(model);
  //     }
  //   }
  //   _postStream.add(_posts);
  // }

  // Stream<List<PostModel>> get posts {
  //   Future.delayed(
  //     const Duration(milliseconds: 200),
  //     () => _db
  //         .collection("posts")
  //         // .where("userId", isNotEqualTo: _auth.currentUser!.uid)
  //         .snapshots()
  //         .listen(postParser),
  //   );

  //   return _postStream.stream;
  // }

  // final List<CategoryModel> _categories = [];
  // void categoryParser(event) {
  //   for (var i in event.docs) {
  //     var model = CategoryModel.fromJson(i.data());
  //     if (!_categories.contains(model)) {
  //       _categories.add(model);
  //     }
  //   }
  //   _categoryStream.add(_categories);
  // }

  // Stream<List<CategoryModel>> get categories {
  //   Future.delayed(
  //     const Duration(milliseconds: 200),
  //     () => _db.collection("categories").snapshots().listen(categoryParser),
  //   );

  //   return _categoryStream.stream;
  // }

  // final List<UserModel> _userData = [];
  // void userParser(event) {
  //   for (var i in event.docs) {
  //     var model = UserModel.fromJson(i.data());
  //     _userData.add(model);
  //   }
  //   _userStream.add(_userData);
  // }

  // Stream<List<UserModel>> userData(String id) {
  //   Future.delayed(
  //     const Duration(milliseconds: 200),
  //     () => _db
  //         .collection("users")
  //         .where("id", isEqualTo: id)
  //         .snapshots()
  //         .listen(userParser),
  //   );

  //   return _userStream.stream;
  // }

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
    // _otherUserPostSubscription = _db
    //     .collection("posts")
    //     .where("userId", isNotEqualTo: _auth.currentUser!.uid)
    //     .snapshots()
    //     .listen(postParser);
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

  @override
  Future<void> close() {
    // searchText.dispose();
    drawerKey.currentState?.dispose();
    _streamSubscription?.cancel();
    // _otherUserPostSubscription?.cancel();
    // _currentUserSubscription?.cancel();
    return super.close();
  }
}
