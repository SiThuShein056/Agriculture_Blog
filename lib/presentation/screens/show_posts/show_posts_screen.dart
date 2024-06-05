part of 'show_post_import.dart';

class ShowPost extends StatelessWidget {
  final Function() onTap;
  const ShowPost({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agriculture Blog"),
        leading: IconButton(
          onPressed: onTap,
          icon: const Icon(Icons.menu),
        ),
      ),
    );
  }
}
