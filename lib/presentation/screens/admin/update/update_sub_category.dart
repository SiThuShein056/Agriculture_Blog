import 'package:blog_app/data/models/sub_category_modle/sub_category_model.dart';
import 'package:blog_app/presentation/blocs/post_crud_bloc/update_post_cubit/update_data_cubit.dart';
import 'package:blog_app/presentation/blocs/post_crud_bloc/update_post_cubit/update_data_state.dart';
import 'package:blog_app/presentation/common_widgets/custom_outlined_button.dart';
import 'package:blog_app/presentation/common_widgets/form_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../../../data/datasources/local/utils/my_util.dart';

class UpdateSubCategoryScreen extends StatelessWidget {
  const UpdateSubCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<UpdateDataCubit>();
    var subCategory =
        ModalRoute.of(context)!.settings.arguments as SubCategoryModel;
    bloc.categoryController.text = bloc.categoryController.text.isEmpty
        ? subCategory.name
        : bloc.categoryController.text;
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              title: const Text("Update").tr(),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomOutlinedButton(
                    function: () {
                      bloc.updateSubCategory(subCategory.id);
                      MyUtil.showToast(context);

                      StarlightUtils.pop();
                    },
                    lable: "Update".tr(),
                    icon: Icons.post_add_outlined,
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SingleChildScrollView(
                child: Form(
                  key: bloc.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormBox(
                        height: MediaQuery.of(context).size.height,
                        width: context.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: const Text(
                                "SubCategory",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ).tr(),
                            ),
                            BlocBuilder<UpdateDataCubit, UpdateDataBaseState>(
                                builder: (context, snapshot) {
                              return TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) return "";

                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: bloc.categoryController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        BlocConsumer<UpdateDataCubit, UpdateDataBaseState>(
            builder: (context, state) {
          if (state is UpdateDataLoadingState) {
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
          if (state is UpdateDataErrorState) {
            StarlightUtils.snackbar(SnackBar(
              content: const Text("Fail Action").tr(),
            ));
          }
          if (state is UpdateDataSuccessState) {
            StarlightUtils.snackbar(SnackBar(
              content: const Text("Success Action").tr(),
            ));

            StarlightUtils.pop();
          }
        }),
      ],
    );
  }
}
