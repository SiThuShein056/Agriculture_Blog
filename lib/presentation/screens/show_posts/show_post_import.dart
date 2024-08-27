import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/conservation_crud_service/chat_create_service.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/firebase_store_db.dart';
import 'package:blog_app/data/models/notification_model/notification_model.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/data/models/savedPost_model/save_post_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/presentation/blocs/post_crud_bloc/create_post_cubit/post_create_cubit.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:blog_app/presentation/screens/show_posts/comment_part.dart';
import 'package:blog_app/presentation/screens/show_posts/like_part.dart';
import 'package:blog_app/presentation/screens/show_posts/profile/profile_import.dart';
import 'package:blog_app/presentation/screens/show_posts/search_user.dart';
import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../../data/datasources/local/utils/my_util.dart';
import '../../../injection.dart';
import '../../common_widgets/post_action_button.dart';
import 'search_post.dart';

part 'show_posts_screen.dart';
