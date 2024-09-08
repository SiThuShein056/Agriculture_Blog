import 'dart:developer';

import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/models/post_Images_model/post_image_model.dart';
import 'package:blog_app/data/models/post_video_model/post_video_model.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/blocs/post_crud_bloc/update_post_cubit/update_data_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../../../data/datasources/remote/db_crud_service/db_update_service.dart/db_update_service.dart';

class UpdateDataCubit extends Cubit<UpdateDataBaseState> {
  UpdateDataCubit() : super(const UpdateDataInitialState());
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();
  final FirebaseStorage _storage = Injection<FirebaseStorage>();
  final AuthService auth = Injection<AuthService>();
  final TextEditingController titleController = TextEditingController(),
      categoryController = TextEditingController(),
      mainCategoryController = TextEditingController(),
      commentController = TextEditingController(),
      phoneController = TextEditingController(),
      privacyController = TextEditingController(),
      descriptionController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode(),
      descriptionFocusNode = FocusNode();
  List<String> imageList = [];
  List<String> videoList = [];
  ValueNotifier<String> privacy = ValueNotifier("select");
  ValueNotifier<bool> commentStatus = ValueNotifier(true);

  GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  void toggle() {
    commentStatus.value = !commentStatus.value;
  }

  Future<void> deletePostImages(String postId) async {
    var postimgData = await _db.collection("postImages").get();
    var data = postimgData.docs;
    for (var element in data) {
      var postedId = element["post_id"].toString();

      if (postedId == postId) {
        log("Deleted Image");
        await _db.collection("postImages").doc(element['id']).delete();
      }
    }
  }

  Future<void> deletePostVideos(String postId) async {
    var postvideoData = await _db.collection("postVideos").get();
    var data = postvideoData.docs;
    for (var element in data) {
      var postedId = element["post_id"].toString();

      if (postedId == postId) {
        log("Deleted Video");
        await _db.collection("postVideos").doc(element['id']).delete();
      }
    }
  }

  Future<void> updatePost(String id) async {
    if (state is UpdateDataLoadingState ||
        formKey?.currentState?.validate() != true) return;
    emit(const UpdateDataLoadingState());
    try {
      DatabaseUpdateService().updatePostData(
        id: id,
        category: mainCategoryController.text,
        description: descriptionController.text,
        phone: phoneController.text,
        privacy: privacy.value,
        commentStatus: commentStatus.value,
      );

      if (imageList != []) {
        log("For In  ${imageList.length.toString()}");
        for (var element in imageList) {
          final postImageDoc = _db.collection("postImages").doc();

          final postImg = PostImageModel(
            id: postImageDoc.id,
            postId: id,
            userId: auth.currentUser!.uid,
            createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
            imageUrl: element,
          );
          log("buld db");
          await postImageDoc.set(
            postImg.toJson(),
          );
        }
      }
      if (videoList != []) {
        log("For In  ${videoList.length.toString()}");
        for (var element in videoList) {
          final postVideoDoc = _db.collection("postVideos").doc();

          final postVideo = PostVideoModel(
            id: postVideoDoc.id,
            postId: id,
            userId: auth.currentUser!.uid,
            createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
            videoUrl: element,
          );
          await postVideoDoc.set(
            postVideo.toJson(),
          );
        }
      }

      emit(const UpdateDataSuccessState());
    } on FirebaseException catch (e) {
      emit(UpdateDataErrorState(e.code));
    } catch (e) {
      emit(UpdateDataErrorState(e.toString()));
    }
  }

  Future<void> updateCategory(String id) async {
    if (state is UpdateDataLoadingState ||
        formKey?.currentState?.validate() != true) return;
    emit(const UpdateDataLoadingState());
    try {
      DatabaseUpdateService().updateCategoryData(
        id: id,
        name: categoryController.text,
      );

      emit(const UpdateDataSuccessState());
    } on FirebaseException catch (e) {
      emit(UpdateDataErrorState(e.code));
    } catch (e) {
      emit(UpdateDataErrorState(e.toString()));
    }
  }

  Future<void> updateMainCategory(String id) async {
    if (state is UpdateDataLoadingState ||
        formKey?.currentState?.validate() != true) return;
    emit(const UpdateDataLoadingState());
    try {
      DatabaseUpdateService().updateMainCategoryData(
        id: id,
        name: mainCategoryController.text,
      );

      emit(const UpdateDataSuccessState());
    } on FirebaseException catch (e) {
      emit(UpdateDataErrorState(e.code));
    } catch (e) {
      emit(UpdateDataErrorState(e.toString()));
    }
  }

  Future<void> updateSubCategory(String id) async {
    if (state is UpdateDataLoadingState ||
        formKey?.currentState?.validate() != true) return;
    emit(const UpdateDataLoadingState());
    try {
      DatabaseUpdateService().updateSubCategoryData(
        id: id,
        name: categoryController.text,
      );

      emit(const UpdateDataSuccessState());
    } on FirebaseException catch (e) {
      emit(UpdateDataErrorState(e.code));
    } catch (e) {
      emit(UpdateDataErrorState(e.toString()));
    }
  }

  Future<void> pickPostPhotos() async {
    if (state is UpdateDataLoadingState) return;
    emit(const UpdateDataLoadingState());

    final List<XFile> image = await Injection<ImagePicker>().pickMultiImage();

    for (var element in image) {
      final point = _storage.ref(
          "postImages/${auth.currentUser?.uid}/${DateTime.now().toString().replaceAll(" ", "")}/${element.name.split(".").last}");
      final uploaded = await point.putFile(element.path.file);
      //TODO

      var imageUrl = await _storage.ref(uploaded.ref.fullPath).getDownloadURL();
      imageList.add(imageUrl);
    }

    emit(UpdatePickSuccessState(imageList, videoList));
    return;
  }

  Future<void> pickPostVideos() async {
    if (state is UpdateDataLoadingState) return;
    emit(const UpdateDataLoadingState());

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
      videoList.add(v);
    }

    emit(UpdatePickSuccessState(imageList, videoList));
    return;
  }

  @override
  Future<void> close() {
    formKey = null;
    titleController.dispose();
    commentController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    mainCategoryController.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    return super.close();
  }
}
