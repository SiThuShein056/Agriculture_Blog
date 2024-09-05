import 'package:blog_app/presentation/blocs/register_bloc/register_import.dart';
import 'package:blog_app/presentation/common_widgets/custom_outlined_button.dart';
import 'package:blog_app/presentation/common_widgets/dialog_widget.dart';
import 'package:blog_app/presentation/common_widgets/form_widget.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:starlight_utils/starlight_utils.dart';

class RegisterSentOTPScreen extends StatelessWidget {
  const RegisterSentOTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterBloc>();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Register OTP").tr(),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: const Text(
                            "Pleae Enter Email Address to Verify firstly")
                        .tr(),
                  ),
                  TextFormField(
                    controller: bloc.emailContrller,
                    validator: (value) {
                      if (value == null) return "need to fill".tr();
                      return value.isEmail
                          ? null
                          : "Email-Is-Need-To-Validate".tr();
                    },
                    decoration: InputDecoration(
                        hintText: "Enter-Email".tr(),
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
            StarlightUtils.dialog(
              DialogWidget(
                  message: state.error.toString(),
                  title: "Fail to Sent OTP".tr()),
            );
          }

          if (state is RegisterSuccessState) {
            StarlightUtils.pushNamed(RouteNames.registerVerifyOTPScreen,
                arguments: bloc.emailContrller.text);
          }
        }),
      ],
    );
  }
}
