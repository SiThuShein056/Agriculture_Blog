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
            appBar: AppBar(
              title: const Text("Create Post"),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomOutlinedButton(
                    function: () async {
                      postCreateBloc.createPost();
                    },
                    lable: "Create Post",
                    icon: Icons.post_add_outlined,
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SingleChildScrollView(
                child: Form(
                  key: postCreateBloc.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormBox(
                        height: MediaQuery.of(context).size.height,
                        width: context.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                postCreateBloc.pickPostPhoto();
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.height * .15,
                                height: MediaQuery.of(context).size.width * .3,
                                child: Card(
                                  child: BlocBuilder<CreateCubit, CreateState>(
                                      builder: (_, state) {
                                    var image = state.url;

                                    if (image == null) {
                                      return const Icon(Icons.upload_outlined);
                                    }
                                    log("Post image Url is$image ");

                                    return Image.network(
                                      image,
                                      fit: BoxFit.cover,
                                    );
                                  }),
                                ),
                              ),
                            ),
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
                              decoration: InputDecoration(
                                suffixIcon: ValueListenableBuilder(
                                    valueListenable: postCreateBloc.privacy,
                                    builder: (_, value, child) {
                                      return DropdownButton(
                                          alignment: Alignment.center,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          value: value,
                                          items: ["public", "private"]
                                              .map((e) => DropdownMenuItem(
                                                    value: e,
                                                    child: Text(e),
                                                  ))
                                              .toList(),
                                          onChanged: (v) {
                                            postCreateBloc.privacy.value = v!;
                                            log(postCreateBloc.privacy.value);
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
                              controller: postCreateBloc.phoneController,
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
                            BlocBuilder<CreateCubit, CreateState>(
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
                                    RouteNames.categories,
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
                              controller: postCreateBloc.descriptionController,
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
            log("UI login fail State");

            StarlightUtils.snackbar(const SnackBar(
              content: Text("Fail Create"),
            ));
          }
          if (state is CreateSuccessState) {
            StarlightUtils.snackbar(const SnackBar(
              content: Text("Success Action"),
            ));
          }
        }),
      ],
    );
  }
}
