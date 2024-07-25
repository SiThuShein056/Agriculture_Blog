import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/blocs/user_image_bloc/user_image_event.dart';
import 'package:blog_app/presentation/blocs/user_image_bloc/user_image_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserImageBloc extends Bloc<UserImageBaseEvent, UserImageBaseState> {
  final AuthService _auth = Injection<AuthService>();

  UserImageBloc() : super(const LoadingState()) {
    on<PickProfileEvent>((event, emit) async {
      if (state is LoadingState) return;
      emit(const LoadingState());
      final result = await _auth.updatePickProfilePhoto();

      if (result.hasError) {
        return emit(FailState(result.error!.message));
      }
      emit(const SuccessState());
    });
    on<PickCoverPhotoEvent>((event, emit) async {
      if (state is LoadingState) return;
      emit(const LoadingState());
      final result = await _auth.pickCoverPhoto();

      if (result.hasError) {
        return emit(FailState(result.error!.message));
      }
      emit(const SuccessState());
    });
  }
}
