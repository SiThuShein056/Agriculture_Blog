import 'package:flutter/material.dart';

class PostActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function()? onTap;
  final Color? color;
  const PostActionButton(
      {super.key,
      required this.label,
      required this.icon,
      this.onTap,
      this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
