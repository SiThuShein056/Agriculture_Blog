abstract class ChatBaseState {
  const ChatBaseState();
}

class ChatLoadingState extends ChatBaseState {
  const ChatLoadingState();
}

class ChatInitialState extends ChatBaseState {
  const ChatInitialState();
}

class SendTextMessageLoadingState extends ChatBaseState {
  const SendTextMessageLoadingState();
}

class SendVideoMessageLoadingState extends ChatBaseState {
  const SendVideoMessageLoadingState();
}

class SendImageMessageLoadingState extends ChatBaseState {
  const SendImageMessageLoadingState();
}

class ChatSuccessState extends ChatBaseState {
  const ChatSuccessState();
}

class SaveLoadingState extends ChatBaseState {
  const SaveLoadingState();
}

class SaveSuccessState extends ChatBaseState {
  const SaveSuccessState();
}

class ChatFailState extends ChatBaseState {
  final message;
  ChatFailState(this.message);
}
