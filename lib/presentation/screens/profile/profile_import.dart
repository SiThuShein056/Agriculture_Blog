import 'dart:developer';

import 'package:blog_app/data/datasources/local/date_utils/my_date_util.dart';
import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/datasources/remote/db_service/firebase_store_db.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/common_widgets/custom_outlined_button.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../common_widgets/post_action_button.dart';
import '../show_posts/show_post_import.dart';

part 'profile_screen.dart';
