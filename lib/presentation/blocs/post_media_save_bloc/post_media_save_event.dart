abstract class PostMediaSaveBaseEvent {
  const PostMediaSaveBaseEvent();
}

class PostSaveImageEvent extends PostMediaSaveBaseEvent {
  final url;

  const PostSaveImageEvent(this.url);
}

class PostSaveVideoEvent extends PostMediaSaveBaseEvent {
  final url;
  const PostSaveVideoEvent(this.url);
}
