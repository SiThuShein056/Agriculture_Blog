abstract class ChatBaseState {
  const ChatBaseState();
}

class ChatLoadingState extends ChatBaseState {
  const ChatLoadingState();
}

class DataSendingState extends ChatBaseState {
  const DataSendingState();
}

class ChatInitialState extends ChatBaseState {
  const ChatInitialState();
}

class DataSentSuccessState extends ChatBaseState {
  const DataSentSuccessState();
}

class ChatSuccessState extends ChatBaseState {
  const ChatSuccessState();
}

class ChatFailState extends ChatBaseState {
  final message;
  ChatFailState(this.message);
}
