import 'dart:developer';

import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/models/category_model/category_model.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/data/models/sub_category_modle/sub_category_model.dart';
import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:starlight_utils/starlight_utils.dart';

import 'post_create_state.dart';

class CreateCubit extends Cubit<CreateState> {
  CreateCubit() : super(const CreateInitialState());

  final FirebaseFirestore db = Injection<FirebaseFirestore>();
  final AuthService auth = Injection<AuthService>();
  final TextEditingController titleController = TextEditingController(),
      categoryController = TextEditingController(),
      descriptionController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode(),
      descriptionFocusNode = FocusNode();
  String? imageUrl;

  Future<void> createPost() async {
    if (state is CreateLoadingState) return;
    emit(const CreateLoadingState());
    try {
      final doc = db.collection("posts").doc();

      final post = PostModel(
        id: doc.id,
        userId: auth.currentUser!.uid,
        createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
        category: categoryController.text,
        image: imageUrl ?? "",
        description: descriptionController.text,
      );
      await doc.set(
        post.toJson(),
      );
      categoryController.text = "";
      descriptionController.text = "";
      imageUrl = "";
      emit(const CreateSuccessState());
    } on FirebaseException catch (e) {
      emit(CreateErrorState(e.code));
    } catch (e) {
      emit(CreateErrorState(e.toString()));
    }
  }

  Future<void> createCategory() async {
    if (state is CreateLoadingState) return;
    emit(const CreateLoadingState());
    try {
      final doc = db.collection("categories").doc();

      final post = CategoryModel(
        id: doc.id,
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

  Future<void> createSubCategory(String id) async {
    if (state is CreateLoadingState) return;
    emit(const CreateLoadingState());
    try {
      final doc = db.collection("subCategories").doc();

      final post = SubCategoryModel(
        id: doc.id,
        name: categoryController.text,
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

  Future<void> pickPostPhoto() async {
    if (state is CreateLoadingState) return;
    emit(const CreateLoadingState());

    final userChoice = await StarlightUtils.dialog(AlertDialog(
      title: const Text("Choose Method"),
      content: SizedBox(
        height: 120,
        child: Column(children: [
          ListTile(
            onTap: () {
              StarlightUtils.pop(result: ImageSource.camera);
            },
            leading: const Icon(Icons.camera),
            title: const Text("Camera"),
          ),
          ListTile(
            onTap: () {
              StarlightUtils.pop(result: ImageSource.gallery);
            },
            leading: const Icon(Icons.image),
            title: const Text("Gallery"),
          )
        ]),
      ),
    ));
    if (userChoice == null) {
      log("User choose is null");
      emit(const CreateErrorState("User choose is nill"));

      return;
    }
    final XFile? image =
        await Injection<ImagePicker>().pickImage(source: userChoice);
    if (image == null) {
      log("Xfile  is null");
      emit(const CreateErrorState("Xfile is nill"));

      return;
    }
    final point = Injection<FirebaseStorage>().ref(
        "postImages/${auth.currentUser?.uid}/${DateTime.now().toString().replaceAll(" ", "")}/${image.name.split(".").last}");
    final uploaded = await point.putFile(image.path.file);
    //TODO

    imageUrl = await Injection<FirebaseStorage>()
        .ref(uploaded.ref.fullPath)
        .getDownloadURL();
    log("image is $imageUrl");

    emit(CreateSuccessState(imageUrl));
    return;
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    return super.close();
  }
}
