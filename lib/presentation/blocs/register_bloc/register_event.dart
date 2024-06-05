part of 'register_import.dart';

abstract class RegisterBaseEvent {
  const RegisterBaseEvent();
}

class OnRegisterSubmitted extends RegisterBaseEvent {
  const OnRegisterSubmitted();
}
