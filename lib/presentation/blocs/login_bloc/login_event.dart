part of 'login_import.dart';

abstract class LoginBaseEvent {
  const LoginBaseEvent();
}

class LoginSubmittedEvent extends LoginBaseEvent {
  const LoginSubmittedEvent();
}

class LoginWithGoogleEvent extends LoginBaseEvent {
  const LoginWithGoogleEvent();
}
