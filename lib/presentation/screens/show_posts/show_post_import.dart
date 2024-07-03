import 'dart:developer';

import 'package:blog_app/data/datasources/local/date_utils/my_date_util.dart';
import 'package:blog_app/data/datasources/remote/db_service/firebase_store_db.dart';
import 'package:blog_app/data/models/like_model/like_model.dart';
import 'package:blog_app/data/models/notification_model/notification_model.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/presentation/blocs/create_post_bloc/post_create_cubit.dart';
import 'package:blog_app/presentation/blocs/home_bloc/home_import.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:blog_app/presentation/screens/show_posts/comment_part.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../common_widgets/post_action_button.dart';
import 'search_post.dart';

part 'show_posts_screen.dart';
