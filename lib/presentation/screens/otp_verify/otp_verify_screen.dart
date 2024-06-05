part of 'otp_verify_import.dart';

class OtpVerifyScreen extends StatelessWidget {
  final String email;
  const OtpVerifyScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UpdateUserInfoBloc>();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Otp Verify Screen'),
          ),
          body: Column(
            children: [
              const Text(
                  'Enter verification code we just sent in your email address'),
              Pinput(
                length: 6,
                showCursor: true,
                onChanged: (v) {
                  bloc.value = v;
                },
              ),
              CustomOutliinedButton(
                  function: () {
                    bloc.userDataController.text = email;
                    log("Tapped button${bloc.userDataController.text}");

                    bloc.add(const VerifyOTPEvent());
                  },
                  lable: "Verify OTP")
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
              title: "Update Fail",
            ));
            return;
          } else if (state is UpdateUserInfoSuccessState) {
            log("Success");
            StarlightUtils.dialog(AlertDialog(
              title: const Text("Success"),
              content: const Text("We sent link to reset your password"),
              actions: [
                TextButton(
                    onPressed: () {
                      StarlightUtils.popAndPushNamed(RouteNames.loginScreen);
                    },
                    child: const Text("OK"))
              ],
            ));
          }
        }),
      ],
    );
  }
}
