part of 'home_import.dart';

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget({
    super.key,
    required this.bottomNav,
  });

  final NavigationBloc bottomNav;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
      return SalomonBottomBar(
        currentIndex: state.i,
        onTap: (i) => bottomNav.add(NavigationEvent(i)),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.home_outlined),
            title: const Text("Home").tr(),
            selectedColor: Colors.teal,
          ),

          /// Create Post
          SalomonBottomBarItem(
            icon: const Icon(Icons.post_add_outlined),
            title: const Text("New-Post").tr(),
            selectedColor: Colors.teal,
          ),

          /// chat
          SalomonBottomBarItem(
            icon: const Icon(Icons.chat_bubble_outline),
            title: const Text("Chat").tr(),
            selectedColor: Colors.teal,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: const Icon(Icons.person_outline),
            title: const Text("Profile").tr(),
            selectedColor: Colors.teal,
          ),
        ],
      );
    });
  }
}
