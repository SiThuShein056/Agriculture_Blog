part of 'forget_password_import.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UpdateUserInfoBloc>();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Forget Password Screen"),
          ),
          body: Form(
            key: bloc.formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Forget Password?"),
                  const Text(
                      "Dont't worry about that.Please enter your email adderss linked your account"),
                  TextFormField(
                    controller: bloc.userDataController,
                    validator: (value) {
                      if (value == null) return "need to fill";
                      return value.isEmail ? null : "Email is need to validate";
                    },
                    decoration: InputDecoration(
                        hintText: "Enter email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  CustomOutlinedButton(
                      function: () {
                        bloc.add(const SentOTPEvent());
                      },
                      lable: "Sent OTP"),
                ],
              ),
            ),
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
            StarlightUtils.dialog(DialogWidget(
                message: state.message.toString(), title: "Fail to Login"));
          }
          if (state is UpdateUserInfoSuccessState) {
            StarlightUtils.pushReplacementNamed(RouteNames.verifyOtpScreen,
                arguments: bloc.userDataController.text);
          }
        }),
      ],
    );
  }
}
