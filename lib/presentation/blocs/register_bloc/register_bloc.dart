part of 'register_import.dart';

class RegisterBloc extends Bloc<RegisterBaseEvent, RegisterBaseState> {
  final AuthService _auth = Injection<AuthService>();
  RegisterBloc() : super(const RegisterInitialState()) {
    on<OnRegisterSubmitted>((event, emit) async {
      if (state is RegisterLoadingState ||
          formKey?.currentState?.validate() != true) return;

      emit(const RegisterLoadingState());

      final result = await _auth.register(
        emailContrller.text,
        confirmPasswordController.text,
        nameController.text,
      );

      if (result.hasError) {
        return emit(RegisterFailState(error: result.error!.message.toString()));
      }

      emit(const RegisterSuccessState());
    });

    on<SentOTPEvent>((event, emit) async {
      if (state is RegisterLoadingState ||
          formKey?.currentState?.validate() != true) return;
      emit(const RegisterLoadingState());
      log("OTP SENT TO EMAIL ${emailContrller.text}");
      final result = await _auth.setOtp(emailContrller.text);
      if (result.hasError) {
        return emit(RegisterFailState(error: result.error!.message.toString()));
      }
      emit(const RegisterSuccessState());
    });

    on<VerifyOTPEvent>((event, state) async {
      if (state is RegisterLoadingState) return;

      emit(const RegisterLoadingState());

      final result = await _auth.registerVerifyOtp(value);
      if (result.hasError) {
        return emit(RegisterFailState(error: result.error!.message.toString()));
      }
      emit(const RegisterSuccessState());
    });
  }

  GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  final TextEditingController emailContrller = TextEditingController(),
      passwordController = TextEditingController(),
      nameController = TextEditingController(),
      confirmPasswordController = TextEditingController();
  var value = "";

  final FocusNode emailFocus = FocusNode(),
      passWordFocus = FocusNode(),
      confirmPasswordFocus = FocusNode();
  ValueNotifier isShowPassowrd = ValueNotifier(false),
      isShowConfirmPassword = ValueNotifier(false);
  void passwordIsShowToggle() {
    isShowPassowrd.value = !isShowPassowrd.value;
  }

  void confirmPasswordIsShowToggle() {
    isShowConfirmPassword.value = !isShowConfirmPassword.value;
  }

  @override
  Future<void> close() {
    formKey = null;
    emailContrller.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();

    emailFocus.dispose();
    passWordFocus.dispose();
    confirmPasswordFocus.dispose();

    isShowConfirmPassword.dispose();
    isShowPassowrd.dispose();

    return super.close();
  }
}
