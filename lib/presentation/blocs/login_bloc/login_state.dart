part of 'login_import.dart';

abstract class LoginBaseState {
  const LoginBaseState();
}

class LoginInitialState extends LoginBaseState {
  const LoginInitialState();
}

class LoginLoadingState extends LoginBaseState {
  const LoginLoadingState();
}

class LoginFailedState extends LoginBaseState {
  String error;
  LoginFailedState(this.error);
}

class LoginSuccessState extends LoginBaseState {
  const LoginSuccessState();
}
