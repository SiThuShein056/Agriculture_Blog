import 'package:blog_app/core/theme/standard_theme.dart';
import 'package:flutter/material.dart';

const Color lightScaffoldBackgroundColor = Color.fromRGBO(234, 236, 240, 1),
    lightCardColor = Color.fromRGBO(255, 255, 255, 1),
    lightBorderColor = Color.fromRGBO(33, 36, 40, 1),
    lightPrimaryColor = Color.fromRGBO(25, 26, 26, 1),
    lightOutlinedButtonTextColor = Color.fromRGBO(71, 84, 103, 1),
    lightUnselectedColor = Color.fromRGBO(154, 164, 178, 1),
    lightUnselectedWidgetColor = Color.fromRGBO(242, 244, 247, 1),
    lightIconColor = Color.fromRGBO(30, 32, 36, 1);
const BorderRadius defaultBorderRadius = BorderRadius.all(Radius.circular(5));

class LightTheme extends StandardTheme {
  @override
  ThemeData get ref => ThemeData.light();
  @override
  Color get scaffoldBackgroundColor => lightScaffoldBackgroundColor;
  @override
  Color get cardColor => lightCardColor;
  @override
  Color get borderColor => lightBorderColor;
  @override
  Color get primaryColor => lightPrimaryColor;
  @override
  Color get outlinedButtonTextColor => lightOutlinedButtonTextColor;
  @override
  Color get unselectedColor => lightUnselectedColor;
  @override
  Color get unselectedWidgetColor => lightUnselectedWidgetColor;
  @override
  Color get iconColor => lightIconColor;
  @override
  Color get tileColor => lightCardColor;

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
