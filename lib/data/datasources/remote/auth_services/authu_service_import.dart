import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:blog_app/core/error/errors/error.dart';
import 'package:blog_app/core/error/results/result.dart';
import 'package:blog_app/injection.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:starlight_utils/starlight_utils.dart';

part 'auth_service.dart';
