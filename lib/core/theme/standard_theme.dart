import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

abstract class StandardTheme {
  static TextStyle getBodyTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: context.theme.appBarTheme.titleTextStyle?.color,
    );
  }

  Color get scaffoldBackgroundColor;
  Color get cardColor;
  Color get borderColor;
  Color get primaryColor;
  Color get tileColor;

  ///Title Text,
  Color get outlinedButtonTextColor;
  Color get unselectedColor;
  Color get unselectedWidgetColor;
  Color get iconColor;

  ButtonStyle get buttonStyle;
  TextStyle get buttonTextStyle;

  BorderRadius get borderRadius;
  BorderSide get borderSide;

  TextStyle get titleTextStyle => TextStyle(
        fontSize: 18,
        color: outlinedButtonTextColor,
        fontWeight: FontWeight.w500,
      );

  ThemeData get ref;
  ThemeData get theme => ref.copyWith(
        dividerColor: iconColor,
        primaryIconTheme: IconThemeData(color: iconColor),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: iconColor,
        ),
        snackBarTheme: SnackBarThemeData(
            backgroundColor: iconColor.withOpacity(.5),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        drawerTheme: DrawerThemeData(backgroundColor: scaffoldBackgroundColor),
        appBarTheme: AppBarTheme(
          titleTextStyle: titleTextStyle,
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            side: borderSide,
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: cardColor),
        primaryColor: primaryColor,
        shadowColor: borderColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        cardColor: cardColor,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: iconColor, width: 1.5),
          ),
          isDense: true,
        ),
        iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(iconColor: WidgetStatePropertyAll(iconColor))),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 1,
          backgroundColor: cardColor,
          showUnselectedLabels: true,
          unselectedItemColor: unselectedColor,
          selectedItemColor: Colors.black,
        ),
        cardTheme: CardTheme(
          clipBehavior: Clip.antiAlias,
          color: cardColor,
          surfaceTintColor: cardColor,
          shadowColor: borderColor,
          shape: RoundedRectangleBorder(
            side: borderSide,
            borderRadius: borderRadius,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: buttonStyle.copyWith(
            foregroundColor: WidgetStatePropertyAll(primaryColor),
            shape: const WidgetStatePropertyAll(null),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: buttonStyle,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: buttonStyle.copyWith(
            backgroundColor: WidgetStatePropertyAll(primaryColor),
            foregroundColor: WidgetStatePropertyAll(cardColor),
          ),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: tileColor,
          iconColor: iconColor,
          subtitleTextStyle: TextStyle(color: iconColor),
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: outlinedButtonTextColor,
          ),
        ),
        switchTheme: SwitchThemeData(
          trackOutlineWidth: const WidgetStatePropertyAll(0),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryColor;
            }
            return unselectedWidgetColor;
          }),
          trackOutlineColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryColor;
            }
            return unselectedWidgetColor;
          }),
        ),
        unselectedWidgetColor: unselectedWidgetColor,
        iconTheme: IconThemeData(
          color: iconColor,
        ),
      );
}

// const Color lightScaffoldBackgroundColor = Color.fromRGBO(234, 236, 240, 1),
//     lightCardColor = Color.fromRGBO(255, 255, 255, 1),
//     lightBorderColor = Color.fromRGBO(208, 213, 221, 1),
//     lightPrimaryColor = Color.fromRGBO(23, 92, 211, 1),
//     lightOutlinedButtonTextColor = Color.fromRGBO(71, 84, 103, 1),
//     lightUnselectedColor = Color.fromRGBO(154, 164, 178, 1),
//     lightUnselectedWidgetColor = Color.fromRGBO(242, 244, 247, 1),
//     lightIconColor = Color.fromRGBO(102, 112, 133, 1);
// const BorderRadius defaultBorderRadius = BorderRadius.all(Radius.circular(5));
