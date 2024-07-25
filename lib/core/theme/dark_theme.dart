import 'package:blog_app/core/theme/standard_theme.dart';
import 'package:flutter/material.dart';

const Color darkScaffoldBackgroundColor = Color.fromRGBO(71, 84, 103, 1),
    darkCardColor = Color.fromRGBO(68, 57, 57, 1),
    darkBorderColor = Color.fromRGBO(165, 180, 201, 1),
    darkPrimaryColor = Color.fromRGBO(226, 233, 245, 1),
    darkOutlinedButtonTextColor = Color.fromRGBO(234, 236, 240, 1),
    darkUnselectedColor = Color.fromRGBO(21, 27, 36, 1),
    darkUnselectedWidgetColor = Color.fromRGBO(43, 45, 48, 1),
    darkIconColor = Color.fromRGBO(223, 228, 241, 1);

const BorderRadius defaultBorderRadius = BorderRadius.all(Radius.circular(5));

class DarkTheme extends StandardTheme {
  @override
  ThemeData get ref => ThemeData.dark();
  @override
  Color get scaffoldBackgroundColor => darkScaffoldBackgroundColor;
  @override
  Color get cardColor => darkCardColor;
  @override
  Color get borderColor => darkBorderColor;
  @override
  Color get primaryColor => darkPrimaryColor;
  @override
  Color get outlinedButtonTextColor => darkOutlinedButtonTextColor;
  @override
  Color get unselectedColor => darkUnselectedColor;
  @override
  Color get unselectedWidgetColor => darkUnselectedWidgetColor;
  @override
  Color get iconColor => darkIconColor;
  @override
  Color get tileColor => darkCardColor;

  @override
  BorderSide get borderSide => BorderSide(
        color: borderColor,
      );

  @override
  BorderRadius get borderRadius => defaultBorderRadius;

  @override
  TextStyle get buttonTextStyle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  @override
  ButtonStyle get buttonStyle => ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: borderSide,
          ),
        ),
        foregroundColor: WidgetStatePropertyAll(
          outlinedButtonTextColor,
        ),
        textStyle: WidgetStatePropertyAll(
          buttonTextStyle,
        ),
        elevation: const WidgetStatePropertyAll(0),
        overlayColor: WidgetStatePropertyAll(primaryColor.withOpacity(0.06)),
      );
}
