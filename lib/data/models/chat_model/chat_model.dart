class ChatModel {
  final List participants;
  final String id;
  final String createdTime;

  const ChatModel({
    required this.participants,
    required this.id,
    required this.createdTime,
  });

  Map<String, dynamic> toJson() => {
        "participants": participants,
        "id": id,
        "created_time": createdTime,
      };

  factory ChatModel.fromJson(dynamic data) {
    return ChatModel(
      participants: data["participants"],
      id: data["id"],
      createdTime: data["created_time"],
    );
  }
}
