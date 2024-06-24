part of 'create_post_import.dart';

class CreatePost extends StatelessWidget {
  const CreatePost({
    super.key,
  });

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormBox(
                      height: MediaQuery.of(context).size.height * .7,
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
                                return null;
                              },
                              onTap: () {
                                StarlightUtils.pushNamed(RouteNames.categories,
                                        arguments: false)
                                    .then((category) {
                                  postCreateBloc.categoryController.text =
                                      category;
                                  log("Selected item is $category");
                                });
                              },
                              readOnly: true,
                              // autovalidateMode:
                              //     AutovalidateMode.onUserInteraction,
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
