import 'dart:developer';

import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/conservation_crud_service/chat_create_service.dart';
import 'package:blog_app/data/models/message_model/message_model.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/blocs/chat_bloc/chat_event.dart';
import 'package:blog_app/presentation/blocs/chat_bloc/chat_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ChatBloc extends Bloc<ChatBaseEvent, ChatBaseState> {
  ChatBloc() : super(const ChatInitialState()) {
    on<SentTextMessageEvent>((event, emit) async {
      if (state is ChatLoadingState ||
          formKey?.currentState?.validate() != true) return;
      emit(const ChatLoadingState());
      try {
        await ChatCreateService().createMessage(
            message: messageController.text, toId: event.toId, type: Type.text);

        messageController.text = "";
        emit(const ChatSuccessState());
      } catch (e) {
        emit(ChatFailState(e));
      }
    });
    on<SentFileImageMessageEvent>((event, emit) async {
      if (state is ChatLoadingState) return;
      emit(const ChatLoadingState());
      try {
        await ChatCreateService().sentFileImageMessage(toId: event.toId);

        emit(const ChatSuccessState());
      } catch (e) {
        emit(ChatFailState(e));
      }
    });
    on<SentVideoMessageEvent>((event, emit) async {
      if (state is ChatLoadingState) return;
      emit(const ChatLoadingState());

      try {
        await ChatCreateService().sentVideoMessage(toId: event.toId);
        emit(const ChatSuccessState());
      } catch (e) {
        emit(ChatFailState(e));
      }
    });
    on<SentCameraImageMessageEvent>((event, emit) async {
      if (state is ChatLoadingState) return;
      emit(const ChatLoadingState());
      try {
        await ChatCreateService().sentCameraImageMessage(toId: event.toId);
        emit(const ChatSuccessState());
      } catch (e) {
        emit(ChatFailState(e));
      }
    });

    on<SentVideoCallLinkEvent>((event, emit) async {
      if (state is ChatLoadingState) return;
      emit(const ChatLoadingState());
      try {
        await ChatCreateService().sentVideoCallLinkMessage(toId: event.toId);
        emit(const ChatSuccessState());
      } catch (e) {
        emit(ChatFailState(e));
      }
    });
    on<SentVoiceCallLinkEvent>((event, emit) async {
      if (state is ChatLoadingState) return;
      emit(const ChatLoadingState());
      try {
        await ChatCreateService().sentVoiceCallLinkMessage(toId: event.toId);
        messageController.text = "";
        emit(const ChatSuccessState());
      } catch (e) {
        emit(ChatFailState(e));
      }
    });

    on<SaveImageEvent>((event, emit) async {
      if (state is ChatLoadingState) return;
      emit(const SaveLoadingState());
      log("Save loading...................");
      saving.value = true;

      try {
        await GallerySaver.saveImage("${event.url}.jpg",
                albumName: "Farmer Hub")
            .then((success) {
          StarlightUtils.pop();

          if (success != null && success) {
            emit(const SaveSuccessState());
            log("Save Success...................");
            saving.value = false;

            StarlightUtils.snackbar(
                const SnackBar(content: Text("Saved Image")));
          }
        });
      } catch (e) {
        StarlightUtils.pop();
        emit(ChatFailState(e.toString()));
        log("Save Error is : ${e.toString()}");
        StarlightUtils.snackbar(
            SnackBar(content: Text("Error is : ${e.toString()}")));
      }
    });
    on<SaveVideoEvent>((event, emit) async {
      if (state is ChatLoadingState) return;
      emit(const SaveLoadingState());
      log("Save loading...................");
      saving.value = true;

      try {
        await GallerySaver.saveVideo("${event.url}.mp4",
                albumName: "Farmer Hub")
            .then((success) {
          StarlightUtils.pop();

          if (success != null && success) {
            emit(const SaveSuccessState());
            log("Save Success...................");
            saving.value = false;

            StarlightUtils.snackbar(
                const SnackBar(content: Text("Saved Video")));
          }
        });
      } catch (e) {
        StarlightUtils.pop();
        emit(ChatFailState(e.toString()));
        log("Save Error is : ${e.toString()}");
        StarlightUtils.snackbar(
            SnackBar(content: Text("Error is : ${e.toString()}")));
      }
    });
  }

  final TextEditingController messageController = TextEditingController();
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  final ScrollController commentScrollController = ScrollController();
  final ValueNotifier isShowEmoji = ValueNotifier(false);
  final ValueNotifier saving = ValueNotifier(false);

  final auth = Injection<AuthService>();
  final storage = Injection<FirebaseStorage>();

  void toggle() {
    isShowEmoji.value = !isShowEmoji.value;
  }

  dispose() {
    formKey = null;
    messageController.dispose();
    commentScrollController.dispose();
    isShowEmoji.dispose();
  }
}
