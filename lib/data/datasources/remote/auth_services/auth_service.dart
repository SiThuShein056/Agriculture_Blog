part of 'authu_service_import.dart';

class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  User? currentUser;
  late String imageUrl;
  StreamSubscription? _streamSubscription;
  final StreamController<User?> _authStateController =
      StreamController.broadcast();
  Stream<User?> authState() => _authStateController.stream;
  Timer? _timer;
  AuthService()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn.standard() {
    _auth.currentUser?.reload();

    /// disitinct ka to nay yin maloke bu
    _streamSubscription = _auth.userChanges().distinct().listen((user) async {
      if (user == null) {
        _timer?.cancel();
        _timer = null;
        log("[User is null]");
      }
      _authStateController.sink.add(user);
      currentUser = user;
    });
  }
  Result? _isValid(String email, String password) {
    if (!email.isEmail) {
      return const Result(error: GeneralError("Email is invalid"));
    }

    final result = password.isStrongPassword();
    if (result != null) {
      return Result(error: GeneralError(result));
    }
    return null;
  }

  Future<Result> tried(Future<Result> Function() callback) async {
    try {
      final result = await callback();
      return result;
    } on FirebaseAuthException catch (e) {
      return Result(error: GeneralError(e.message.toString()));
    } on FirebaseException catch (e) {
      return Result(error: GeneralError(e.message.toString()));
    } on SocketException catch (e) {
      return Result(error: GeneralError(e.message.toString()));
    } catch (e) {
      return Result(error: GeneralError(e.toString()));
    }
  }

  Future<Result> register(
      String email, String password, String userName) async {
    return tried(() async {
      final validate = _isValid(email, password);
      if (validate != null) {
        return validate;
      }

      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await displayNameUpdate(userName);
      await FirebaseStoreDb().createUser(
          id: _auth.currentUser!.uid,
          name: _auth.currentUser!.displayName!,
          email: _auth.currentUser!.email.toString(),
          profileUrl: _auth.currentUser?.photoURL ?? "",
          coverUrl: "");

      return Result(data: credential.user);
    });
  }

  Future<Result> login(String email, String password) async {
    return tried(() async {
      final validate = _isValid(email, password);
      if (validate != null) {
        return validate;
      }
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await FirebaseStoreDb().createUser(
        id: _auth.currentUser!.uid,
        name: _auth.currentUser?.displayName.toString() ??
            _auth.currentUser!.email![0],
        email: _auth.currentUser!.email.toString(),
        profileUrl: _auth.currentUser?.photoURL ?? "",
        coverUrl: "",
      );
      await FirebaseStoreDb().checkUpdateMail(email);

      return Result(data: credential.user);
    });
  }

  String checkProvider() {
    String? provider;
    if (currentUser != null) {
      for (final providerProfile in currentUser!.providerData) {
        // ID of the provider (google.com, apple.cpm, etc.)
        provider = providerProfile.providerId;
      }
    }

    return provider!;
  }

  Future<Result> loginWithGoogle() async {
    final GoogleSignInAccount? result = await _googleSignIn.signIn();
    if (result == null) {
      return Result(
        error: GeneralError("Login Failed", StackTrace.current),
      );
    }
    final GoogleSignInAuthentication auth = await result.authentication;

    final credential = await _auth.signInWithCredential(
      GoogleAuthProvider.credential(accessToken: auth.accessToken),
    );

    await FirebaseStoreDb().createUser(
      id: _auth.currentUser!.uid,
      name: _auth.currentUser?.displayName.toString() ??
          _auth.currentUser!.email![1],
      email: _auth.currentUser!.email.toString(),
      profileUrl: _auth.currentUser?.photoURL ?? "",
      coverUrl: "",
    );

    await _googleSignIn.signOut();

    return Result(data: credential.user);
  }

  Future<Result> signOut() {
    return tried(() async {
      await _auth.signOut();

      return const Result();
    });
  }

  Future<Result> displayNameUpdate(String value) {
    return tried(() async {
      await _auth.currentUser?.updateDisplayName(value);
      await DatabaseUpdateService()
          .updateUserData(id: _auth.currentUser!.uid, name: value);
      return Result(data: value);
    });
  }

  Future<Result> gmailUpdate(
      {required String newMail, required String password}) {
    return tried(() async {
      if (currentUser == null) {
        return const Result(error: GeneralError("Please Login First"));
      }
      await currentUser!.reload();
      if (!currentUser!.emailVerified) {
        await currentUser!.sendEmailVerification();
        return const Result(error: GeneralError("Please Verify Email"));
      }
      var cred = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: password,
      );
      final value = await currentUser!.reauthenticateWithCredential(cred);
      await value.user!.verifyBeforeUpdateEmail(newMail);
      await value.user!.reload();
      _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
        log("[User reload]");
        await _auth.currentUser!.reload();
      });
      Future.delayed(const Duration(seconds: 240), () {
        log("[Timer Cancel]");

        _timer?.cancel();
        _timer = null;
      });
      return const Result(error: GeneralError("mailed changed"));
    });
  }

  // void runUntilEmailVerified(String newEmail) {
  //   Timer.periodic(const Duration(seconds: 5), (timer) async {
  //     log("[runUntilEmailVerified] ${timer.tick}");
  //     if (timer.tick > 60 * 30) {
  //       timer.cancel();
  //       return;
  //     }

  //     await currentUser!.reload();
  //     if (currentUser!.email == newEmail) {
  //       log("[database mail change]");
  //       FirebaseStoreDb().updateUserData(
  //           id: _auth.currentUser!.uid, email: currentUser!.email);
  //       timer.cancel();
  //     }
  //   });
  // }

  Future<Result> passwordUpdate(
      {required String oldPassword, required String newPassword}) {
    return tried(() async {
      var cred = EmailAuthProvider.credential(
          email: _auth.currentUser!.email!, password: oldPassword);

      await _auth.currentUser!.reauthenticateWithCredential(cred).then((value) {
        _auth.currentUser!.updatePassword(newPassword);
      });

      return Result(data: newPassword);
    });
  }

  Future<Result> updatePickProfilePhoto() async {
    return tried(() async {
      final userChoice = await StarlightUtils.dialog(AlertDialog(
        title: const Text("Choose Method"),
        content: SizedBox(
          height: 120,
          child: Column(children: [
            ListTile(
              onTap: () {
                StarlightUtils.pop(result: ImageSource.camera);
              },
              leading: const Icon(Icons.camera),
              title: const Text("Camera"),
            ),
            ListTile(
              onTap: () {
                StarlightUtils.pop(result: ImageSource.gallery);
              },
              leading: const Icon(Icons.image),
              title: const Text("Gallery"),
            )
          ]),
        ),
      ));
      if (userChoice == null) {
        return const Result(error: GeneralError("Not no choice"));
      }
      final XFile? image =
          await Injection<ImagePicker>().pickImage(source: userChoice);
      if (image == null) {
        return const Result(error: GeneralError("Image is null"));
      }
      final point = Injection<FirebaseStorage>().ref(
          "profile/${_auth.currentUser?.uid}/${DateTime.now().toString().replaceAll(" ", "")}/${image.name.split(".").last}");
      final uploaded = await point.putFile(image.path.file);

      await _auth.currentUser?.updatePhotoURL(uploaded.ref.fullPath);

      imageUrl = await Injection<FirebaseStorage>()
          .ref(uploaded.ref.fullPath)
          .getDownloadURL();
      log("image is $imageUrl");
      await DatabaseUpdateService()
          .updateUserData(id: currentUser!.uid, profileUrl: imageUrl);
      return Result(data: uploaded);
    });
  }

  Future<Result> pickCoverPhoto() async {
    return tried(() async {
      final userChoice = await StarlightUtils.dialog(AlertDialog(
        title: const Text("Choose Method"),
        content: SizedBox(
          height: 120,
          child: Column(children: [
            ListTile(
              onTap: () {
                StarlightUtils.pop(result: ImageSource.camera);
              },
              leading: const Icon(Icons.camera),
              title: const Text("Camera"),
            ),
            ListTile(
              onTap: () {
                StarlightUtils.pop(result: ImageSource.gallery);
              },
              leading: const Icon(Icons.image),
              title: const Text("Gallery"),
            )
          ]),
        ),
      ));
      if (userChoice == null) {
        return const Result(error: GeneralError("Not no choice"));
      }
      final XFile? image =
          await Injection<ImagePicker>().pickImage(source: userChoice);
      if (image == null) {
        return const Result(error: GeneralError("Image is null"));
      }
      final point = Injection<FirebaseStorage>().ref(
          "coverProfileImages/${_auth.currentUser?.uid}/${DateTime.now().toString().replaceAll(" ", "")}/${image.name.split(".").last}");
      final uploaded = await point.putFile(image.path.file);

      imageUrl = await Injection<FirebaseStorage>()
          .ref(uploaded.ref.fullPath)
          .getDownloadURL();
      await DatabaseUpdateService()
          .updateUserData(id: currentUser!.uid, coverUrl: imageUrl);
      return Result(data: uploaded);
    });
  }

  Future<Result> setOtp(String email) {
    return tried(() async {
      Injection<EmailOTP>().setConfig(
        otpType: OTPType.digitsOnly,
        otpLength: 6,
        userEmail: email,
        appEmail: "sithushein18112000@gmail.com",
        appName: "Blog_app",
      );

      if (await Injection<EmailOTP>().sendOTP() != true) {
        return const Result(error: GeneralError("Fail Sent Otp"));
      }
      return const Result();
    });
  }

  Future<Result> verifyOtp(String value, String email) {
    return tried(() async {
      if (await Injection<EmailOTP>().verifyOTP(otp: value.toString()) !=
          true) {
        return const Result(error: GeneralError("Invalid Otp"));
      }

      await _auth.sendPasswordResetEmail(email: email);

      return const Result();
    });
  }

  // Future<Result> registerVerifyOtp(
  //     String value, String name, String password, String email) {
  //   return tried(() async {
  //     if (await Injection<EmailOTP>().verifyOTP(otp: value.toString()) !=
  //         true) {
  //       return const Result(error: GeneralError("Invalid Otp"));
  //     }

  //     await register(email, password, name);
  //     return const Result();
  //   });
  // }

  dispose() {
    _streamSubscription?.cancel();
    _authStateController.close();
  }
}
