import 'dart:async';
import 'dart:developer';

import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/models/category_model/category_model.dart';
import 'package:blog_app/data/models/comment_model/comment_model.dart';
import 'package:blog_app/data/models/like_model/like_model.dart';
import 'package:blog_app/data/models/main_category_model/main_cateory_model.dart';
import 'package:blog_app/data/models/notification_model/notification_model.dart';
import 'package:blog_app/data/models/post_Images_model/post_image_model.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/data/models/post_video_model/post_video_model.dart';
import 'package:blog_app/data/models/savedPost_model/save_post_model.dart';
import 'package:blog_app/data/models/sub_category_modle/sub_category_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseStoreDb {
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();
  final AuthService _auth = Injection<AuthService>();
  final StreamController<List<PostModel>> _postStream =
      StreamController<List<PostModel>>.broadcast();
  final StreamController<List<PostModel>> _myProfilePostStream =
      StreamController<List<PostModel>>.broadcast();
  final StreamController<List<PostModel>> _profilePostStream =
      StreamController<List<PostModel>>.broadcast();
  final StreamController<List<PostModel>> _singlePostStream =
      StreamController<List<PostModel>>.broadcast();
  final StreamController<List<CategoryModel>> _categoryStream =
      StreamController<List<CategoryModel>>.broadcast();
  final StreamController<List<MainCategoryModel>> _mainCategoryStream =
      StreamController<List<MainCategoryModel>>.broadcast();
  final StreamController<List<SubCategoryModel>> _subCategoryStream =
      StreamController<List<SubCategoryModel>>.broadcast();
  final StreamController<List<NotificationModel>> _notiStream =
      StreamController<List<NotificationModel>>.broadcast();
  final StreamController<List<NotificationModel>> _readNotiStream =
      StreamController<List<NotificationModel>>.broadcast();
  final StreamController<List<CommentModel>> _commentStream =
      StreamController<List<CommentModel>>.broadcast();
  final StreamController<List<UserModel>> _userStream =
      StreamController<List<UserModel>>.broadcast();
  final StreamController<List<UserModel>> _otherUserStream =
      StreamController<List<UserModel>>.broadcast();
  final StreamController<List<LikeModel>> _likeStream =
      StreamController<List<LikeModel>>.broadcast();
  final StreamController<List<SavePostModel>> _savePostStream =
      StreamController<List<SavePostModel>>.broadcast();
  final StreamController<List<SavePostModel>> _mySavePostStream =
      StreamController<List<SavePostModel>>.broadcast();
  final StreamController<List<PostImageModel>> _postImagesStream =
      StreamController<List<PostImageModel>>.broadcast();
  final StreamController<List<PostVideoModel>> _postVideoStream =
      StreamController<List<PostVideoModel>>.broadcast();

  Stream<QuerySnapshot<Map<String, dynamic>>> getUser(String userId) {
    Stream<QuerySnapshot<Map<String, dynamic>>> user =
        _db.collection("users").where("id", isEqualTo: userId).snapshots();
    return user;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> checkUser() {
    Stream<QuerySnapshot<Map<String, dynamic>>> docusSnapshot = _db
        .collection("users")
        .where("id", isEqualTo: _auth.currentUser!.uid)
        .snapshots();
    return docusSnapshot;
  }

  Future<void> createUser({
    required String id,
    required String name,
    required String email,
    required String profileUrl,
    required String coverUrl,
  }) async {
    var exitUser = false;
    final doc = FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.uid);
    String time = DateTime.now().millisecondsSinceEpoch.toString();

    final user = UserModel(
      id: id,
      name: name,
      email: email,
      profielUrl: profileUrl,
      coverUrl: coverUrl,
      isOnline: true,
      lastActive: time,
      postStatus: true,
      commentStatus: true,
      messageStatus: true,
      commentPermission: true,
      chatMessageToken: "",
    );

    var data = await FirebaseFirestore.instance.collection("users").get();
    var userData = data.docs;
    for (var element in userData) {
      var id = element["id"].toString();
      if (id == _auth.currentUser!.uid) {
        exitUser = true;
      }
    }

    if (!exitUser) {
      await doc.set(
        user.toJson(),
      );
    }

    log(exitUser.toString());
  }

  Future<void> checkUpdateMail(String email) async {
    var data = await FirebaseFirestore.instance.collection("users").get();
    var userData = data.docs;
    for (var element in userData) {
      var id = element["id"].toString();
      if (id == _auth.currentUser!.uid && element["email"] != email) {
        await _db.collection("users").doc(id).update({"email": email});
      }
    }
  }

  Future<bool> checkPostStatus() async {
    var isStatus = true;
    var data = await FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: _auth.currentUser!.uid)
        .get();
    var userData = data.docs;

    for (var element in userData) {
      isStatus = element["postStatus"];
    }
    return isStatus;
  }

  Future<bool> checkCommentStatus() async {
    var isStatus = true;
    var data = await FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: _auth.currentUser!.uid)
        .get();
    var userData = data.docs;

    for (var element in userData) {
      isStatus = element["commentStatus"];
    }
    return isStatus;
  }

  Future<bool> checkCommentPermission() async {
    var isStatus = true;
    var data = await FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: _auth.currentUser!.uid)
        .get();
    var userData = data.docs;

    for (var element in userData) {
      isStatus = element["commentPermission"];
    }
    return isStatus;
  }

  Future<bool> checkPostCommentStatus(String postID) async {
    var isStatus = true;
    var data = await FirebaseFirestore.instance
        .collection("posts")
        .where("id", isEqualTo: postID)
        .get();
    var postData = data.docs;

    for (var element in postData) {
      isStatus = element["commentStatus"];
    }
    return isStatus;
  }

  Future<bool> checkMessageStatus() async {
    var isStatus = true;
    var data = await FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: _auth.currentUser!.uid)
        .get();
    var userData = data.docs;

    for (var element in userData) {
      isStatus = element["messageStatus"];
    }
    return isStatus;
  }

  ///My PROFILE POSTS
  final List<PostModel> _myProfilePosts = [];
  void myProfilePostParser(QuerySnapshot event) {
    _myProfilePosts.clear();
    _myProfilePosts.addAll(event.docs.map((e) => PostModel.fromJson(e.data())));
    _myProfilePostStream.add(_myProfilePosts);
  }

  final Map<String, StreamSubscription> _myProfilePostsStream = {};
  void _myProfilePostStreamSetup(String id) {
    _myProfilePostsStream[id] = _db
        .collection("posts")
        .where("userId", isEqualTo: id)
        .orderBy(
          "createdAt",
          descending: true,
        )
        .snapshots()
        .listen((e) {
      return myProfilePostParser(e);
    });
  }

  Stream<List<PostModel>> myProfilePosts(String userId) {
    var stream = _myProfilePostsStream[userId];
    if (stream != null) {
      stream.cancel();
      _myProfilePostsStream.remove(userId);
    }
    _myProfilePostStreamSetup(userId);
    return _myProfilePostStream.stream;
  }

  ///OTHER PROFILE POSTS
  final List<PostModel> _profilePosts = [];
  void profilePostParser(QuerySnapshot event) {
    _profilePosts.clear();
    _profilePosts.addAll(event.docs.map((e) => PostModel.fromJson(e.data())));
    _profilePostStream.add(_profilePosts);
  }

  final Map<String, StreamSubscription> _profilePostsStream = {};
  void _profilePostStreamSetup(String id) {
    _profilePostsStream[id] = _db
        .collection("posts")
        .where("userId", isEqualTo: id)
        .where("post_type", isEqualTo: "public")
        .orderBy(
          "createdAt",
          descending: true,
        )
        .snapshots()
        .listen((e) {
      return profilePostParser(e);
    });
  }

  Stream<List<PostModel>> profilePosts(String userId) {
    var stream = _profilePostsStream[userId];
    if (stream != null) {
      stream.cancel();
      _profilePostsStream.remove(userId);
    }
    _profilePostStreamSetup(userId);
    return _profilePostStream.stream;
  }

  /// ALL POSTS
  final List<PostModel> _posts = [];
  void postParser(QuerySnapshot event) {
    _posts.clear();
    _posts.addAll(event.docs.map((e) => PostModel.fromJson(e.data())));
    _postStream.add(_posts);
  }

  Map<String, StreamSubscription> postsStream = {};
  void _postStreamSetup() {
    postsStream["data"] = _db
        .collection("posts")
        .where("post_type", isEqualTo: "public")
        .orderBy(
          "createdAt",
          descending: true,
        )
        .snapshots()
        .listen((e) {
      return postParser(e);
    });
  }

  Stream<List<PostModel>> get posts {
    var stream = postsStream["data"];
    if (stream != null) {
      stream.cancel();
      postsStream.remove("data");
    }
    _postStreamSetup();
    return _postStream.stream;
  }

  ///ALL USERS
  final List<UserModel> _users = [];
  void userParser(QuerySnapshot event) {
    _users.clear();
    _users.addAll(event.docs.map((e) => UserModel.fromJson(e.data())));
    _userStream.add(_users);
  }

  Map<String, StreamSubscription> usersStream = {};
  void _userStreamSetup() {
    usersStream["data"] = _db
        .collection("users")
        // .where("post_type", isEqualTo: "public")
        // .orderBy(
        //   "createdAt",
        //   descending: true,
        // )
        .snapshots()
        .listen((e) {
      return userParser(e);
    });
  }

  Stream<List<UserModel>> get users {
    var stream = usersStream["data"];
    if (stream != null) {
      stream.cancel();
      usersStream.remove("data");
    }
    _userStreamSetup();
    return _userStream.stream;
  }

  ///OTHER USERS
  final List<UserModel> _otherUsers = [];
  void otherUserParser(QuerySnapshot event) {
    _otherUsers.clear();
    _otherUsers.addAll(event.docs.map((e) => UserModel.fromJson(e.data())));
    _otherUserStream.add(_otherUsers);
  }

  Map<String, StreamSubscription> otherUsersStream = {};
  void _otherUserStreamSetup() {
    otherUsersStream["data"] = _db
        .collection("users")
        .where("id", isNotEqualTo: _auth.currentUser!.uid)
        // .orderBy(
        //   "createdAt",
        //   descending: true,
        // )
        .snapshots()
        .listen((e) {
      return otherUserParser(e);
    });
  }

  Stream<List<UserModel>> get otherUsers {
    var stream = otherUsersStream["data"];
    if (stream != null) {
      stream.cancel();
      otherUsersStream.remove("data");
    }
    _otherUserStreamSetup();
    return _otherUserStream.stream;
  }

  ///CATEGORIES
  final List<CategoryModel> _categories = [];
  void categoryParser(QuerySnapshot event) {
    _categories.clear();
    _categories.addAll(event.docs.map((e) => CategoryModel.fromJson(e.data())));
    _categoryStream.add(_categories);
  }

  Map<String, StreamSubscription> categoriesStream = {};
  void _categoryStreamSetup(String id) {
    categoriesStream[id] = _db
        .collection("categories")
        .where("mainCategory_id", isEqualTo: id)
        .snapshots()
        .listen((e) {
      return categoryParser(e);
    });
  }

  Stream<List<CategoryModel>> categories(String id) {
    var stream = categoriesStream[id];
    if (stream != null) {
      stream.cancel();
      categoriesStream.remove(id);
    }
    _categoryStreamSetup(id);
    return _categoryStream.stream;
  }

  /// MAIN CATEGORIES
  final List<MainCategoryModel> _mainCategories = [];
  void mainCategoryParser(QuerySnapshot event) {
    _mainCategories.clear();
    _mainCategories
        .addAll(event.docs.map((e) => MainCategoryModel.fromJson(e.data())));
    _mainCategoryStream.add(_mainCategories);
  }

  Map<String, StreamSubscription> mainCategoriesStream = {};
  void _mainCategoryStreamSetup() {
    mainCategoriesStream["data"] = _db
        .collection("mainCategories")
        // .where("userId", isNotEqualTo: _auth.currentUser!.uid)
        .snapshots()
        .listen((e) {
      return mainCategoryParser(e);
    });
  }

  Stream<List<MainCategoryModel>> get mainCategories {
    var stream = mainCategoriesStream["data"];
    if (stream != null) {
      stream.cancel();
      mainCategoriesStream.remove("data");
    }
    _mainCategoryStreamSetup();
    return _mainCategoryStream.stream;
  }

  ///SUBCATEGORIES
  final List<SubCategoryModel> _subCategories = [];
  void subCategoryParser(QuerySnapshot event) {
    _subCategories.clear();
    _subCategories
        .addAll(event.docs.map((e) => SubCategoryModel.fromJson(e.data())));
    _subCategoryStream.add(_subCategories);
  }

  final Map<String, StreamSubscription> _subCategoriesStram = {};
  void _subCategoryStreamSetup(String id) {
    _subCategoriesStram[id] = _db
        .collection("subCategories")
        .where("category_id", isEqualTo: id)
        .snapshots()
        .listen((e) {
      return subCategoryParser(e);
    });
  }

  Stream<List<SubCategoryModel>> subcategories(String id) {
    var stream = _subCategoriesStram[id];
    if (stream != null) {
      stream.cancel();
      _subCategoriesStram.remove(id);
    }
    _subCategoryStreamSetup(id);
    return _subCategoryStream.stream;
  }

  ///SINGLE POST
  final List<PostModel> _singlePosts = [];
  void singlePostParser(QuerySnapshot event) {
    _singlePosts.clear();
    _singlePosts.addAll(event.docs.map((e) => PostModel.fromJson(e.data())));
    _singlePostStream.add(_singlePosts);
  }

  final Map<String, StreamSubscription> _singlePostsStream = {};
  void _singlePostStreamSetup(String id) {
    _singlePostsStream[id] = _db
        .collection("posts")
        .where("id", isEqualTo: id)
        .snapshots()
        .listen((e) {
      return singlePostParser(e);
    });
  }

  Stream<List<PostModel>> singlePosts(String id) {
    var stream = _singlePostsStream[id];
    if (stream != null) {
      stream.cancel();
      _singlePostsStream.remove(id);
    }
    _singlePostStreamSetup(id);

    return _singlePostStream.stream;
  }

  ///READ NOTIFICATION
  final List<NotificationModel> _readNotis = [];
  void readNotiParser(QuerySnapshot event) {
    _readNotis.clear();
    _readNotis
        .addAll(event.docs.map((e) => NotificationModel.fromJson(e.data())));
    _readNotiStream.add(_readNotis);
  }

  Map<String, StreamSubscription> readNotisStream = {};
  void readNotiStreamSetup() {
    readNotisStream["data"] = _db
        .collection("notifications")
        .where("read", isEqualTo: false)
        .where("user_id", isEqualTo: _auth.currentUser!.uid)
        .snapshots()
        .listen((e) {
      return readNotiParser(e);
    });
  }

  Stream<List<NotificationModel>> get readNotis {
    var stream = readNotisStream["data"];
    if (stream != null) {
      stream.cancel();
      readNotisStream.remove("data");
    }
    readNotiStreamSetup();
    return _readNotiStream.stream;
  }

  ///NOTIFICATION
  final List<NotificationModel> _notis = [];
  void notiParser(QuerySnapshot event) {
    _notis.clear();
    _notis.addAll(event.docs.map((e) => NotificationModel.fromJson(e.data())));
    _notiStream.add(_notis);
  }

  Map<String, StreamSubscription> notisStream = {};
  void notiStreamSetup() {
    notisStream["data"] = _db
        .collection("notifications")
        .where("user_id", isEqualTo: _auth.currentUser!.uid)
        .snapshots()
        .listen((e) {
      return notiParser(e);
    });
  }

  Stream<List<NotificationModel>> get notis {
    var stream = notisStream["data"];
    if (stream != null) {
      stream.cancel();
      notisStream.remove("data");
    }
    notiStreamSetup();
    return _notiStream.stream;
  }

  ///LIKE
  final List<LikeModel> _likes = [];
  void likeParser(QuerySnapshot event) {
    // for (var i in event.docs) {
    //   var model = LikeModel.fromJson(i.data());
    //   if (!_likes.contains(model)) {
    //     _likes.add(model);
    //   }
    // }
    _likes.clear();

    _likes.addAll(event.docs.map((e) => LikeModel.fromJson(e.data())));
    _likeStream.add(_likes);
  }

  final Map<String, StreamSubscription> _likesStream = {};
  void _likeStreamSetup(String postId) {
    _likesStream[postId] = _db
        .collection("likes")
        .where("post_id", isEqualTo: postId)
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      return likeParser(event);
    });
  }

  Stream<List<LikeModel>> likes(String postId) {
    var stream = _likesStream[postId];
    if (stream != null) {
      stream.cancel();
      _likesStream.remove(postId);
    }
    _likeStreamSetup(postId);
    return _likeStream.stream;
  }

  ///SAVEDPOSTS
  final List<SavePostModel> _savedPosts = [];
  void savePostParser(QuerySnapshot event) {
    _savedPosts.clear();

    _savedPosts.addAll(event.docs.map((e) => SavePostModel.fromJson(e.data())));
    _savePostStream.add(_savedPosts);
  }

  final Map<String, StreamSubscription> _savePostsStreams = {};
  void _savePostsStreamsSetup(String postId) {
    _likesStream[postId] = _db
        .collection("savePosts")
        .where("post_id", isEqualTo: postId)
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      return savePostParser(event);
    });
  }

  Stream<List<SavePostModel>> savedPosts(String postId) {
    var stream = _savePostsStreams[postId];
    if (stream != null) {
      stream.cancel();
      _savePostsStreams.remove(postId);
    }
    _savePostsStreamsSetup(postId);
    return _savePostStream.stream;
  }

  ///MY SAVED POSTS
  final List<SavePostModel> _mySavedPosts = [];
  void mySavePostParser(QuerySnapshot event) {
    _mySavedPosts.clear();

    _mySavedPosts
        .addAll(event.docs.map((e) => SavePostModel.fromJson(e.data())));
    _mySavePostStream.add(_mySavedPosts);
  }

  final Map<String, StreamSubscription> _mySavePostsStreams = {};
  void _mySavePostsStreamsSetup(String userId) {
    _mySavePostsStreams[userId] = _db
        .collection("savePosts")
        .where("user_id", isEqualTo: userId)
        .orderBy("created_at", descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      return mySavePostParser(event);
    });
  }

  Stream<List<SavePostModel>> mySavedPosts(String userId) {
    var stream = _mySavePostsStreams[userId];
    if (stream != null) {
      stream.cancel();
      _mySavePostsStreams.remove(userId);
    }
    _mySavePostsStreamsSetup(userId);
    return _mySavePostStream.stream;
  }

  ///POSTIMAGES
  final List<PostImageModel> _postImages = [];
  void postImagesParser(QuerySnapshot event) {
    // for (var i in event.docs) {
    //   var model = LikeModel.fromJson(i.data());
    //   if (!_likes.contains(model)) {
    //     _likes.add(model);
    //   }
    // }
    _postImages.clear();

    _postImages
        .addAll(event.docs.map((e) => PostImageModel.fromJson(e.data())));
    _postImagesStream.add(_postImages);
  }

  final Map<String, StreamSubscription> _postImagesStreams = {};
  void _postImagesStreamsSetUp(String postId) {
    _postImagesStreams[postId] = _db
        .collection("postImages")
        .where("post_id", isEqualTo: postId)
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      return postImagesParser(event);
    });
  }

  Stream<List<PostImageModel>> postImages(String postId) {
    var stream = _postImagesStreams[postId];
    if (stream != null) {
      stream.cancel();
      _postImagesStreams.remove(postId);
    }
    _postImagesStreamsSetUp(postId);
    return _postImagesStream.stream;
  }

  ///POST VIDEO
  final List<PostVideoModel> _postVideos = [];
  void postVideosParser(QuerySnapshot event) {
    // for (var i in event.docs) {
    //   var model = LikeModel.fromJson(i.data());
    //   if (!_likes.contains(model)) {
    //     _likes.add(model);
    //   }
    // }
    _postVideos.clear();

    _postVideos
        .addAll(event.docs.map((e) => PostVideoModel.fromJson(e.data())));
    _postVideoStream.add(_postVideos);
  }

  final Map<String, StreamSubscription> _postVideosStreams = {};
  void _postVideosStreamsSetUp(String postId) {
    _postVideosStreams[postId] = _db
        .collection("postVideos")
        .where("post_id", isEqualTo: postId)
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      return postVideosParser(event);
    });
  }

  Stream<List<PostVideoModel>> postVideos(String postId) {
    var stream = _postVideosStreams[postId];
    if (stream != null) {
      stream.cancel();
      _postVideosStreams.remove(postId);
    }
    _postVideosStreamsSetUp(postId);
    return _postVideoStream.stream;
  }

  ///COMMENTS
  final List<CommentModel> _comments = [];
  void commentsParser(QuerySnapshot event) {
    // for (var i in event.docs) {
    //   var model = CommentModel.fromJson(i.data());
    //   if (!_comments.contains(model)) {
    //     _comments.add(model);
    //   }
    // }
    _comments.clear();

    _comments.addAll(event.docs.map((e) => CommentModel.fromJson(e.data())));
    _commentStream.add(_comments);
  }

  // // Stream<List<CommentModel>> comments(String postId) {
  // //   Future.delayed(
  // //     const Duration(milliseconds: 200),
  // //     () => _db
  // //         .collection("comments")
  // //         .where("post_id", isEqualTo: postId)
  // //         .orderBy(
  // //           "created_at",
  // //           descending: false,
  // //         )
  // //         .snapshots(includeMetadataChanges: true)
  // //         .listen(commentsParser),
  // //   );

  // //   return _commentStream.stream;
  // // }

  final Map<String, StreamSubscription> _cmtStream = {};
  void _commentStreamSetup(String postId) {
    _cmtStream[postId] = _db
        .collection("comments")
        .where("post_id", isEqualTo: postId)
        .orderBy(
          "created_at",
          descending: false,
        )
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      return commentsParser(event);
    });
  }

  Stream<List<CommentModel>> comments(String postId) {
    var stream = _cmtStream[postId];
    if (stream != null) {
      stream.cancel();
      _cmtStream.remove(postId);
    }
    _commentStreamSetup(postId);
    return _commentStream.stream;
  }

//////////////////////////////////////////////////////////////////////////////////////////
  // final Map<String, List<CommentModel>> _commentStore = {};
  // final Map<String, StreamSubscription> _cmtStream = {};
  // Stream<List<CommentModel>> comments(String postId) {
  //   if (_cmtStream[postId] == null) {
  //     _cmtStream[postId] = _db
  //         .collection("comments")
  //         .where("post_id", isEqualTo: postId)
  //         .orderBy(
  //           "created_at",
  //           descending: false,
  //         )
  //         .snapshots(includeMetadataChanges: true)
  //         .listen((e) {
  //       _commentStore[postId] = e.docs
  //           .map((element) => CommentModel.fromJson(element.data()))
  //           .toList();
  //     });
  //   }

  //   Future.delayed(
  //     const Duration(milliseconds: 500),
  //     () => _commentStream.sink.add(_commentStore[postId] ?? []),
  //   );
  //   return _commentStream.stream;
  // }

  dispose() {
    _postStream.close();
    _myProfilePostStream.close();
    _singlePostStream.close();
    _categoryStream.close();
    _subCategoryStream.close();
    _commentStream.close();
    _likeStream.close();
  }
}
