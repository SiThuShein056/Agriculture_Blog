part of 'register_import.dart';

abstract class RegisterBaseState {
  const RegisterBaseState();
}

class RegisterInitialState extends RegisterBaseState {
  const RegisterInitialState();
}

class RegisterLoadingState extends RegisterBaseState {
  const RegisterLoadingState();
}

class RegisterFailState extends RegisterBaseState {
  final String error;
  RegisterFailState({required this.error});
}

class RegisterSuccessState extends RegisterBaseState {
  const RegisterSuccessState();
}
