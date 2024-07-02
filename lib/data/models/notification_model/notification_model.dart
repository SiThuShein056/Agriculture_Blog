import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String createdAt;

  const NotificationModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(dynamic data) {
    return NotificationModel(
        id: data["id"],
        postId: data["post_id"],
        userId: data["user_id"],
        createdAt: data["created_at"]);
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "user_id": userId,
        "created_at": createdAt,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
