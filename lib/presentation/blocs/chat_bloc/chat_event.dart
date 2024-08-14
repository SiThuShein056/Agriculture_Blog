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

class SentVideoCallLinkEvent extends ChatBaseEvent {
  final toId;
  SentVideoCallLinkEvent(
    this.toId,
  );
}

class SentVoiceCallLinkEvent extends ChatBaseEvent {
  final toId;
  SentVoiceCallLinkEvent(
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
