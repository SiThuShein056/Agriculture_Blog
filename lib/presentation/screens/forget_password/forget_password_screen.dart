part of 'forget_password_import.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UpdateUserInfoBloc>();
    return Stack(
      children: [
        Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  child: Image.asset(
                    "assets/images/bg10.jpg",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                  top: 50,
                  left: 10,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          StarlightUtils.pop();
                        },
                        icon: const Icon(Icons.chevron_left_outlined),
                      ),
                      const Text(
                        "Forget-Password",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ).tr(),
                    ],
                  )),
              Positioned(
                top: 100,
                left: 20,
                right: 20,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Form(
                    key: bloc.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Forget-Password?",
                          style: TextStyle(fontSize: 17),
                        ).tr(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: const Text("Forget-Recommend").tr(),
                        ),
                        TextFormField(
                          controller: bloc.userDataController,
                          validator: (value) {
                            if (value == null) return "need to fill".tr();
                            return value.isEmail
                                ? null
                                : "Email-Is-Need-To-Validate".tr();
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
                              hintText: "Enter-Email".tr(),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: CustomOutlinedButton(
                              function: () {
                                bloc.add(const SentOTPEvent());
                              },
                              lable: "Sent-OTP".tr()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        BlocConsumer<UpdateUserInfoBloc, UpdateUserInfoBaseState>(
            builder: (context, state) {
          if (state is UpdateUserInfoLoadingState) {
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
          if (state is UpdateUserInfoFailState) {
            StarlightUtils.dialog(
              DialogWidget(
                  message: state.message.toString(),
                  title: "Fail to Sent OTP".tr()),
            );
          }

          if (state is UpdateUserInfoSuccessState) {
            StarlightUtils.pushNamed(RouteNames.forgetPasswordVerifyOtpScreen,
                arguments: bloc.userDataController.text);
          }
        }),
      ],
    );
  }
}
