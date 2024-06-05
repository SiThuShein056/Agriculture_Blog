part of 'update_user_info_import.dart';

class UpdateUserInfoBloc
    extends Bloc<UpdateUserInfoBaseEvent, UpdateUserInfoBaseState> {
  UpdateUserInfoBloc() : super(UpdateUserInfoInitialState()) {
    on<UpdateUserNameChangeEvent>((event, emit) async {
      log("Name Changed Event");
      if (state is UpdateUserInfoLoadingState ||
          formKey?.currentState?.validate() != true) return;
      emit(UpdateUserInfoLoadingState());
      final result = await _auth.displayNameUpdate(userDataController.text);
      if (result.hasError) {
        emit(UpdateUserInfoFailState(result.error!.message));
        return;
      }

      emit(UpdateUserInfoSuccessState());
    });
    on<UpdateUserMailChangeEvent>((event, emit) async {
      log("Mail Changed Event");

      if (state is UpdateUserInfoLoadingState ||
          formKey?.currentState?.validate() != true) return;

      emit(UpdateUserInfoLoadingState());
      final result = await _auth.gmailUpdate(
          newMail: userDataController.text, password: passwordController.text);
      if (result.hasError) {
        emit(UpdateUserInfoFailState(result.error!.message.toString()));
        log(result.error!.message.toString());
        return;
      }

      emit(UpdateUserInfoSuccessState());
    });
    on<UpdateUserPasswordChangeEvent>((event, emit) async {
      log("Password Changed Event");
      if (state is UpdateUserInfoLoadingState ||
          formKey?.currentState?.validate() != true) return;

      emit(UpdateUserInfoLoadingState());
      final result = await _auth.passwordUpdate(
          oldPassword: passwordController.text,
          newPassword: userDataController.text);
      if (result.hasError) {
        emit(UpdateUserInfoFailState(result.error!.message.toString()));
        return;
      }

      emit(UpdateUserInfoSuccessState());
    });
    on<UpdateUserProfileChangeEvent>((event, emit) async {
      log("Profile Changed Event");
      if (state is UpdateUserInfoLoadingState ||
          formKey?.currentState?.validate() != true) return;
      emit(UpdateUserInfoLoadingState());
      final result = await _auth.updatePickCoverPhoto();
      if (result.hasError) {
        emit(UpdateUserInfoFailState(
          result.error!.message.toString(),
        ));
        return;
      }

      emit(UpdateUserInfoSuccessState());
    });
    on<SentOTPEvent>((event, emit) async {
      if (state is UpdateUserInfoLoadingState ||
          formKey?.currentState?.validate() != true) return;
      emit(UpdateUserInfoLoadingState());
      final result = await _auth.setOtp(userDataController.text);
      if (result.hasError) {
        return emit(UpdateUserInfoFailState(result.error!.message.toString()));
      }
      emit(UpdateUserInfoSuccessState());
    });

    on<VerifyOTPEvent>((event, state) async {
      log("verify event ${userDataController.text} is mail");

      if (state is UpdateUserInfoLoadingState) return;

      emit(UpdateUserInfoLoadingState());
      final result = await _auth.verifyOtp(value, userDataController.text);
      if (result.hasError) {
        return emit(UpdateUserInfoFailState(result.error!.message.toString()));
      }
      emit(UpdateUserInfoSuccessState());
    });
  }

  final _auth = Injection<AuthService>();
  final TextEditingController userDataController = TextEditingController(),
      passwordController = TextEditingController();
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  var value = "";

  @override
  Future<void> close() {
    userDataController.dispose();
    passwordController.dispose();
    formKey = null;
    return super.close();
  }
}
