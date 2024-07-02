import 'package:equatable/equatable.dart';

class CommentModel extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String body;
  final String createdAt;

  const CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.body,
    required this.createdAt,
  });
  factory CommentModel.fromJson(dynamic data) {
    return CommentModel(
      id: data["id"],
      postId: data["post_id"],
      userId: data["user_id"],
      body: data["body"],
      createdAt: data["created_at"],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "user_id": userId,
        "body": body,
        "created_at": createdAt,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
