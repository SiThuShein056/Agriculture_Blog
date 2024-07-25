class MessageModel {
  final String fromId;
  final String toId;
  final String readTime;
  final String sentTime;
  final String type;
  final String message;

  const MessageModel({
    required this.fromId,
    required this.toId,
    required this.readTime,
    required this.sentTime,
    required this.type,
    required this.message,
  });

  Map<String, dynamic> toJson() => {
        "fromId": fromId,
        "toId": toId,
        "read_time": readTime,
        "sent_time": sentTime,
        "type": type,
        "message": message,
      };

  factory MessageModel.fromJson(dynamic data) {
    return MessageModel(
      fromId: data["fromId"],
      toId: data["toId"],
      readTime: data["read_time"],
      sentTime: data["sent_time"],
      type: data["type"],
      message: data["message"],
    );
  }
}
