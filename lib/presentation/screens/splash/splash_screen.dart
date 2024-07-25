part of 'splash_import.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // checkPermission();
    moveToHome();
    super.initState();
  }

  moveToHome() async {
    await Future.delayed(const Duration(seconds: 5), () async {
      StarlightUtils.pushReplacementNamed(RouteNames.home);
    });
  }

  // checkPermission() async {
  //   Location location = new Location();

  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //   LocationData _locationData;

  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   _locationData = await location.getLocation();
  //   if (_locationData.latitude != null && _locationData.longitude != null) {
  //     // setState(() {
  //     //   UserLocation.lat = _locationData.latitude!;
  //     //   UserLocation.log = _locationData.longitude!;
  //     // });

  //     AddressProvider()
  //         .changeLatLog(_locationData.latitude!, _locationData.longitude!);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadedScaleAnimation(
          child: Image.asset(
            "assets/images/platzi_store_logo.png",
            height: 80,
            width: 80,
          ),
        ),
      ),
    );
  }
}
