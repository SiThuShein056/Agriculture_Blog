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
  final callID;
  SentVideoCallLinkEvent(
    this.toId,
    this.callID,
  );
}

class SentVoiceCallLinkEvent extends ChatBaseEvent {
  final toId;
  final callID;
  SentVoiceCallLinkEvent(
    this.toId,
    this.callID,
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

class SaveImageEvent extends ChatBaseEvent {
  final url;

  const SaveImageEvent(this.url);
}

class SaveVideoEvent extends ChatBaseEvent {
  final url;
  const SaveVideoEvent(this.url);
}
