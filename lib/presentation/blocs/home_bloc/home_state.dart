part of 'home_import.dart';

abstract class HomeBaseState {
  final User? user;
  const HomeBaseState(this.user);
}

class HomeInitialState extends HomeBaseState {
  const HomeInitialState(super.user);
}

// class HomeLoadingState extends HomeBaseState {
//   const HomeLoadingState(super.user);
// }

// class HomeErrorState extends HomeBaseState {
//   const HomeErrorState(super.user);
// }

// class HomeSuccessState extends HomeBaseState {
//   const HomeSuccessState(super.user);
// }

class HomeUserChangeState extends HomeBaseState {
  const HomeUserChangeState(super.user);
}

class HomeUserSignOutState extends HomeBaseState {
  const HomeUserSignOutState([super.user]);
}
