part of 'register_import.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterBloc registerBloc = context.read<RegisterBloc>();
    void register() {
      registerBloc.confirmPasswordFocus.unfocus();
      registerBloc.add(const OnRegisterSubmitted());
    }

    return Stack(
      children: [
        Scaffold(
          // resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Form(
              key: registerBloc.formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Image.asset(
                          "assets/images/platzi_store_logo.png",
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                    const Text(
                      "Welcome From Farmer Hub",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      "Please register to access your account",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 25,
                      ),
                      child: TextFormField(
                        controller: registerBloc.emailContrller,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onEditingComplete:
                            registerBloc.passWordFocus.requestFocus,
                        validator: (value) {
                          value = value ?? "";
                          if (value.isEmpty) return "Email is required";
                          return value.isEmail ? null : "Invalid email";
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter your email",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFormField(
                        controller: registerBloc.nameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // onEditingComplete:
                        //     registerBloc.passWordFocus.requestFocus,
                        validator: (value) {
                          value = value ?? "";
                          if (value.isEmpty) return "Name is required";
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter your Name",
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                        valueListenable: registerBloc.isShowPassowrd,
                        builder: (_, value, child) {
                          return TextFormField(
                            obscureText: !value,
                            controller: registerBloc.passwordController,
                            focusNode: registerBloc.passWordFocus,
                            onEditingComplete:
                                registerBloc.confirmPasswordFocus.requestFocus,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              value = value ?? "";
                              if (value.isEmpty) return "Password is required";
                              return value.isStrongPassword(
                                minLength: 6,
                                // checkSpecailChar: true,
                              );
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: registerBloc.passwordIsShowToggle,
                                  icon: Icon(
                                    value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  )),
                              hintText: "Enter your password",
                            ),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: ValueListenableBuilder(
                          valueListenable: registerBloc.isShowConfirmPassword,
                          builder: (_, value, child) {
                            return TextFormField(
                              obscureText: !value,
                              controller:
                                  registerBloc.confirmPasswordController,
                              focusNode: registerBloc.confirmPasswordFocus,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onEditingComplete: register,
                              validator: (value) {
                                value = value ?? "";
                                if (value.isEmpty) {
                                  return "Password is required";
                                }

                                final isStrongPassword = value.isStrongPassword(
                                  minLength: 6,
                                  // checkSpecailChar: false,
                                );

                                if (isStrongPassword != null) {
                                  return isStrongPassword;
                                }
                                if (value !=
                                    registerBloc.passwordController.text) {
                                  return "Password does not match.";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: registerBloc
                                        .confirmPasswordIsShowToggle,
                                    icon: Icon(
                                      value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    )),
                                hintText: "Enter your confirm password",
                              ),
                            );
                          }),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     TextButton(
                    //         onPressed: () {},
                    //         child: const Text("Suggest Password")),
                    //     CustomOutlinedButton(
                    //         function: register, lable: "Register"),
                    //   ],
                    // ),
                    CustomOutlinedButton(function: register, lable: "Register"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        TextButton(
                            onPressed: () {
                              StarlightUtils.pushReplacementNamed(
                                  RouteNames.loginScreen);
                            },
                            child: const Text("Sign In"))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        BlocConsumer<RegisterBloc, RegisterBaseState>(
          listener: (_, state) {
            if (state is RegisterFailState) {
              StarlightUtils.dialog(DialogWidget(
                message: state.error,
                title: "Fail Action",
              ));
            }
            if (state is RegisterSuccessState) {
              StarlightUtils.pushReplacementNamed(RouteNames.home);
            }
          },
          builder: (_, state) {
            if (state is RegisterLoadingState) {
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
          },
        ),
      ],
    );
  }
}
