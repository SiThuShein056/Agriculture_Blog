import 'package:equatable/equatable.dart';

class PostImageModel extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String createdAt;
  final String imageUrl;

  const PostImageModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.createdAt,
    required this.imageUrl,
  });

  factory PostImageModel.fromJson(dynamic data) {
    return PostImageModel(
      id: data["id"],
      postId: data["post_id"],
      userId: data["user_id"],
      createdAt: data["created_at"],
      imageUrl: data["imageUrl"],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "user_id": userId,
        "created_at": createdAt,
        "imageUrl": imageUrl,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
