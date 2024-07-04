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
  final StreamController<List<PostModel>> _myPostStream =
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

  Future<void> updateUserData(
      {required String id,
      String? name,
      String? email,
      String? profileUrl}) async {
    Map<String, dynamic> payload = {};
    if (name != null) payload["name"] = name;
    if (email != null) payload["email"] = email;
    if (profileUrl != null) payload["profileUrl"] = profileUrl;

    await _db.collection("users").doc(id).update(payload);
  }

  Future<void> createUser({
    required String id,
    required String name,
    required String email,
    required String profileUrl,
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

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMyPosts() {
    Stream<QuerySnapshot<Map<String, dynamic>>> docusSnapshot = _db
        .collection("posts")
        .where("user_id", isEqualTo: _auth.currentUser!.uid)
        .snapshots();
    return docusSnapshot;
  }

  final List<PostModel> _myPosts = [];
  void myPostParser(event) {
    for (var i in event.docs) {
      var model = PostModel.fromJson(i.data());
      if (!_myPosts.contains(model)) {
        _myPosts.add(model);
      }
    }
    _myPostStream.add(_myPosts);
  }

  Stream<List<PostModel>> get myPosts {
    Future.delayed(
      const Duration(milliseconds: 200),
      () => _db
          .collection("posts")
          .where("userId", isEqualTo: _auth.currentUser!.uid)
          .orderBy(
            "createdAt",
            descending: true,
          )
          .snapshots()
          .listen(myPostParser),
    );

    return _myPostStream.stream;
  }

  final List<PostModel> _posts = [];
  void postParser(QuerySnapshot event) {
    // for (var i in event.docs) {
    //   var model = PostModel.fromJson(i.data());
    //   if (!_posts.contains(model)) {
    //     _posts.add(model);
    //   }
    // }
    _posts.clear();
    _posts.addAll(event.docs.map((e) => PostModel.fromJson(e.data())));
    _postStream.add(_posts);
  }

  Map<String, StreamSubscription> postsStream = {};
  void _postStreamSetup() {
    postsStream["data"] = _db
        .collection("posts")
        // .where("userId", isNotEqualTo: _auth.currentUser!.uid)
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
    // Future.delayed(
    //   const Duration(milliseconds: 200),
    //   () => _db
    //       .collection("posts")
    //       // .where("userId", isNotEqualTo: _auth.currentUser!.uid)
    //       .orderBy(
    //         "createdAt",
    //         descending: true,
    //       )
    //       .snapshots()
    //       .listen(postParser),
    // );

    var stream = postsStream["data"];
    if (stream != null) {
      stream.cancel();
      postsStream.remove("data");
    }
    _postStreamSetup();
    return _postStream.stream;
  }

  final List<CategoryModel> _categories = [];
  void categoryParser(event) {
    for (var i in event.docs) {
      var model = CategoryModel.fromJson(i.data());
      if (!_categories.contains(model)) {
        _categories.add(model);
      }
    }
    _categoryStream.add(_categories);
  }

  Stream<List<CategoryModel>> get categories {
    Future.delayed(
      const Duration(milliseconds: 200),
      () => _db
          .collection("categories")
          // .where("userId", isNotEqualTo: _auth.currentUser!.uid)
          .snapshots()
          .listen(categoryParser),
    );

    return _categoryStream.stream;
  }

  final List<SubCategoryModel> _subCategories = [];
  void subCategoryParser(event) {
    for (var i in event.docs) {
      var model = SubCategoryModel.fromJson(i.data());
      if (!_subCategories.contains(model)) {
        _subCategories.add(model);
      }
    }
    _subCategoryStream.add(_subCategories);
  }

  Stream<List<SubCategoryModel>> subcategories(String id) {
    Future.delayed(
      const Duration(milliseconds: 200),
      () => _db
          .collection("subCategories")
          .where("category_id", isEqualTo: id)
          .snapshots()
          .listen(subCategoryParser),
    );

    return _subCategoryStream.stream;
  }

  final List<PostModel> _singlePosts = [];
  void singlePostParser(event) {
    for (var i in event.docs) {
      var model = PostModel.fromJson(i.data());
      if (!_singlePosts.contains(model)) {
        _singlePosts.add(model);
      }
    }
    _singlePostStream.add(_singlePosts);
  }

  Stream<List<PostModel>> singlePosts(String id) {
    Future.delayed(
      const Duration(milliseconds: 200),
      () => _db
          .collection("posts")
          .where("id", isEqualTo: id)
          .snapshots()
          .listen(singlePostParser),
    );

    return _singlePostStream.stream;
  }

  final List<NotificationModel> _notis = [];
  void notiParser(QuerySnapshot event) {
    // for (var i in event.docs) {
    //   var model = NotificationModel.fromJson(i.data());
    //   if (!_notis.contains(model)) {
    //     _notis.add(model);
    //   }
    // }
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
    // Future.delayed(
    //   const Duration(milliseconds: 200),
    //   () => _db.collection("notification").snapshots().listen(notiParser),
    // );
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
  // Stream<List<LikeModel>> likes(String postId) {
  //   Future.delayed(
  //       const Duration(milliseconds: 200),
  //       () => _db
  //           .collection("likes")
  //           .where("post_id", isEqualTo: postId)
  //           // .orderBy(
  //           //   "created_at",
  //           //   descending: false,
  //           // )
  //           .snapshots()
  //           .listen(likeParser));
  //   return _likeStream.stream;
  // }

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
    _myPostStream.close();
    _singlePostStream.close();
    _categoryStream.close();
    _subCategoryStream.close();
    _commentStream.close();
    _likeStream.close();
  }
}
