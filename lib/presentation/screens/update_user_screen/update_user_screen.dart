part of 'update_user_import.dart';

class UpdateUserScreen extends StatelessWidget {
  final String title, label;
  final String? value;

  // final String? Function(String?)? validate;
  final bool isMailChanged, isPasswordChanged;
  const UpdateUserScreen({
    super.key,
    required this.title,
    required this.label,
    this.value,
    this.isMailChanged = false,
    this.isPasswordChanged = false,
    // required this.validate,
  }) : assert((!isMailChanged && isPasswordChanged) ||
            (isMailChanged && !isPasswordChanged) ||
            (!isMailChanged && !isPasswordChanged));

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UpdateUserInfoBloc>();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: const IconButton(
              onPressed: (StarlightUtils.pop),
              icon: Icon(Icons.chevron_left_outlined),
            ),
            title: Text(title),
          ),
          body: Form(
              key: bloc.formKey,
              child: Column(
                children: [
                  FormBox(
                      height: 105,
                      width: context.width,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) return "";
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: bloc.userDataController,
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
                            hintText: label,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      )),
                  if (isMailChanged || isPasswordChanged)
                    FormBox(
                      height: 105,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: context.width,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) return "";
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: bloc.passwordController,
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
                            hintText: "Enter old password to update".tr(),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color.fromRGBO(59, 170, 92, 1)),
                          ),
                          onPressed: () async {
                            if (isMailChanged) {
                              bloc.add(const UpdateUserMailChangeEvent());
                              return;
                            } else if (isPasswordChanged) {
                              bloc.add(const UpdateUserPasswordChangeEvent());
                              return;
                            } else {
                              bloc.add(const UpdateUserNameChangeEvent());

                              return;
                            }
                          },
                          icon: const Icon(Icons.update_outlined,
                              color: Color.fromRGBO(59, 170, 92, 1)),
                          label: const Text("Update").tr()),
                    ),
                  )
                ],
              )),
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
            if (state.message.contains("mailed changed")) {
              StarlightUtils.dialog(DialogWidget(
                message:
                    "You must need to verify your email and login again to update your mail"
                        .tr(),
                title: "Notification".tr(),
              ));
            } else {
              StarlightUtils.dialog(DialogWidget(
                message: state.message,
                title: "Update Fail".tr(),
              ));
            }
            return;
          } else if (state is UpdateUserInfoSuccessState) {
            log("Success");
            StarlightUtils.pop();
          }
        }),
      ],
    );
  }
}
