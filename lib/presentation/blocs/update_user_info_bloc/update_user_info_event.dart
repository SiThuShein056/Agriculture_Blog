part of 'update_user_info_import.dart';

abstract class UpdateUserInfoBaseEvent {
  const UpdateUserInfoBaseEvent();
}

class UpdateUserNameChangeEvent extends UpdateUserInfoBaseEvent {
  const UpdateUserNameChangeEvent();
}

class UpdateUserMailChangeEvent extends UpdateUserInfoBaseEvent {
  const UpdateUserMailChangeEvent();
}

class UpdateUserPasswordChangeEvent extends UpdateUserInfoBaseEvent {
  const UpdateUserPasswordChangeEvent();
}

class UpdateUserProfileChangeEvent extends UpdateUserInfoBaseEvent {
  const UpdateUserProfileChangeEvent();
}

class SentOTPEvent extends UpdateUserInfoBaseEvent {
  const SentOTPEvent();
}

class VerifyOTPEvent extends UpdateUserInfoBaseEvent {
  const VerifyOTPEvent();
}
