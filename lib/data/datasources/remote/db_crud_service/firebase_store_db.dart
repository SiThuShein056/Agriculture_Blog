import 'dart:async';
import 'dart:developer';

import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/models/category_model/category_model.dart';
import 'package:blog_app/data/models/comment_model/comment_model.dart';
import 'package:blog_app/data/models/like_model/like_model.dart';
import 'package:blog_app/data/models/notification_model/notification_model.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/data/models/sub_category_modle/sub_category_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseStoreDb {
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();
  final AuthService _auth = Injection<AuthService>();
  final StreamController<List<PostModel>> _postStream =
      StreamController<List<PostModel>>.broadcast();
  final StreamController<List<PostModel>> _profilePostStream =
      StreamController<List<PostModel>>.broadcast();
  final StreamController<List<PostModel>> _singlePostStream =
      StreamController<List<PostModel>>.broadcast();
  final StreamController<List<CategoryModel>> _categoryStream =
      StreamController<List<CategoryModel>>.broadcast();
  final StreamController<List<SubCategoryModel>> _subCategoryStream =
      StreamController<List<SubCategoryModel>>.broadcast();
  final StreamController<List<NotificationModel>> _notiStream =
      StreamController<List<NotificationModel>>.broadcast();
  final StreamController<List<CommentModel>> _commentStream =
      StreamController<List<CommentModel>>.broadcast();
  final StreamController<List<UserModel>> _userStream =
      StreamController<List<UserModel>>.broadcast();
  final StreamController<List<LikeModel>> _likeStream =
      StreamController<List<LikeModel>>.broadcast();

  ///
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

    final user = UserModel(
      id: id,
      name: name,
      email: email,
      profielUrl: profileUrl,
      coverUrl: coverUrl,
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

  ///PROFILE POSTS
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

  ///USERS
  final List<UserModel> _users = [];
  void userParser(QuerySnapshot event) {
    _users.clear();
    _users.addAll(event.docs.map((e) => UserModel.fromJson(e.data())));
    _userStream.add(_users);
  }

  Map<String, StreamSubscription> usersStream = {};
  void _userStreamSetup() {
    postsStream["data"] = _db
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

  ///CATEGORIES
  final List<CategoryModel> _categories = [];
  void categoryParser(QuerySnapshot event) {
    _categories.clear();
    _categories.addAll(event.docs.map((e) => CategoryModel.fromJson(e.data())));
    _categoryStream.add(_categories);
  }

  Map<String, StreamSubscription> categoriesStream = {};
  void _categoryStreamSetup() {
    categoriesStream["data"] = _db
        .collection("categories")
        // .where("userId", isNotEqualTo: _auth.currentUser!.uid)
        .snapshots()
        .listen((e) {
      return categoryParser(e);
    });
  }

  Stream<List<CategoryModel>> get categories {
    var stream = categoriesStream["data"];
    if (stream != null) {
      stream.cancel();
      categoriesStream.remove("data");
    }
    _categoryStreamSetup();
    return _categoryStream.stream;
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

  ///NOTIFICATION
  final List<NotificationModel> _notis = [];
  void notiParser(QuerySnapshot event) {
    _notis.clear();
    _notis.addAll(event.docs.map((e) => NotificationModel.fromJson(e.data())));
    _notiStream.add(_notis);
  }

  Map<String, StreamSubscription> notisStream = {};
  void notiStreamSetup() {
    notisStream["data"] =
        _db.collection("notification").snapshots().listen((e) {
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
      _cmtStream.remove(postId);
    }
    _likeStreamSetup(postId);
    return _likeStream.stream;
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
    _profilePostStream.close();
    _singlePostStream.close();
    _categoryStream.close();
    _subCategoryStream.close();
    _commentStream.close();
    _likeStream.close();
  }
}
