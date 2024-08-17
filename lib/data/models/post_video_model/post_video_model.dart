import 'package:equatable/equatable.dart';

class PostVideoModel extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String createdAt;
  final String videoUrl;

  const PostVideoModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.createdAt,
    required this.videoUrl,
  });

  factory PostVideoModel.fromJson(dynamic data) {
    return PostVideoModel(
      id: data["id"],
      postId: data["post_id"],
      userId: data["user_id"],
      createdAt: data["created_at"],
      videoUrl: data["videoUrl"],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "user_id": userId,
        "created_at": createdAt,
        "videoUrl": videoUrl,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
