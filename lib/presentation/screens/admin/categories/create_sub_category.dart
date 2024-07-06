import 'dart:developer';

import 'package:blog_app/presentation/blocs/create_post_bloc/post_create_cubit.dart';
import 'package:blog_app/presentation/blocs/create_post_bloc/post_create_state.dart';
import 'package:blog_app/presentation/common_widgets/custom_outlined_button.dart';
import 'package:blog_app/presentation/common_widgets/form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateSubCategory extends StatelessWidget {
  const CreateSubCategory({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final postCreateBloc = context.read<CreateCubit>();
    String id = ModalRoute.of(context)!.settings.arguments as String;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Create SubCateory"),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomOutlinedButton(
                  function: () async {
                    postCreateBloc.createSubCategory(id);
                    log("message");
                  },
                  lable: "Create",
                  icon: Icons.post_add_outlined,
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormBox(
              padding: const EdgeInsets.all(0),
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 15, right: 8),
                child: Form(
                  key: postCreateBloc.formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) return "";
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: postCreateBloc.categoryController,
                    decoration: InputDecoration(
                      hintText: "Enter SubCategory",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        BlocConsumer<CreateCubit, CreateState>(builder: (context, state) {
          if (state is CreateLoadingState) {
            return Container(
              width: context.width,
              height: context.height,
              color: const Color.fromARGB(220, 2, 45, 58),
              child: Center(
                child: LoadingAnimationWidget.hexagonDots(
                  color: Colors.green,
                  size: 50,
                ),
              ),
            );
          }
          return const SizedBox();
        }, listener: (context, state) {
          if (state is CreateErrorState) {
            StarlightUtils.snackbar(const SnackBar(
              content: Text("Fail Create"),
            ));
          }
          if (state is CreateSuccessState) {
            StarlightUtils.snackbar(const SnackBar(
              content: Text("Success Create"),
            ));
            StarlightUtils.pop();
          }
        }),
      ],
    );
  }
}
