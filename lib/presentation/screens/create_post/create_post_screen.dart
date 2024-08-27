part of 'create_post_import.dart';

class CreatePost extends StatelessWidget {
  const CreatePost({
    super.key,
    // this.ownerName,
    // this.title,
    // this.description,
    // this.imageUrl,
    // this.phoneNumber,
    // this.sharedPost,
  });
  //  : assert((sharedPost == true &&
  //           (ownerName != null || ownerName != "") &&
  //           (title != null || title != "") &&
  //           (description != null || description != "")));
  // final String? ownerName;
  // final String? title;
  // final String? description;

  // final String? imageUrl;
  // final String? phoneNumber;
  // final bool? sharedPost;

  @override
  Widget build(BuildContext context) {
    final postCreateBloc = context.read<CreateCubit>();

    return Stack(
      children: [
        Scaffold(
            backgroundColor: Theme.of(context).cardColor,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: const Text("Create-Post").tr(),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomOutlinedButton(
                    function: () async {
                      var isEnabled = await FirebaseStoreDb().checkPostStatus();
                      if (isEnabled) {
                        postCreateBloc.createPost();
                      } else {
                        StarlightUtils.snackbar(const SnackBar(
                            content: Text("Your account has been blocked.")));
                      }
                    },
                    lable: "Post".tr(),
                    icon: Icons.post_add_outlined,
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: postCreateBloc.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) => Center(
                                          child: AlertDialog(
                                            elevation: 0.01,
                                            title: const Text("Select Action"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextButton.icon(
                                                    onPressed: () {
                                                      postCreateBloc
                                                          .pickPostVideo();
                                                      StarlightUtils.pop();
                                                    },
                                                    label: const Text(
                                                        "Pick Videos"),
                                                    icon: const Icon(Icons
                                                        .video_file_outlined)),
                                                TextButton.icon(
                                                  onPressed: () {
                                                    postCreateBloc
                                                        .pickPostPhotos();

                                                    StarlightUtils.pop();
                                                  },
                                                  label:
                                                      const Text("Pick Images"),
                                                  icon: const Icon(
                                                    Icons.image_outlined,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    StarlightUtils.pop();
                                                  },
                                                  child: const Text("Close"))
                                            ],
                                          ),
                                        ));
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.height * .15,
                                height: MediaQuery.of(context).size.width * .3,
                                child: const Card(
                                  child: Icon(Icons.upload),
                                ),
                              )),
                          Expanded(
                            child: BlocBuilder<CreateCubit, CreateState>(
                                builder: (_, state) {
                              var url = state.imageUrl;
                              if (url?.length == 0 || url == null) {
                                return const SizedBox();
                              }
                              return SizedBox(
                                width: context.width,
                                height: MediaQuery.of(context).size.width * .3,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: url.length,
                                    itemBuilder: (_, i) {
                                      return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.height *
                                                .15,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                .3,
                                        child: Card(
                                          child: Image.network(
                                            url[i],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            }),
                          )
                        ],
                      ),
                      BlocBuilder<CreateCubit, CreateState>(
                        builder: (_, state) {
                          var videoUrl = state.videoUrl;
                          if (videoUrl?.length == 0 || videoUrl == null) {
                            return const SizedBox();
                          }
                          return SizedBox(
                            width: context.width,
                            height: MediaQuery.of(context).size.width * .3,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: videoUrl.length,
                                itemBuilder: (_, i) {
                                  return SizedBox(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              .15,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              .3,
                                      child: Card(
                                          child: IconButton(
                                              onPressed: () {
                                                StarlightUtils.push(
                                                    VideoPlayerWidget(
                                                        uri: videoUrl[i]));
                                              },
                                              icon: const Icon(Icons
                                                  .video_collection_outlined))));
                                }),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: const Text(
                          "Privacy",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ).tr(),
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: postCreateBloc.privacyController,
                        validator: (value) {
                          if (value!.isEmpty) return "";
                          if (value == "select".tr() &&
                              postCreateBloc.privacy.value == "select".tr()) {
                            return "You must need to select  privacy".tr();
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: ValueListenableBuilder(
                              valueListenable: postCreateBloc.privacy,
                              builder: (_, value, child) {
                                return DropdownButton(
                                    alignment: Alignment.center,
                                    borderRadius: BorderRadius.circular(5),
                                    value: value,
                                    items: ["select", "Public", "Private"]
                                        .map((e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e).tr(),
                                            ))
                                        .toList(),
                                    onChanged: (v) {
                                      postCreateBloc.privacyController.text =
                                          v!;
                                      postCreateBloc.privacy.value = v;
                                      log(postCreateBloc.privacy.value);
                                    });
                              }),
                          hintText: "Select-Privacy".tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: const Text(
                          "Comment-Status",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ).tr(),
                      ),
                      ValueListenableBuilder(
                        valueListenable: postCreateBloc.commentStatus,
                        builder: (context, value, child) {
                          return Card(
                            child: SwitchListTile(
                                title: const Text("Allow-To-Comment").tr(),
                                value: value,
                                onChanged: (v) {
                                  postCreateBloc.toggle();
                                }),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: const Text(
                          "Phone-Number",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ).tr(),
                      ),
                      TextFormField(
                        // validator: (value) {
                        //   if (value!.isEmpty) return "";
                        //   return null;
                        // },
                        // autovalidateMode:
                        //     AutovalidateMode.onUserInteraction,
                        controller: postCreateBloc.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Enter your phone".tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: const Text(
                          "Category",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ).tr(),
                      ),
                      BlocBuilder<CreateCubit, CreateState>(
                        builder: (context, snapshot) {
                          return TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) return "";
                              if (value.contains("null")) {
                                return "You need to select All category and sub_category"
                                    .tr();
                              }
                              return null;
                            },
                            onTap: () {
                              StarlightUtils.pushNamed(
                                RouteNames.mainCategories,
                              ).then((category) {
                                postCreateBloc.categoryController.text =
                                    category;

                                log("Selected item is $category");
                              });
                            },
                            readOnly: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: postCreateBloc.categoryController,
                            decoration: InputDecoration(
                              hintText: "Select-Main-Category".tr(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: const Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ).tr(),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) return "";
                          return null;
                        },
                        maxLines: 3,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: postCreateBloc.descriptionController,
                        decoration: InputDecoration(
                          hintText: "Enter-A-Description".tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
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
            StarlightUtils.snackbar(SnackBar(
              content: const Text("Fail Action").tr(),
            ));
          }
          if (state is CreateSuccessState) {
            StarlightUtils.snackbar(SnackBar(
              content: const Text("Success Action").tr(),
            ));
          }
        }),
      ],
    );
  }
}
