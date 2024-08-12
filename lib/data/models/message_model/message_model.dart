class MessageModel {
  final String fromId;
  final String id;
  final String chatId;
  final String toId;
  final String readTime;
  final String sentTime;
  final Type type;
  final String message;

  const MessageModel({
    required this.fromId,
    required this.id,
    required this.chatId,
    required this.toId,
    required this.readTime,
    required this.sentTime,
    required this.type,
    required this.message,
  });

  Map<String, dynamic> toJson() => {
        "fromId": fromId,
        "id": id,
        "chatId": chatId,
        "toId": toId,
        "read_time": readTime,
        "sent_time": sentTime,
        "type": type.name,
        "message": message,
      };

  factory MessageModel.fromJson(dynamic data) {
    return MessageModel(
      fromId: data["fromId"],
      id: data["id"],
      chatId: data["chatId"],
      toId: data["toId"],
      readTime: data["read_time"],
      sentTime: data["sent_time"],
      type: data["type"].toString() == Type.image.name
          ? Type.image
          : data["type"].toString() == Type.video.name
              ? Type.video
              : Type.text,
      message: data["message"],
    );
  }
}

enum Type { text, image, video }
