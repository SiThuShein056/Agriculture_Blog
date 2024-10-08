import 'dart:developer';

import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/db_update_service.dart/db_create_service.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/db_update_service.dart/db_delete_service.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/notification_service/notification_service.dart';
import 'package:blog_app/data/models/category_model/category_model.dart';
import 'package:blog_app/data/models/comment_model/comment_model.dart';
import 'package:blog_app/data/models/like_model/like_model.dart';
import 'package:blog_app/data/models/main_category_model/main_cateory_model.dart';
import 'package:blog_app/data/models/savedPost_model/save_post_model.dart';
import 'package:blog_app/data/models/sub_category_modle/sub_category_model.dart';
import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:starlight_utils/starlight_utils.dart';

import 'post_create_state.dart';

class CreateCubit extends Cubit<CreateState> {
  CreateCubit() : super(const CreateInitialState());

  final FirebaseFirestore _db = Injection<FirebaseFirestore>();
  final AuthService auth = Injection<AuthService>();
  final DatabaseDeleteService deleteService =
      Injection<DatabaseDeleteService>();
  final TextEditingController titleController = TextEditingController(),
      categoryController = TextEditingController(),
      subCategoryController = TextEditingController(),
      mainCategoryController = TextEditingController(),
      commentController = TextEditingController(),
      phoneController = TextEditingController(),
      privacyController = TextEditingController(),
      descriptionController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode(),
      descriptionFocusNode = FocusNode();
  List<String> imageUrl = [];
  List<String> videoUrl = [];
  ValueNotifier<int> readCounts = ValueNotifier(0);
  ValueNotifier<int> notiCounts = ValueNotifier(0);
  ValueNotifier<String> privacy = ValueNotifier("select");

  GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> ediable = ValueNotifier(false);
  final ValueNotifier<bool> commentStatus = ValueNotifier(true);
  void toggle() {
    commentStatus.value = !commentStatus.value;
  }

  Future<void> createPost() async {
    if (state is CreateLoadingState ||
        formKey?.currentState?.validate() != true ||
        privacy.value == "select") return;

    emit(const CreateLoadingState());
    try {
      // final doc = _db.collection("posts").doc();
      // final notiDoc = _db.collection("notification").doc();

      // final post = PostModel(
      //   id: doc.id,
      //   userId: auth.currentUser!.uid,
      //   createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
      //   category: categoryController.text,
      //   phone: phoneController.text,
      //   privacy: privacy.value,
      //   description: descriptionController.text,
      //   commentStatus: commentStatus.value,
      // );
      // await doc
      //     .set(
      //   post.toJson(),
      // )
      //     .then((v) {
      //   if (privacy.value == "public") {
      //     NotificationService()
      //         .sentNewPostNotification(categoryController.text);
      //   }
      // });

      // if (imageUrl != []) {
      //   log("For In  ${imageUrl.length.toString()}");
      //   for (var element in imageUrl) {
      //     final postImageDoc = _db.collection("postImages").doc();

      //     final postImg = PostImageModel(
      //       id: postImageDoc.id,
      //       postId: doc.id,
      //       userId: auth.currentUser!.uid,
      //       createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
      //       imageUrl: element,
      //     );
      //     await postImageDoc.set(
      //       postImg.toJson(),
      //     );
      //   }
      // }
      // if (videoUrl != []) {
      //   log("For VideoUrl In  ${videoUrl.length.toString()}");
      //   for (var element in videoUrl) {
      //     final postVideoDoc = _db.collection("postVideos").doc();

      //     final postVideo = PostVideoModel(
      //       id: postVideoDoc.id,
      //       postId: doc.id,
      //       userId: auth.currentUser!.uid,
      //       createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
      //       videoUrl: element,
      //     );
      //     await postVideoDoc.set(
      //       postVideo.toJson(),
      //     );
      //   }
      // }
      // if (privacy.value == "public") {
      //   DatabaseCreateService().createNotifications(doc.id);
      // }

      await DatabaseCreateService().createPost(
          imageUrl,
          videoUrl,
          categoryController.text,
          phoneController.text,
          privacy.value,
          descriptionController.text,
          commentStatus.value);
      categoryController.text = "";
      descriptionController.text = "";
      phoneController.text = "";
      imageUrl.clear();
      videoUrl.clear();

      emit(const CreateSuccessState());
    } on FirebaseException catch (e) {
      emit(CreateErrorState(e.code));
    } catch (e) {
      emit(CreateErrorState(e.toString()));
    }
  }

  Future<void> pickPostPhotos() async {
    if (state is CreateLoadingState) return;
    emit(const CreateLoadingState());
    imageUrl.clear();
    final List<XFile> image = await Injection<ImagePicker>().pickMultiImage();

    for (var element in image) {
      final point = Injection<FirebaseStorage>().ref(
          "postImages/${auth.currentUser?.uid}/${DateTime.now().toString().replaceAll(" ", "")}/${element.name.split(".").last}");
      final uploaded = await point.putFile(element.path.file);
      //TODO

      var img = await Injection<FirebaseStorage>()
          .ref(uploaded.ref.fullPath)
          .getDownloadURL();

      imageUrl.add(img);
    }
    log(imageUrl.length.toString());
    emit(CreateSuccessState(imageUrl: imageUrl, videoUrl: videoUrl));
    return;
  }

  Future<void> pickPostVideo() async {
    if (state is CreateLoadingState) return;
    emit(const CreateLoadingState());
    final XFile? video =
        await Injection<ImagePicker>().pickVideo(source: ImageSource.gallery);

    if (video != null) {
      final point = Injection<FirebaseStorage>().ref(
          "postVideos/${auth.currentUser?.uid}/${DateTime.now().toString().replaceAll(" ", "")}/${video.name.split(".").last}");
      final uploaded = await point.putFile(video.path.file);
      //TODO

      var v = await Injection<FirebaseStorage>()
          .ref(uploaded.ref.fullPath)
          .getDownloadURL();

      videoUrl.add(v);
    }
    log("Video URL${videoUrl.length}");
    emit(CreateSuccessState(imageUrl: imageUrl, videoUrl: videoUrl));
    return;
  }

  Future<void> createCategory(String id) async {
    if (state is CreateLoadingState ||
        formKey?.currentState?.validate() != true) return;
    emit(const CreateLoadingState());
    try {
      final doc = _db.collection("categories").doc();

      final post = CategoryModel(
        id: doc.id,
        mainCategoryID: id,
        name: categoryController.text,
      );
      await doc.set(
        post.toJson(),
      );
      emit(const CreateSuccessState());
    } on FirebaseException catch (e) {
      emit(CreateErrorState(e.code));
    } catch (e) {
      emit(CreateErrorState(e.toString()));
    }
  }

  Future<void> createMainCategory() async {
    if (state is CreateLoadingState ||
        formKey?.currentState?.validate() != true) return;
    emit(const CreateLoadingState());
    try {
      final doc = _db.collection("mainCategories").doc();

      final post = MainCategoryModel(
        id: doc.id,
        name: mainCategoryController.text,
      );
      await doc.set(
        post.toJson(),
      );
      emit(const CreateSuccessState());
    } on FirebaseException catch (e) {
      emit(CreateErrorState(e.code));
    } catch (e) {
      emit(CreateErrorState(e.toString()));
    }
  }

  Future<void> createSubCategory(String id) async {
    if (state is CreateLoadingState ||
        formKey?.currentState?.validate() != true) return;
    emit(const CreateLoadingState());
    try {
      final doc = _db.collection("subCategories").doc();

      final post = SubCategoryModel(
        id: doc.id,
        name: subCategoryController.text,
        category_id: id,
      );
      await doc.set(
        post.toJson(),
      );
      emit(const CreateSuccessState());
    } on FirebaseException catch (e) {
      emit(CreateErrorState(e.code));
    } catch (e) {
      emit(CreateErrorState(e.toString()));
    }
  }

  Future<void> createComment(String postId, String body) async {
    if (state is CreateLoadingState ||
        formKey?.currentState?.validate() != true) return;
    emit(const CreateLoadingState());
    try {
      final doc = _db.collection("comments").doc();

      final comment = CommentModel(
        id: doc.id,
        postId: postId,
        userId: Injection<AuthService>().currentUser!.uid,
        body: body,
        createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
      );
      await doc
          .set(
        comment.toJson(),
      )
          .then((v) async {
        NotificationService().sentNewCommentNotification(postId, body);
      });
      commentController.text = "";
      emit(const CreateSuccessState());
    } on FirebaseException catch (e) {
      emit(CreateErrorState(e.code));
    } catch (e) {
      emit(CreateErrorState(e.toString()));
    }
  }

  String updateBody = "";
  String commentId = "";
  Future<void> updateComment() async {
    await _db
        .collection("comments")
        .doc(commentId)
        .update({"body": commentController.text});
  }

  Future<void> deletePost(String postId) async {
    await _db.collection("posts").doc(postId).delete();

    var saveData = await _db.collection("savePosts").get();
    var savedDatas = saveData.docs;
    for (var element in savedDatas) {
      var postedId = element["post_id"].toString();

      if (postedId == postId) {
        await _db.collection("savePosts").doc(element["id"]).delete().then((e) {
          log("DELETE SAVED POST");
        });
      }
    }
    var notiData = await _db.collection("notifications").get();
    var notis = notiData.docs;
    for (var element in notis) {
      var postedId = element["post_id"].toString();

      if (postedId == postId) {
        await _db
            .collection("notifications")
            .doc(element["id"])
            .delete()
            .then((e) {
          log("DELETE NOTI POST");
        });
      }
    }

    // var cmtData = await _db.collection("comments").get();
    // var cmt = cmtData.docs;
    // for (var element in cmt) {
    //   var postedId = element["post_id"].toString();

    //   if (postedId == postId) {
    //     await _db.collection("comments").doc(element['id']).delete();
    //   }
    // }

    // var postImgData = await _db.collection("postImages").get();
    // var postImg = postImgData.docs;
    // for (var element in postImg) {
    //   var postedId = element["post_id"].toString();

    //   if (postedId == postId) {
    //     await _db.collection("postImages").doc(element['id']).delete();
    //   }
    // }

    // var likeData = await _db.collection("likes").get();
    // var like = likeData.docs;
    // for (var element in like) {
    //   var postedId = element["post_id"].toString();

    //   if (postedId == postId) {
    //     await _db.collection("likes").doc(element['id']).delete();
    //   }
    // }
  }

  Future<void> likeAction(String postId) async {
    try {
      final doc = _db.collection("likes").doc();
      var likedId = "";
      var existUser = false;
      final like = LikeModel(
        id: doc.id,
        postId: postId,
        userId: Injection<AuthService>().currentUser!.uid,
        createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
      );

      var data = await _db.collection("likes").get();
      var likedUser = data.docs;
      for (var element in likedUser) {
        var userId = element["user_id"].toString();
        var postedId = element["post_id"].toString();

        if (userId == auth.currentUser!.uid && postedId == postId) {
          likedId = element["id"].toString();
          existUser = true;
        }
      }

      if (existUser) {
        log("ExistUser $likedId");
        await _db.collection("likes").doc(likedId).delete();
      } else {
        log("Not ExistUser");

        await doc.set(
          like.toJson(),
        );
      }

      emit(const CreateSuccessState());
    } on FirebaseException catch (e) {
      emit(CreateErrorState(e.code));
    } catch (e) {
      emit(CreateErrorState(e.toString()));
    }
  }

  Future<void> savedPostAction(String postId) async {
    try {
      final doc = _db.collection("savePosts").doc();
      var savedID = "";
      var existUser = false;
      final savePost = SavePostModel(
        id: doc.id,
        postId: postId,
        userId: Injection<AuthService>().currentUser!.uid,
        createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
      );

      var data = await _db.collection("savePosts").get();
      var likedUser = data.docs;
      for (var element in likedUser) {
        var userId = element["user_id"].toString();
        var postedId = element["post_id"].toString();

        if (userId == auth.currentUser!.uid && postedId == postId) {
          savedID = element["id"].toString();
          existUser = true;
        }
      }

      if (existUser) {
        log("ExistUser $savedID");
        await _db.collection("savePosts").doc(savedID).delete();
      } else {
        log("Not ExistUser");

        await doc.set(
          savePost.toJson(),
        );
      }

      emit(const CreateSuccessState());
    } on FirebaseException catch (e) {
      emit(CreateErrorState(e.code));
    } catch (e) {
      emit(CreateErrorState(e.toString()));
    }
  }

  Future<bool> checkMainCategories(String name) async {
    var exitName = false;
    var data = await _db.collection("mainCategories").get();
    var mainCategories = data.docs;
    for (var element in mainCategories) {
      var elementName = element["name"].toString();

      if (name == elementName) {
        exitName = true;
      }
    }

    return exitName;
  }

  Future<bool> checkCategories(String name) async {
    var exitName = false;
    var data = await _db.collection("categories").get();
    var mainCategories = data.docs;
    for (var element in mainCategories) {
      var elementName = element["name"].toString();

      if (name == elementName) {
        exitName = true;
      }
    }

    return exitName;
  }

  Future<bool> checkSubCategories(String name, String categoryID) async {
    var exitName = false;
    var data = await _db.collection("subCategories").get();
    var subCategories = data.docs;
    for (var element in subCategories) {
      var elementName = element["name"].toString();
      var elementID = element["category_id"].toString();

      if (name == elementName && categoryID == elementID) {
        exitName = true;
      }
    }
    log("Exit? $exitName");
    return exitName;
  }

  callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Future<void> close() {
    formKey = null;
    titleController.dispose();
    commentController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    subCategoryController.dispose();
    mainCategoryController.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    return super.close();
  }
}
