import 'dart:developer';

import 'package:blog_app/data/datasources/local/utils/my_util.dart';
import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/conservation_crud_service/chat_create_service.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/db_update_service.dart/db_read_service.dart';
import 'package:blog_app/data/models/post_Images_model/post_image_model.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/blocs/post_crud_bloc/create_post_cubit/post_create_cubit.dart';
import 'package:blog_app/presentation/common_widgets/post_action_button.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:blog_app/presentation/screens/show_posts/comment_part.dart';
import 'package:blog_app/presentation/screens/show_posts/like_part.dart';
import 'package:blog_app/presentation/screens/show_posts/profile/profile_import.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:velocity_x/velocity_x.dart';

part 'save_post_screen.dart';
