import 'dart:developer';

import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/models/post_Images_model/post_image_model.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/blocs/db_crud_bloc/db_update_cubit/update_data_state.dart';
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
  final AuthService auth = Injection<AuthService>();
  final TextEditingController titleController = TextEditingController(),
      categoryController = TextEditingController(),
      commentController = TextEditingController(),
      phoneController = TextEditingController(),
      privacyController = TextEditingController(),
      descriptionController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode(),
      descriptionFocusNode = FocusNode();
  String? imageUrl;
  List<String> imageList = [];
  ValueNotifier<String> privacy = ValueNotifier("select");

  GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  Future<void> deletePostImages(String postId) async {
    var postimgData = await _db.collection("postImages").get();
    var data = postimgData.docs;
    for (var element in data) {
      var postedId = element["post_id"].toString();

      if (postedId == postId) {
        log("Deleted");
        await _db.collection("postImages").doc(element['id']).delete();
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
          category: categoryController.text,
          description: descriptionController.text,
          phone: phoneController.text,
          privacy: privacy.value);

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

  // Future<void> pickPostPhoto() async {
  //   if (state is UpdateDataLoadingState) return;
  //   emit(const UpdateDataLoadingState());

  //   final userChoice = await StarlightUtils.dialog(AlertDialog(
  //     title: const Text("Choose Method"),
  //     content: SizedBox(
  //       height: 120,
  //       child: Column(children: [
  //         ListTile(
  //           onTap: () {
  //             StarlightUtils.pop(result: ImageSource.camera);
  //           },
  //           leading: const Icon(Icons.camera),
  //           title: const Text("Camera"),
  //         ),
  //         ListTile(
  //           onTap: () {
  //             StarlightUtils.pop(result: ImageSource.gallery);
  //           },
  //           leading: const Icon(Icons.image),
  //           title: const Text("Gallery"),
  //         )
  //       ]),
  //     ),
  //   ));
  //   if (userChoice == null) {
  //     emit(UpdateDataErrorState("User choose is nill"));

  //     return;
  //   }
  //   final XFile? image =
  //       await Injection<ImagePicker>().pickImage(source: userChoice);
  //   if (image == null) {
  //     emit(UpdateDataErrorState("Xfile is nill"));

  //     return;
  //   }
  //   final point = Injection<FirebaseStorage>().ref(
  //       "postImages/${auth.currentUser?.uid}/${DateTime.now().toString().replaceAll(" ", "")}/${image.name.split(".").last}");
  //   final uploaded = await point.putFile(image.path.file);
  //   //TODO

  //   imageUrl = await Injection<FirebaseStorage>()
  //       .ref(uploaded.ref.fullPath)
  //       .getDownloadURL();

  //   emit(UpdatePickSuccessState(imageUrl));
  //   return;
  // }

  Future<void> pickPostPhotos() async {
    if (state is UpdateDataLoadingState) return;
    emit(const UpdateDataLoadingState());

    final List<XFile> image = await Injection<ImagePicker>().pickMultiImage();

    for (var element in image) {
      final point = Injection<FirebaseStorage>().ref(
          "postImages/${auth.currentUser?.uid}/${DateTime.now().toString().replaceAll(" ", "")}/${element.name.split(".").last}");
      final uploaded = await point.putFile(element.path.file);
      //TODO

      var imageUrl = await Injection<FirebaseStorage>()
          .ref(uploaded.ref.fullPath)
          .getDownloadURL();
      imageList.add(imageUrl);
    }

    emit(UpdatePickSuccessState(imageList));
    return;
  }

  @override
  Future<void> close() {
    formKey = null;
    titleController.dispose();
    commentController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    return super.close();
  }
}
