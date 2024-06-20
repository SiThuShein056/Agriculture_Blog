abstract class PostCreateState {
  const PostCreateState();
}

class PostCreateInitialState extends PostCreateState {
  const PostCreateInitialState();
}

class PostCreateLoadingState extends PostCreateState {
  const PostCreateLoadingState();
}

class PostCreateSuccessState extends PostCreateState {
  const PostCreateSuccessState();
}

class PostCreateErrorState extends PostCreateState {
  final String message;
  const PostCreateErrorState(this.message);
}
