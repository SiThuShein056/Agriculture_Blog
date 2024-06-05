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

class UpdateUserInfoFailState extends UpdateUserInfoBaseState {
  String message;
  UpdateUserInfoFailState(this.message);
}
