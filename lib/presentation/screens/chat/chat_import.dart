import 'package:blog_app/data/datasources/local/utils/my_util.dart';
import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/conservation_crud_service/chat_create_service.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/conservation_crud_service/chat_delete_service.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/conservation_crud_service/chat_read_service.dart';
import 'package:blog_app/data/models/chat_model/chat_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:blog_app/injection.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:blog_app/presentation/screens/chat/search_chat_user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../../data/datasources/remote/db_crud_service/db_update_service.dart/db_read_service.dart';
import '../../../data/models/message_model/message_model.dart';

part 'chat_screen.dart';
