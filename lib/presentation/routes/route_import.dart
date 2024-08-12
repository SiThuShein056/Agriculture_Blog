import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/blocs/chat_bloc/chat_bloc.dart';
import 'package:blog_app/presentation/blocs/post_crud_bloc/create_post_cubit/post_create_cubit.dart';
import 'package:blog_app/presentation/blocs/post_crud_bloc/update_post_cubit/update_data_cubit.dart';
import 'package:blog_app/presentation/blocs/user_image_bloc/user_image_bloc.dart';
import 'package:blog_app/presentation/screens/about_screen/about_screen.dart';
import 'package:blog_app/presentation/screens/admin/admin_dashboard.dart';
import 'package:blog_app/presentation/screens/admin/create/create_category.dart';
import 'package:blog_app/presentation/screens/admin/create/create_sub_category.dart';
import 'package:blog_app/presentation/screens/admin/read/read_category.dart';
import 'package:blog_app/presentation/screens/admin/read/read_post.dart';
import 'package:blog_app/presentation/screens/admin/read/read_sub_category.dart';
import 'package:blog_app/presentation/screens/admin/read/read_user.dart';
import 'package:blog_app/presentation/screens/admin/read/user_control.dart';
import 'package:blog_app/presentation/screens/admin/update/update_category.dart';
import 'package:blog_app/presentation/screens/admin/update/update_post.dart';
import 'package:blog_app/presentation/screens/admin/update/update_sub_category.dart';
import 'package:blog_app/presentation/screens/chat/singel_chat.dart';
import 'package:blog_app/presentation/screens/create_post/create_post_import.dart';
import 'package:blog_app/presentation/screens/noti/notification_screen.dart';
import 'package:blog_app/presentation/screens/profile/image_view.dart';
import 'package:blog_app/presentation/screens/profile/profile_import.dart';
import 'package:blog_app/presentation/screens/setting/setting_import.dart';
import 'package:blog_app/presentation/screens/show_categories/show_categories.dart';
import 'package:blog_app/presentation/screens/show_categories/show_sub_category.dart';
import 'package:blog_app/presentation/screens/show_posts/post_detail.dart';
import 'package:blog_app/presentation/screens/splash/splash_import.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/remote/auth_services/authu_service_import.dart';
import '../blocs/home_bloc/home_import.dart';
import '../blocs/login_bloc/login_import.dart';
import '../blocs/navigation_bloc/navigation_import.dart';
import '../blocs/register_bloc/register_import.dart';
import '../blocs/update_user_info_bloc/update_user_info_import.dart';
import '../screens/forget_password/forget_password_import.dart';
import '../screens/home/home_import.dart';
import '../screens/login/login_import.dart';
import '../screens/otp_verify/otp_verify_import.dart';
import '../screens/register/register_import.dart';
import '../screens/update_user_screen/update_user_import.dart';

part 'route.dart';
