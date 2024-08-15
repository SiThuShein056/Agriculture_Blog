class ChatModel {
  final List participants;
  final String id;
  final String createdTime;
  final String? blockerId;
  final bool isBlocked;

  const ChatModel({
    required this.participants,
    required this.id,
    required this.createdTime,
    required this.blockerId,
    required this.isBlocked,
  });

  Map<String, dynamic> toJson() => {
        "participants": participants,
        "id": id,
        "created_time": createdTime,
        "blocker_id": blockerId,
        "is_blocked": isBlocked,
      };

  factory ChatModel.fromJson(dynamic data) {
    return ChatModel(
        participants: data["participants"],
        id: data["id"],
        createdTime: data["created_time"],
        blockerId: data["blocker_id"],
        isBlocked: data["is_blocked"]);
  }
}
