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

  AuthService()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn.standard() {
    _streamSubscription = _auth.userChanges().listen((user) {
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

  Future<Result> _try(Future<Result> Function() callback) async {
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

  Future<Result> register(String email, String password) async {
    return _try(() async {
      final validate = _isValid(email, password);
      if (validate != null) {
        return validate;
      }

      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseStoreDb().createUser(
        id: _auth.currentUser!.uid,
        name: _auth.currentUser?.displayName.toString() ??
            _auth.currentUser!.email![0],
        email: _auth.currentUser!.email.toString(),
        profileUrl: _auth.currentUser?.photoURL ?? "",
      );
      return Result(data: credential.user);
    });
  }

  Future<Result> login(String email, String password) async {
    return _try(() async {
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
      );
      return Result(data: credential.user);
    });
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
    );

    return Result(data: credential.user);
  }

  // Future<Result> forgetPassword(String email) {
  //   return _try(() async {
  //     await _auth.sendPasswordResetEmail(email: email);
  //     return const Result();
  //   });
  // }

  Future<Result> signOut() {
    return _try(() async {
      await _auth.signOut();
      await _googleSignIn.signOut();

      // await _streamSubscription?.cancel();
      return const Result();
    });
  }

  Future<Result> displayNameUpdate(String value) {
    return _try(() async {
      await _auth.currentUser?.updateDisplayName(value);
      await FirebaseStoreDb()
          .updateUserData(id: _auth.currentUser!.uid, name: value);
      return Result(data: value);
    });
  }

  Future<Result> gmailUpdate(
      {required String newMail, required String password}) {
    return _try(() async {
      var cred = EmailAuthProvider.credential(
          email: _auth.currentUser!.email!, password: password);
      await currentUser!.reauthenticateWithCredential(cred).then((value) async {
        await currentUser!.verifyBeforeUpdateEmail(newMail).then((v) =>
            FirebaseStoreDb()
                .updateUserData(id: _auth.currentUser!.uid, email: newMail));
      });
      return const Result();
    });
  }

  Future<Result> passwordUpdate(
      {required String oldPassword, required String newPassword}) {
    return _try(() async {
      var cred = EmailAuthProvider.credential(
          email: _auth.currentUser!.email!, password: oldPassword);

      await _auth.currentUser!.reauthenticateWithCredential(cred).then((value) {
        _auth.currentUser!.updatePassword(newPassword);
      });

      return Result(data: newPassword);
    });
  }

  Future<Result> updatePickCoverPhoto() async {
    return _try(() async {
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
      await FirebaseStoreDb()
          .updateUserData(id: currentUser!.uid, profileUrl: imageUrl);
      return Result(data: uploaded);
    });
  }

  Future<Result> setOtp(String email) {
    return _try(() async {
      Injection<EmailOTP>().setConfig(
        otpType: OTPType.digitsOnly,
        otpLength: 6,
        userEmail: email,
        appEmail: "sithushein18112000@gmail.com",
        appName: "blog_app",
      );

      if (await Injection<EmailOTP>().sendOTP() != true) {
        return const Result(error: GeneralError("Fail Sent Otp"));
      }
      return const Result();
    });
  }

  Future<Result> verifyOtp(String value, String email) {
    return _try(() async {
      if (await Injection<EmailOTP>().verifyOTP(otp: value.toString()) !=
          true) {
        return const Result(error: GeneralError("Invalid Otp"));
      }

      await _auth.sendPasswordResetEmail(email: email);

      return const Result();
    });
  }

  dispose() {
    _streamSubscription?.cancel();
    _authStateController.close();
  }
}
