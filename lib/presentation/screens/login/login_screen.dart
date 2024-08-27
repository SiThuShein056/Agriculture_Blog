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
            // resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
          child: Form(
            key: loginBloc.formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            AssetImage("assets/app_logo/logo1.png"),
                      ),
                    ),
                  ),
                  const Text(
                    "Glad-To-See-You",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ).tr(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: const Text(
                      "Please-login-to-access-your-account",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ).tr(),
                  ),

                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) return "Need-To-Fill".tr();
                      return value.isEmail ? null : "Email need to valid".tr();
                    },
                    controller: loginBloc.emailController,
                    focusNode: loginBloc.emailFocusNode,
                    onEditingComplete: loginBloc.passwordFocusNode.requestFocus,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: "Email".tr(),
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
                                  return "Need-To-Fill".tr();
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
                                prefixIcon:
                                    const Icon(Icons.lock_outline_rounded),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      loginBloc.toggle();
                                    },
                                    icon: !value
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off)),
                                contentPadding: const EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                hintText: "Password".tr(),
                              ),
                            );
                          })),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            StarlightUtils.pushNamed(
                                RouteNames.forgetPasswordSentOTPScreen);
                          },
                          child: const Text("Forget-Password").tr()),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: login,
                          child: const Text("Login").tr(),
                        ),
                      ),
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
                        lable: "Login-With-Google".tr()),
                  ),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     // await Injection<AuthService>().loginWithGoogle();
                  //   },
                  //   child: const Text(" Sign In with facebook"),
                  // ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("New-User?").tr(),
                        TextButton(
                            onPressed: () {
                              // StarlightUtils.pushReplacementNamed(
                              //     RouteNames.registerScreen);
                              StarlightUtils.pushNamed(
                                  RouteNames.registerSentOTPScreen);
                            },
                            child: const Text("Sign-Up").tr())
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
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

            StarlightUtils.dialog(DialogWidget(
                message: state.error, title: "Fail to Login".tr()));
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
