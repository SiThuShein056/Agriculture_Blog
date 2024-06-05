import 'package:flutter/material.dart';

class ReuseListTileWidget extends StatelessWidget {
  Icon icon;
  String title;
  final Function() onpress;
  ReuseListTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // shadowColor: Colors.green,
      // elevation: 5,
      child: ListTile(
        onTap: onpress,
        leading: icon,
        title: Text(title),
        trailing: const Icon(Icons.chevron_right_outlined),
      ),
    );
  }
}
