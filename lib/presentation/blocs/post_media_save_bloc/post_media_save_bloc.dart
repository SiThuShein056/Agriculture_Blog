import 'dart:developer';

import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/blocs/post_media_save_bloc/post_media_save_event.dart';
import 'package:blog_app/presentation/blocs/post_media_save_bloc/post_media_save_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:starlight_utils/starlight_utils.dart';

class PostMediaSaveBloc
    extends Bloc<PostMediaSaveBaseEvent, PostMediaSaveBaseState> {
  PostMediaSaveBloc() : super(const InitialState()) {
    on<PostSaveImageEvent>((event, emit) async {
      if (state is SaveLoadingState) return;
      emit(const SaveLoadingState());
      log("Save loading...................");
      saving.value = true;

      try {
        await GallerySaver.saveImage("${event.url}.jpg",
                albumName: "Farmer Hub")
            .then((success) {
          if (success != null && success) {
            emit(const SuccessState());
            log("Save Success...................");
            saving.value = false;

            StarlightUtils.snackbar(
                const SnackBar(content: Text("Saved Image")));
          }
        });
      } catch (e) {
        emit(FailState(e.toString()));
        log("Save Error is : ${e.toString()}");
        StarlightUtils.snackbar(
            SnackBar(content: Text("Error is : ${e.toString()}")));
      }
    });
    on<PostSaveVideoEvent>((event, emit) async {
      if (state is SaveLoadingState) return;
      emit(const SaveLoadingState());
      log("Save loading...................");
      saving.value = true;

      try {
        await GallerySaver.saveVideo("${event.url}.mp4",
                albumName: "Farmer Hub")
            .then((success) {
          if (success != null && success) {
            emit(const SuccessState());
            log("Save Success...................");
            saving.value = false;

            StarlightUtils.snackbar(
                const SnackBar(content: Text("Saved Video")));
          }
        });
      } catch (e) {
        emit(FailState(e.toString()));
        log("Save Error is : ${e.toString()}");
        StarlightUtils.snackbar(
            SnackBar(content: Text("Error is : ${e.toString()}")));
      }
    });
  }
  final ValueNotifier saving = ValueNotifier(false);

  final auth = Injection<AuthService>();
  final storage = Injection<FirebaseStorage>();

  dispose() {
    saving.dispose();
  }
}
