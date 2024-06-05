part of 'home_import.dart';

abstract class HomeBaseEvent {
  const HomeBaseEvent();
}

class HomeUserChangeEvent extends HomeBaseEvent {
  final User user;
  const HomeUserChangeEvent(this.user);
}

class HomeUserSignOutEvent extends HomeBaseEvent {
  const HomeUserSignOutEvent();
}
