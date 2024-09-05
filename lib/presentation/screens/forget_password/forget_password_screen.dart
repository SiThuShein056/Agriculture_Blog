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
            title: const Text("Forget-Password").tr(),
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.chevron_left)),
          ),
          body: Form(
            key: bloc.formKey,
            child: FormBox(
              height: context.height,
              width: context.width,
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
