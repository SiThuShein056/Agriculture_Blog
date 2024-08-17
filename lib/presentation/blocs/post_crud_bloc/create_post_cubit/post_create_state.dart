abstract class CreateState {
  final List<String>? imageUrl;
  final List<String>? videoUrl;

  const CreateState({this.imageUrl, this.videoUrl});
}

class CreateInitialState extends CreateState {
  const CreateInitialState();
}

class CreateLoadingState extends CreateState {
  const CreateLoadingState();
}

class CoverPhotoPickingState extends CreateState {
  const CoverPhotoPickingState();
}

class ProfilePhotoPickingState extends CreateState {
  const ProfilePhotoPickingState();
}

class CreateSuccessState extends CreateState {
  const CreateSuccessState({super.imageUrl, super.videoUrl});
}

class CreateErrorState extends CreateState {
  final String message;
  const CreateErrorState(this.message);
}
