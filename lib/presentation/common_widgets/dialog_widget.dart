import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class DialogWidget extends StatelessWidget {
  final String title, message;
  const DialogWidget({
    required this.message,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      contentPadding: const EdgeInsets.only(
        bottom: 10,
        right: 20,
        left: 20,
      ),
      actions: [
        TextButton(
          onPressed: () {
            StarlightUtils.pop();
          },
          child: const Text("OK"),
        ),
      ],
      title: Text(title),
      content: Text(message),
    );
  }
}
