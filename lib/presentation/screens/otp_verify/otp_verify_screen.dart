part of 'otp_verify_import.dart';

class OtpVerifyScreen extends StatelessWidget {
  final String email;
  final bool isRegister;
  final String? password, name;
  const OtpVerifyScreen({
    super.key,
    required this.email,
    required this.isRegister,
    this.password,
    this.name,
  });

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
                        "Otp Verify Screen",
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter verification code we just sent in your email address',
                        style: TextStyle(fontSize: 18),
                      ).tr(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Pinput(
                          length: 6,
                          showCursor: true,
                          onChanged: (v) {
                            bloc.value = v;
                          },
                        ),
                      ),
                      CustomOutlinedButton(
                          function: () {
                            bloc.userDataController.text = email;

                            log("Tapped button${bloc.userDataController.text}");

                            bloc.add(const VerifyOTPEvent());
                          },
                          lable: "Verify OTP".tr())
                    ],
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
            log("Fail");
            StarlightUtils.dialog(DialogWidget(
              message: state.message,
              title: "Update Fail".tr(),
            ));
            return;
          } else if (state is UpdateUserInfoSuccessState) {
            log("Success");
            StarlightUtils.dialog(AlertDialog(
              title: const Text("Success").tr(),
              content: const Text("We sent link to reset your password").tr(),
              actions: [
                TextButton(
                    onPressed: () {
                      // StarlightUtils.popAndPushNamed(RouteNames.loginScreen);
                      StarlightUtils.pushReplacementNamed(
                          RouteNames.loginScreen);
                    },
                    child: const Text("OK").tr())
              ],
            ));
          }
        }),
      ],
    );
  }
}
