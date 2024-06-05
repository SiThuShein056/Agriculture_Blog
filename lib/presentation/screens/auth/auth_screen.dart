part of 'auth_import.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  AuthViewModel authViewModel = AuthViewModel();

  @override
  Widget build(BuildContext context) {
    int? number;
    return Stack(
      children: [
        Scaffold(
          // resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  "AGB".text.bold.size(30).makeCentered(),
                  Expanded(
                    child: PageView(
                      controller: authViewModel.pageController,
                      onPageChanged: (value) {
                        number = value;
                        print(number);
                      },
                      children: const [
                        LoginWidget(),
                        RegisterWidget(),
                      ],
                    ),
                  ),
                  SmoothPageIndicator(
                      controller: authViewModel.pageController,
                      count: 2,
                      axisDirection: Axis.horizontal,
                      effect: const WormEffect())
                ],
              ),
            ),
          ),
        ),
        if (number == 0)
          BlocConsumer<LoginBloc, LoginBaseState>(builder: (context, state) {
            if (state is LoginLoadingState) {
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
            if (state is LoginFailedState) {
              StarlightUtils.dialog(
                  DialogWidget(message: state.error, title: "Fail to Login"));
            }
            if (state is LoginSuccessState) {
              StarlightUtils.pushReplacementNamed(RouteNames.home);
            }
          }),
        if (number == 1)
          BlocConsumer<RegisterBloc, RegisterBaseState>(
            listener: (_, state) {
              if (state is RegisterFailState) {
                StarlightUtils.dialog(DialogWidget(
                  message: state.error,
                  title: "Fail to Register",
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
