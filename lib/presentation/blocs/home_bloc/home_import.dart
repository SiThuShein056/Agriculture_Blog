import 'dart:async';

import 'package:blog_app/data/models/category_model/category_model.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/remote/auth_services/authu_service_import.dart';

part 'home_bloc.dart';
part 'home_event.dart';
part 'home_state.dart';
