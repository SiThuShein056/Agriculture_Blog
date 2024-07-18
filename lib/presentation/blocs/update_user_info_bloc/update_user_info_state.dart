part of 'update_user_info_import.dart';

abstract class UpdateUserInfoBaseState {
  UpdateUserInfoBaseState();
}

class UpdateUserInfoInitialState extends UpdateUserInfoBaseState {
  UpdateUserInfoInitialState();
}

class UpdateUserInfoLoadingState extends UpdateUserInfoBaseState {
  UpdateUserInfoLoadingState();
}

class UpdateUserInfoSuccessState extends UpdateUserInfoBaseState {
  UpdateUserInfoSuccessState();
}

class RegisterOTPSuccessState extends UpdateUserInfoBaseState {
  RegisterOTPSuccessState();
}

class UpdateUserInfoFailState extends UpdateUserInfoBaseState {
  String message;
  UpdateUserInfoFailState(this.message);
}
