part of 'navigation_import.dart';

class NavigationState {
  final int i;
  const NavigationState(this.i);
  @override
  operator ==(covariant NavigationState other) {
    return other.i == i;
  }

  @override
  int get hashCode => i;
}
