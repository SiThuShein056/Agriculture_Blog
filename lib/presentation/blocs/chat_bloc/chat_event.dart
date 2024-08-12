abstract class ChatBaseEvent {
  const ChatBaseEvent();
}

class SentTextMessageEvent extends ChatBaseEvent {
  final toId;
  SentTextMessageEvent(
    this.toId,
  );
}

class SentFileImageMessageEvent extends ChatBaseEvent {
  final toId;
  SentFileImageMessageEvent(
    this.toId,
  );
}

class SentVideoMessageEvent extends ChatBaseEvent {
  final toId;
  SentVideoMessageEvent(
    this.toId,
  );
}

class SentCameraImageMessageEvent extends ChatBaseEvent {
  final toId;
  SentCameraImageMessageEvent(
    this.toId,
  );
}

class ReadMessageEvent extends ChatBaseEvent {
  ReadMessageEvent();
}
