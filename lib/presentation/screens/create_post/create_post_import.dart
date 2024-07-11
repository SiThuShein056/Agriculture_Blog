import 'dart:developer';

import 'package:blog_app/presentation/blocs/db_crud_bloc/create_post_cubit/post_create_cubit.dart';
import 'package:blog_app/presentation/blocs/db_crud_bloc/create_post_cubit/post_create_state.dart';
import 'package:blog_app/presentation/common_widgets/custom_outlined_button.dart';
import 'package:blog_app/presentation/common_widgets/form_widget.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../blocs/db_crud_bloc/db_update_cubit/update_data_cubit.dart';

part 'create_post_screen.dart';
