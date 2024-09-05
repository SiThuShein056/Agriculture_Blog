import 'package:blog_app/presentation/blocs/register_bloc/register_import.dart';
import 'package:blog_app/presentation/common_widgets/custom_outlined_button.dart';
import 'package:blog_app/presentation/common_widgets/dialog_widget.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:starlight_utils/starlight_utils.dart';

class RegisterOtpVerifyScreen extends StatelessWidget {
  RegisterOtpVerifyScreen({
    super.key,
    required this.email,
  });
  String email;
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterBloc>();

    return Stack(
      children: [
        Scaffold(
          // appBar: AppBar(
          //   title: const Text('Otp Verify Screen').tr(),
          //   automaticallyImplyLeading: false,
          //   leading: IconButton(
          //       onPressed: () {
          //         Navigator.pop(context);
          //       },
          //       icon: const Icon(Icons.chevron_left)),
          // ),

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
                        'Otp Verify Screen',
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
        BlocConsumer<RegisterBloc, RegisterBaseState>(
            builder: (context, state) {
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
        }, listener: (context, state) {
          if (state is RegisterFailState) {
            StarlightUtils.dialog(DialogWidget(
              message: state.error,
              title: "Fail".tr(),
            ));
            return;
          } else if (state is RegisterSuccessState) {
            StarlightUtils.dialog(AlertDialog(
              title: const Text("Success").tr(),
              content: const Text("Mail verified successfully").tr(),
              actions: [
                TextButton(
                    onPressed: () {
                      StarlightUtils.pushReplacementNamed(
                          RouteNames.registerScreen,
                          arguments: email);
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
