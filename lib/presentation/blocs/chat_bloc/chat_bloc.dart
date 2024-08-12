import 'dart:developer';

import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/db_create_service/chat_create_service/chat_create_service.dart';
import 'package:blog_app/data/models/message_model/message_model.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/blocs/chat_bloc/chat_event.dart';
import 'package:blog_app/presentation/blocs/chat_bloc/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatBaseEvent, ChatBaseState> {
  ChatBloc() : super(const ChatInitialState()) {
    on<SentTextMessageEvent>((event, emit) {
      if (state is ChatLoadingState ||
          formKey?.currentState?.validate() != true) return;
      emit(const ChatLoadingState());
      try {
        emit(const DataSendingState());
        ChatCreateService().createMessage(
            message: messageController.text, toId: event.toId, type: Type.text);
        messageController.text = "";
        emit(const DataSentSuccessState());
      } catch (e) {
        emit(ChatFailState(e));
      }
      emit(const ChatSuccessState());
    });
    on<SentFileImageMessageEvent>((event, emit) async {
      if (state is ChatLoadingState) return;
      emit(const ChatLoadingState());
      try {
        emit(const DataSendingState());
        log("sentFileImageMessage");
        ChatCreateService().sentFileImageMessage(toId: event.toId);
        emit(const DataSentSuccessState());

        messageController.text = "";
      } catch (e) {
        emit(ChatFailState(e));
      }
      emit(const ChatSuccessState());
    });
    on<SentCameraImageMessageEvent>((event, emit) async {
      if (state is ChatLoadingState) return;
      emit(const ChatLoadingState());
      try {
        emit(const DataSendingState());
        ChatCreateService().sentCameraImageMessage(toId: event.toId);
        emit(const DataSentSuccessState());
        messageController.text = "";
      } catch (e) {
        emit(ChatFailState(e));
      }
      emit(const ChatSuccessState());
    });
    on<SentVideoMessageEvent>((event, emit) async {
      if (state is ChatLoadingState) return;
      emit(const ChatLoadingState());
      try {
        emit(const DataSendingState());
        ChatCreateService().sentVideoMessage(toId: event.toId);
        emit(const DataSentSuccessState());
        messageController.text = "";
      } catch (e) {
        emit(ChatFailState(e));
      }
      emit(const ChatSuccessState());
    });
  }

  final TextEditingController messageController = TextEditingController();
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  final ScrollController commentScrollController = ScrollController();
  final ValueNotifier isShowEmoji = ValueNotifier(false);
  final _auth = Injection<AuthService>();

  void toggle() {
    isShowEmoji.value = !isShowEmoji.value;
  }

  dispose() {
    formKey = null;
    messageController.dispose();
    // videoPlayerController.dispose();
    commentScrollController.dispose();
    isShowEmoji.dispose();
  }
}
