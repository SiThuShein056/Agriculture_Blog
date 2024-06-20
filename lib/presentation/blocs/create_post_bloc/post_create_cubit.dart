import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'post_create_state.dart';

class PostCreateCubit extends Cubit<PostCreateState> {
  PostCreateCubit() : super(const PostCreateInitialState());

  final FirebaseFirestore db = Injection<FirebaseFirestore>();
  final FirebaseStorage storage = Injection<FirebaseStorage>();
  final AuthService auth = Injection<AuthService>();
  final TextEditingController titleController = TextEditingController(),
      categoryController = TextEditingController(),
      descriptionController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode(),
      descriptionFocusNode = FocusNode();

  Future<void> onSave() async {
    if (state is PostCreateLoadingState) return;
    emit(const PostCreateLoadingState());
    try {
      final doc = db.collection("posts").doc();

      final post = PostModel(
          id: doc.id,
          userId: auth.currentUser!.uid,
          category: categoryController.text,
          description: descriptionController.text);
      await doc.set(
        post.toJson(),
      );
      emit(const PostCreateSuccessState());
    } on FirebaseException catch (e) {
      emit(PostCreateErrorState(e.code));
    } catch (e) {
      emit(PostCreateErrorState(e.toString()));
    }
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
