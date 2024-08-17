abstract class UpdateDataBaseState {
  final List<String>? imageUrl;
  final List<String>? videoUrl;
  const UpdateDataBaseState([this.imageUrl, this.videoUrl]);
}

class UpdateDataInitialState extends UpdateDataBaseState {
  const UpdateDataInitialState();
}

class UpdateDataLoadingState extends UpdateDataBaseState {
  const UpdateDataLoadingState();
}

class UpdateDataSuccessState extends UpdateDataBaseState {
  const UpdateDataSuccessState([super.imageUrl, super.videoUrl]);
}

class UpdatePickSuccessState extends UpdateDataBaseState {
  const UpdatePickSuccessState([super.imageUrl, super.videoUrl]);
}

class UpdateDataErrorState extends UpdateDataBaseState {
  String message;
  UpdateDataErrorState(this.message);
}
