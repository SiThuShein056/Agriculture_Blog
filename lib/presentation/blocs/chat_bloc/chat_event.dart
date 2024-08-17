import 'package:blog_app/data/models/user_model/user_model.dart';

abstract class ChatBaseEvent {
  const ChatBaseEvent();
}

class SentTextMessageEvent extends ChatBaseEvent {
  final UserModel user;
  SentTextMessageEvent(
    this.user,
  );
}

class SentFileImageMessageEvent extends ChatBaseEvent {
  final UserModel user;
  SentFileImageMessageEvent(
    this.user,
  );
}

class SentVideoCallLinkEvent extends ChatBaseEvent {
  final UserModel user;
  final callID;
  SentVideoCallLinkEvent(
    this.user,
    this.callID,
  );
}

class SentVoiceCallLinkEvent extends ChatBaseEvent {
  final UserModel user;
  final callID;
  SentVoiceCallLinkEvent(
    this.user,
    this.callID,
  );
}

class SentVideoMessageEvent extends ChatBaseEvent {
  final UserModel user;
  SentVideoMessageEvent(
    this.user,
  );
}

class SentCameraImageMessageEvent extends ChatBaseEvent {
  final UserModel user;
  SentCameraImageMessageEvent(
    this.user,
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
