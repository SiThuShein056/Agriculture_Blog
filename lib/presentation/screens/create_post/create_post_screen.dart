part of 'create_post_import.dart';

class CreatePost extends StatelessWidget {
  PostCreateCubit bloc;
  CreatePost({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
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
                      bloc.onSave();
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
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Category",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) return "";
                              return null;
                            },
                            onTap: () {
                              log("tapped");
                            },
                            // readOnly: true,
                            // autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: bloc.categoryController,
                            decoration: InputDecoration(
                              hintText: "Select Category",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
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
            )),
        BlocConsumer<PostCreateCubit, PostCreateState>(
            builder: (context, state) {
          if (state is PostCreateLoadingState) {
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
          if (state is PostCreateErrorState) {
            log("UI login fail State");

            StarlightUtils.snackbar(const SnackBar(
              content: Text("Fail Create"),
            ));
          }
          if (state is PostCreateSuccessState) {
            StarlightUtils.snackbar(const SnackBar(
              content: Text("Success Action"),
            ));
          }
        }),
      ],
    );
  }
}
