import 'dart:developer';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/blocs/theme_cubit/theme_cubit_import.dart';
import 'package:blog_app/presentation/common_widgets/reuse_list_tile_widget.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../../data/datasources/remote/auth_services/authu_service_import.dart';
import '../../blocs/home_bloc/home_import.dart';

part 'setting_screen.dart';
