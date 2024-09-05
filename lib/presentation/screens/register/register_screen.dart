part of 'register_import.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({required this.email, super.key});

  String email;

  @override
  Widget build(BuildContext context) {
    final RegisterBloc registerBloc = context.read<RegisterBloc>();
    registerBloc.emailContrller.text = email;
    void register() {
      registerBloc.confirmPasswordFocus.unfocus();
      registerBloc.add(const OnRegisterSubmitted());
    }

    return Stack(
      children: [
        Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  child: Image.asset(
                    "assets/images/bg9.jpg",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                top: 100,
                left: 20,
                right: 20,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Form(
                    key: registerBloc.formKey,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 30.0),
                          child: Center(
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage:
                                  AssetImage("assets/app_logo/logo1.png"),
                            ),
                          ),
                        ),
                        const Text(
                          "Welcome-From-Farmer-Hub",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ).tr(),
                        const Text(
                          "Please-Register-To-Access-Your-Account",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ).tr(),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 25,
                          ),
                          child: TextFormField(
                            readOnly: true,
                            controller: registerBloc.emailContrller,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onEditingComplete:
                                registerBloc.passWordFocus.requestFocus,
                            validator: (value) {
                              value = value ?? "";
                              if (value.isEmpty) {
                                return "Email-Is-Required".tr();
                              }
                              return value.isEmail
                                  ? null
                                  : "Invalid email".tr();
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(59, 170, 92, 1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(59, 170, 92, 1),
                                ),
                              ),
                              hintText: "Enter-Your-Email".tr(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: TextFormField(
                            controller: registerBloc.nameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            // onEditingComplete:
                            //     registerBloc.passWordFocus.requestFocus,
                            validator: (value) {
                              value = value ?? "";
                              if (value.isEmpty) {
                                return "Name-Is-Required".tr();
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(59, 170, 92, 1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(59, 170, 92, 1),
                                ),
                              ),
                              hintText: "Enter-Your-Name".tr(),
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
                                onEditingComplete: registerBloc
                                    .confirmPasswordFocus.requestFocus,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  value = value ?? "";
                                  if (value.isEmpty) {
                                    return "Password-Is-Required".tr();
                                  }
                                  return value.isStrongPassword(
                                    minLength: 6,
                                    // checkSpecailChar: true,
                                  );
                                },
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(59, 170, 92, 1),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(59, 170, 92, 1),
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed:
                                          registerBloc.passwordIsShowToggle,
                                      icon: Icon(
                                        value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      )),
                                  hintText: "Enter-Your-Password".tr(),
                                ),
                              );
                            }),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: ValueListenableBuilder(
                              valueListenable:
                                  registerBloc.isShowConfirmPassword,
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
                                      return "Password-Is-Required".tr();
                                    }

                                    final isStrongPassword =
                                        value.isStrongPassword(
                                      minLength: 6,
                                      // checkSpecailChar: false,
                                    );

                                    if (isStrongPassword != null) {
                                      return isStrongPassword;
                                    }
                                    if (value !=
                                        registerBloc.passwordController.text) {
                                      return "Confirm-Password-Is-Required"
                                          .tr();
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color.fromRGBO(59, 170, 92, 1),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color.fromRGBO(59, 170, 92, 1),
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                        onPressed: registerBloc
                                            .confirmPasswordIsShowToggle,
                                        icon: Icon(
                                          value
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        )),
                                    hintText:
                                        "Enter-Your-Confirm-Password".tr(),
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
                        CustomOutlinedButton(
                            function: register, lable: "Register".tr()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already-Have-An-Account?-").tr(),
                            TextButton(
                                onPressed: () {
                                  StarlightUtils.pushReplacementNamed(
                                      RouteNames.loginScreen);
                                },
                                child: const Text("Sign-IN").tr())
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        BlocConsumer<RegisterBloc, RegisterBaseState>(
          listener: (_, state) {
            if (state is RegisterFailState) {
              StarlightUtils.dialog(DialogWidget(
                message: state.error,
                title: "Fail Action".tr(),
              ));
            }
            if (state is RegisterSuccessState) {
              // StarlightUtils.pushReplacementNamed(RouteNames.home);
              StarlightUtils.pushReplacementNamed(RouteNames.loginScreen);
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
