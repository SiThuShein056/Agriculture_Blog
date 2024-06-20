import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/remote/auth_services/authu_service_import.dart';
import 'firebase_options.dart';

final Injection = GetIt.asNewInstance();
Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Injection.registerSingleton(AuthService(), dispose: (instance) {
    instance.dispose();
  });

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  Injection.registerLazySingleton(() => prefs);
  Injection.registerLazySingleton<FirebaseStorage>(
      () => FirebaseStorage.instance);
  Injection.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  Injection.registerLazySingleton<ImagePicker>(() => ImagePicker());
  Injection.registerLazySingleton<EmailOTP>(() => EmailOTP());
}
