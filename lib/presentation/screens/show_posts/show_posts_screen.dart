part of 'show_post_import.dart';

class ShowPost extends StatelessWidget {
  final Function() onTap;
  final HomeBloc bloc;
  const ShowPost({super.key, required this.onTap, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agriculture Blog"),
        leading: IconButton(
          onPressed: onTap,
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: StreamBuilder<List<PostModel>>(
          stream: bloc.postStream.stream,
          builder: (_, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (snap.data == null) {
              return const Center(
                child: Text("No Data"),
              );
            }
            return ListView.builder(
                itemCount: snap.data!.length,
                itemBuilder: (_, i) {
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const CircleAvatar(
                            radius: 30,
                          ),
                          title: Text(snap.data![i].userId[0]),
                          subtitle: Text(snap.data![i].category),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(snap.data![i].description),
                        )
                      ],
                    ),
                  );
                });
          }),
    );
  }
}
