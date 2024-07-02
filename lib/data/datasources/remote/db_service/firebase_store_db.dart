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
  void postParser(event) {
    for (var i in event.docs) {
      var model = PostModel.fromJson(i.data());
      if (!_posts.contains(model)) {
        _posts.add(model);
      }
    }
    _postStream.add(_posts);
  }

  Stream<List<PostModel>> get posts {
    Future.delayed(
      const Duration(milliseconds: 200),
      () => _db
          .collection("posts")
          // .where("userId", isNotEqualTo: _auth.currentUser!.uid)
          .orderBy(
            "createdAt",
            descending: true,
          )
          .snapshots()
          .listen(postParser),
    );

    return _postStream.stream;
  }

  final List<LikeModel> _likes = [];
  void likeParser(event) {
    for (var i in event.docs) {
      var model = LikeModel.fromJson(i.data());
      if (!_likes.contains(model)) {
        _likes.add(model);
      }
    }
    _likeStream.add(_likes);
  }

  Stream<List<LikeModel>> likes(String postId) {
    Future.delayed(
        const Duration(milliseconds: 200),
        () => _db
            .collection("likes")
            .where("post_id", isEqualTo: postId)
            // .orderBy(
            //   "created_at",
            //   descending: false,
            // )
            .snapshots()
            .listen(likeParser));
    return _likeStream.stream;
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

  final List<CommentModel> _comments = [];
  void commentsParser(event) {
    for (var i in event.docs) {
      var model = CommentModel.fromJson(i.data());
      if (!_comments.contains(model)) {
        _comments.add(model);
      }
    }
    _commentStream.add(_comments);
  }

  Stream<List<CommentModel>> comments(String postId) {
    Future.delayed(
      const Duration(milliseconds: 200),
      () => _db
          .collection("comments")
          .where("post_id", isEqualTo: postId)
          .orderBy(
            "created_at",
            descending: false,
          )
          .snapshots()
          .listen(commentsParser),
    );

    return _commentStream.stream;
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
  void notiParser(event) {
    for (var i in event.docs) {
      var model = NotificationModel.fromJson(i.data());
      if (!_notis.contains(model)) {
        _notis.add(model);
      }
    }
    _notiStream.add(_notis);
  }

  Stream<List<NotificationModel>> get notis {
    Future.delayed(
      const Duration(milliseconds: 200),
      () => _db.collection("notification").snapshots().listen(notiParser),
    );
    return _notiStream.stream;
  }
}
