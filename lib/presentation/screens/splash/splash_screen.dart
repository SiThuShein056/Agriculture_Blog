part of 'splash_import.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    moveToHome();
    super.initState();
  }

  moveToHome() async {
    await Future.delayed(const Duration(seconds: 5), () async {
      StarlightUtils.pushReplacementNamed(RouteNames.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: const Center(
        child: CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage("assets/app_logo/logo1.png"),
        ),
      ),
    );
  }
}
