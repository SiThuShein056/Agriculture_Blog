import 'package:blog_app/data/models/post_model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class PostDetail extends StatelessWidget {
  const PostDetail({super.key});

  @override
  Widget build(BuildContext context) {
    PostModel posts = ModalRoute.of(context)!.settings.arguments as PostModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(posts.category),
        automaticallyImplyLeading: false,
        leading: const IconButton(
            onPressed: (StarlightUtils.pop),
            icon: Icon(Icons.chevron_left_outlined)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                posts.description,
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            posts.image.isNotEmpty
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .5,
                    child: Card(
                      child: Image.network(
                        posts.image,
                        fit: BoxFit.cover,
                      ),
                    ))
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
