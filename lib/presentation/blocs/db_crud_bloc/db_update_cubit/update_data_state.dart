abstract class UpdateDataBaseState {
  final List<String>? url;
  const UpdateDataBaseState([this.url]);
}

class UpdateDataInitialState extends UpdateDataBaseState {
  const UpdateDataInitialState();
}

class UpdateDataLoadingState extends UpdateDataBaseState {
  const UpdateDataLoadingState();
}

class UpdateDataSuccessState extends UpdateDataBaseState {
  const UpdateDataSuccessState([super.url]);
}

class UpdatePickSuccessState extends UpdateDataBaseState {
  const UpdatePickSuccessState([super.url]);
}

class UpdateDataErrorState extends UpdateDataBaseState {
  String message;
  UpdateDataErrorState(this.message);
}
