part of 'login_import.dart';

class LoginBloc extends Bloc<LoginBaseEvent, LoginBaseState> {
  final AuthService _authService = Injection<AuthService>();
  LoginBloc() : super(const LoginInitialState()) {
    on<LoginSubmittedEvent>((event, emit) async {
      if (state is LoginLoadingState ||
          formKey?.currentState?.validate() != true) return;

      emit(const LoginLoadingState());
      log("Reach  Login Fail State");

      final result = await _authService.login(
          emailController.text, passwordController.text);

      if (result.hasError) {
        log("Reach  Login Fail State");

        return emit(LoginFailedState(result.error!.message));
      }

      emit(const LoginSuccessState());
      log("Reach Login Success State");
    });
    on<LoginWithGoogleEvent>((event, emit) async {
      if (state is LoginLoadingState) return;

      emit(const LoginLoadingState());
      final result = await _authService.loginWithGoogle();

      if (result.hasError) {
        return emit(LoginFailedState(result.error!.message));
      }
      emit(const LoginSuccessState());
    });
  }

  final TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode(), passwordFocusNode = FocusNode();
  final ValueNotifier<bool> isShow = ValueNotifier(false);
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  void toggle() {
    isShow.value = !isShow.value;
  }

  late int num = 0;

  @override
  Future<void> close() {
    formKey = null;
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    return super.close();
  }
}
