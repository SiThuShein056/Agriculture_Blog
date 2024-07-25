class UserImageBaseState {
  const UserImageBaseState();
}

class InitialState extends UserImageBaseState {
  const InitialState();
}

class LoadingState extends UserImageBaseState {
  const LoadingState();
}

class SuccessState extends UserImageBaseState {
  const SuccessState();
}

class FailState extends UserImageBaseState {
  String message;
  FailState(this.message);
}
