import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/blocs/create_post_bloc/post_create_cubit.dart';
import 'package:blog_app/presentation/screens/admin/admin_dashboard.dart';
import 'package:blog_app/presentation/screens/admin/categories/create_category.dart';
import 'package:blog_app/presentation/screens/admin/categories/create_sub_category.dart';
import 'package:blog_app/presentation/screens/chat/singel_chat.dart';
import 'package:blog_app/presentation/screens/create_post/create_post_import.dart';
import 'package:blog_app/presentation/screens/noti/notification_screen.dart';
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
