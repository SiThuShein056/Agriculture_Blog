abstract class PostMediaSaveBaseState {
  const PostMediaSaveBaseState();
}

class SaveLoadingState extends PostMediaSaveBaseState {
  const SaveLoadingState();
}

class InitialState extends PostMediaSaveBaseState {
  const InitialState();
}

class SuccessState extends PostMediaSaveBaseState {
  const SuccessState();
}

class FailState extends PostMediaSaveBaseState {
  final message;
  FailState(this.message);
}
