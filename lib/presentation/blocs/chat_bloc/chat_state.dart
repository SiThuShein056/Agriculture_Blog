abstract class ChatBaseState {
  const ChatBaseState();
}

class ChatLoadingState extends ChatBaseState {
  const ChatLoadingState();
}

class ChatInitialState extends ChatBaseState {
  const ChatInitialState();
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
