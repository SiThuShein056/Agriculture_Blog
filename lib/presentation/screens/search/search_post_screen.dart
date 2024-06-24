part of 'search_import.dart';

class SearchPostScreen extends StatelessWidget {
  const SearchPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const CupertinoSearchTextField(
            // controller: _searchController,
            ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Welcome from Searching Room"),
      ),
    );
  }
}
