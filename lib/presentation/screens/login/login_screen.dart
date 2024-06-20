part of 'login_import.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();
    void login() {
      loginBloc.add(const LoginSubmittedEvent());
      loginBloc.emailFocusNode.unfocus();
    }

    return Stack(
      children: [
        Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: loginBloc.formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) return "Need to fill";
                            return value.isEmail ? null : "Email need to valid";
                          },
                          controller: loginBloc.emailController,
                          focusNode: loginBloc.emailFocusNode,
                          onEditingComplete:
                              loginBloc.passwordFocusNode.requestFocus,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email_outlined),
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: "email",
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ValueListenableBuilder(
                                valueListenable: loginBloc.isShow,
                                builder: (_, value, state) {
                                  return TextFormField(
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return "Need to fill";
                                      }
                                      return text.isStrongPassword();
                                    },
                                    controller: loginBloc.passwordController,
                                    onEditingComplete: login,
                                    obscureText: value,
                                    keyboardType: TextInputType.text,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.lock_outline_rounded),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            loginBloc.toggle();
                                          },
                                          icon: !value
                                              ? const Icon(Icons.visibility)
                                              : const Icon(
                                                  Icons.visibility_off)),
                                      contentPadding: const EdgeInsets.all(10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      hintText: "password",
                                    ),
                                  );
                                })),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () {
                                  StarlightUtils.pushNamed(
                                      RouteNames.forgetPassword);
                                },
                                child: const Text("Forget Password")),
                            CustomOutlinedButton(
                                function: login, lable: "Login"),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: CustomOutlinedButton(
                              icon: Icons.login_outlined,
                              function: () {
                                loginBloc.add(const LoginWithGoogleEvent());
                              },
                              lable: "Login With Google"),
                        ),
                        // ElevatedButton(
                        //   onPressed: () async {
                        //     // await Injection<AuthService>().loginWithGoogle();
                        //   },
                        //   child: const Text(" Sign In with facebook"),
                        // ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("New User?"),
                            TextButton(
                                onPressed: () {
                                  StarlightUtils.pushNamed(
                                      RouteNames.registerScreen);
                                },
                                child: const Text("Sign Up"))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
        BlocConsumer<LoginBloc, LoginBaseState>(builder: (context, state) {
          if (state is LoginLoadingState) {
            log("UI login loading State");
            return Container(
              width: context.width,
              height: context.height,
              color: const Color.fromARGB(220, 2, 45, 58),
              child: Center(
                child: LoadingAnimationWidget.hexagonDots(
                  color: Colors.green,
                  size: 50,
                ),
              ),
            );
          }
          return const SizedBox();
        }, listener: (context, state) {
          if (state is LoginFailedState) {
            log("UI login fail State");

            StarlightUtils.dialog(
                DialogWidget(message: state.error, title: "Fail to Login"));
          }
          if (state is LoginSuccessState) {
            log("UI login success State");

            StarlightUtils.pushReplacementNamed(RouteNames.home);
          }
        }),
      ],
    );
  }
}
