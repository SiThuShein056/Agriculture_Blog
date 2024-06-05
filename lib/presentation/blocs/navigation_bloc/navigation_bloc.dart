part of 'navigation_import.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc(super.initialState) {
    on<NavigationEvent>((event, emit) {
      emit(NavigationState(event.i));
    });
  }
}
