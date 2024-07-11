abstract class CreateState {
  final String? url;

  const CreateState([this.url]);
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
  const CreateSuccessState([super.url]);
}

class CreateErrorState extends CreateState {
  final String message;
  const CreateErrorState(this.message);
}
