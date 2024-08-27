part of 'register_import.dart';

abstract class RegisterBaseEvent {
  const RegisterBaseEvent();
}

class SentOTPEvent extends RegisterBaseEvent {
  const SentOTPEvent();
}

class VerifyOTPEvent extends RegisterBaseEvent {
  const VerifyOTPEvent();
}

class OnRegisterSubmitted extends RegisterBaseEvent {
  const OnRegisterSubmitted();
}
