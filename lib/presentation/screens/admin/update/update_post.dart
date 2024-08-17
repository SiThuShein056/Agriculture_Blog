import 'dart:developer';

import 'package:blog_app/data/datasources/local/utils/my_util.dart';
import 'package:blog_app/data/datasources/remote/db_crud_service/firebase_store_db.dart';
import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:blog_app/data/models/post_video_model/post_video_model.dart';
import 'package:blog_app/presentation/blocs/post_crud_bloc/update_post_cubit/update_data_cubit.dart';
import 'package:blog_app/presentation/blocs/post_crud_bloc/update_post_cubit/update_data_state.dart';
import 'package:blog_app/presentation/common_widgets/custom_outlined_button.dart';
import 'package:blog_app/presentation/common_widgets/form_widget.dart';
import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:blog_app/presentation/screens/chat/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../../../data/models/post_Images_model/post_image_model.dart';

class UpdatePostScreen extends StatelessWidget {
  const UpdatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<UpdateDataCubit>();
    var post = ModalRoute.of(context)!.settings.arguments as PostModel;
    bloc.mainCategoryController.text = bloc.mainCategoryController.text.isEmpty
        ? post.category
        : bloc.mainCategoryController.text;
    bloc.descriptionController.text = bloc.descriptionController.text.isEmpty
        ? post.description
        : bloc.descriptionController.text;
    bloc.phoneController.text = bloc.phoneController.text.isEmpty
        ? post.phone ?? ""
        : bloc.phoneController.text;

    log(bloc.privacy.value);
    bloc.privacyController.text =
        bloc.privacy.value == "select" ? post.privacy : bloc.privacy.value;

    bloc.privacy.value =
        bloc.privacy.value == "select" ? post.privacy : bloc.privacy.value;
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              title: const Text("Update"),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomOutlinedButton(
                    function: () async {
                      await bloc.updatePost(post.id);
                      MyUtil.showToast(context);
                    },
                    lable: "Update",
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
                            StreamBuilder(
                                stream: FirebaseStoreDb().postImages(post.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CupertinoActivityIndicator());
                                  }
                                  if (snapshot.data == null) {
                                    return const Center(
                                      child: Text("No Data"),
                                    );
                                  }
                                  List<PostImageModel> postImages =
                                      snapshot.data!.toList();

                                  return BlocBuilder<UpdateDataCubit,
                                          UpdateDataBaseState>(
                                      builder: (context, state) {
                                    return Row(
                                      children: [
                                        InkWell(
                                            onTap: () async {
                                              await showDialog(
                                                  context: context,
                                                  builder: (context) => Center(
                                                        child: AlertDialog(
                                                          elevation: 0.01,
                                                          title: const Text(
                                                              "Select Action"),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              TextButton.icon(
                                                                  onPressed:
                                                                      () async {
                                                                    bloc.pickPostVideos();
                                                                    await bloc
                                                                        .deletePostVideos(
                                                                            post.id);
                                                                    StarlightUtils
                                                                        .pop();
                                                                  },
                                                                  label: const Text(
                                                                      "Pick Videos"),
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .video_file_outlined)),
                                                              TextButton.icon(
                                                                onPressed:
                                                                    () async {
                                                                  bloc.pickPostPhotos();
                                                                  await bloc
                                                                      .deletePostImages(
                                                                          post.id);
                                                                  StarlightUtils
                                                                      .pop();
                                                                },
                                                                label: const Text(
                                                                    "Pick Images"),
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .image_outlined,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  StarlightUtils
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "Close"))
                                                          ],
                                                        ),
                                                      ));
                                            },
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .15,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .3,
                                              child: const Card(
                                                child: Icon(Icons.upload),
                                              ),
                                            )),
                                        (state.imageUrl == null ||
                                                (state.imageUrl?.isEmpty ==
                                                    true))
                                            ? const SizedBox()
                                            : Expanded(
                                                child: SizedBox(
                                                  width: context.width,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .3,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: state
                                                          .imageUrl!.length,
                                                      itemBuilder: (_, i) {
                                                        return SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              .15,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .3,
                                                          child: Card(
                                                            child:
                                                                Image.network(
                                                              state
                                                                  .imageUrl![i],
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                              ),
                                        if (postImages.isNotEmpty &&
                                            state.imageUrl == null)
                                          Expanded(
                                            child: SizedBox(
                                              width: context.width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .3,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: postImages.length,
                                                  itemBuilder: (_, i) {
                                                    return SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .15,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .3,
                                                      child: Card(
                                                        child: Image.network(
                                                          postImages[i]
                                                              .imageUrl,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ),
                                      ],
                                    );
                                  });
                                }),
                            StreamBuilder(
                                stream: FirebaseStoreDb().postVideos(post.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CupertinoActivityIndicator());
                                  }
                                  if (snapshot.data == null) {
                                    return const Center(
                                      child: Text("No Data"),
                                    );
                                  }
                                  List<PostVideoModel> postVideos =
                                      snapshot.data!.toList();

                                  return BlocBuilder<UpdateDataCubit,
                                          UpdateDataBaseState>(
                                      builder: (context, state) {
                                    return Row(
                                      children: [
                                        (state.videoUrl == null ||
                                                (state.videoUrl?.isEmpty ==
                                                    true))
                                            ? const SizedBox()
                                            : Expanded(
                                                child: SizedBox(
                                                  width: context.width,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .3,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: state
                                                          .videoUrl!.length,
                                                      itemBuilder: (_, i) {
                                                        return SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              .15,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .3,
                                                          child: Card(
                                                            child: IconButton(
                                                              onPressed: () {
                                                                StarlightUtils.push(
                                                                    VideoPlayerWidget(
                                                                        uri: state
                                                                            .videoUrl![i]));
                                                              },
                                                              icon: const Icon(Icons
                                                                  .play_circle_outline),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                              ),
                                        if (postVideos.isNotEmpty &&
                                            state.videoUrl == null)
                                          Expanded(
                                            child: SizedBox(
                                              width: context.width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .3,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: postVideos.length,
                                                  itemBuilder: (_, i) {
                                                    return SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .15,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .3,
                                                      child: Card(
                                                          child: IconButton(
                                                              onPressed: () {
                                                                StarlightUtils.push(
                                                                    VideoPlayerWidget(
                                                                        uri: postVideos[i]
                                                                            .videoUrl));
                                                              },
                                                              icon: const Icon(Icons
                                                                  .play_circle_outline))),
                                                    );
                                                  }),
                                            ),
                                          ),
                                      ],
                                    );
                                  });
                                }),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                "Privacy",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextFormField(
                              readOnly: true,
                              controller: bloc.privacyController,
                              validator: (value) {
                                if (value!.isEmpty) return "";
                                if (value == "select" &&
                                    bloc.privacy.value == "select") {
                                  return "You must need to select  privacy";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                suffixIcon: ValueListenableBuilder(
                                    valueListenable: bloc.privacy,
                                    builder: (_, value, child) {
                                      return DropdownButton(
                                          alignment: Alignment.center,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          value: value,
                                          items: ["select", "public", "private"]
                                              .map((e) => DropdownMenuItem(
                                                    value: e,
                                                    child: Text(e),
                                                  ))
                                              .toList(),
                                          onChanged: (v) {
                                            bloc.privacyController.text = v!;
                                            bloc.privacy.value = v;
                                          });
                                    }),
                                hintText: "Select Privacy",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                "Phone Number",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextFormField(
                              // validator: (value) {
                              //   if (value!.isEmpty) return "";
                              //   return null;
                              // },
                              // autovalidateMode:
                              //     AutovalidateMode.onUserInteraction,
                              controller: bloc.phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: "Enter your phone",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                "Category",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            BlocBuilder<UpdateDataCubit, UpdateDataBaseState>(
                                builder: (context, snapshot) {
                              return TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) return "";
                                  if (value.contains("null")) {
                                    return "You need to select both category and sub_category";
                                  }
                                  return null;
                                },
                                onTap: () {
                                  StarlightUtils.pushNamed(
                                    RouteNames.mainCategories,
                                  ).then((category) {
                                    bloc.mainCategoryController.text = category;
                                  });
                                },
                                readOnly: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: bloc.mainCategoryController,
                                decoration: InputDecoration(
                                  hintText: "Select Category",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                "Description",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) return "";
                                return null;
                              },
                              maxLines: 3,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: bloc.descriptionController,
                              decoration: InputDecoration(
                                hintText: "Enter a description",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
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
            StarlightUtils.snackbar(const SnackBar(
              content: Text("Fail Action"),
            ));
          }
          if (state is UpdatePickSuccessState) {
            StarlightUtils.snackbar(const SnackBar(
              content: Text("Uploaded image"),
            ));
          }
          if (state is UpdateDataSuccessState) {
            StarlightUtils.snackbar(const SnackBar(
              content: Text("Success Action"),
            ));

            StarlightUtils.pop();
          }
        }),
      ],
    );
  }
}
