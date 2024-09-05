import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final IconData? icon;
  final String lable;
  final Function()? _onPressed;
  const CustomOutlinedButton({
    super.key,
    this.icon,
    required Function()? function,
    required this.lable,
  }) : _onPressed = function;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color.fromRGBO(59, 170, 92, 1)),
      ),
      icon: icon == null ? const SizedBox() : Icon(icon),
      onPressed: _onPressed,
      label: Text(lable),
    );
  }
}
