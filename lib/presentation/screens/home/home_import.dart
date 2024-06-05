import 'dart:developer';

import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/common_widgets/reuse_list_tile_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../blocs/home_bloc/home_import.dart';
import '../../blocs/navigation_bloc/navigation_import.dart';
import '../../routes/route_import.dart';
import '../chat/chat_import.dart';
import '../create_post/create_post_import.dart';
import '../search/search_import.dart';
import '../show_posts/show_post_import.dart';

part 'bottom_nav_widget.dart';
part 'drawer_widget.dart';
part 'home_screen.dart';