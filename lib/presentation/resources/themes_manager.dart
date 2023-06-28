import 'package:flutter/material.dart';

import 'colors_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    // icon buttom theme
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStateProperty.all(
          ColorsManager.white,
        ),
      ),
    ),

    // icon theme
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),

    // text themes
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: ColorsManager.white,
        fontSize: 25,
      ),
      titleMedium: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      bodyMedium: TextStyle(
        color: ColorsManager.white,
        fontSize: 15,
      ),
      bodySmall: TextStyle(
        color: ColorsManager.white,
        fontSize: 11,
      ),
      displayLarge: TextStyle(
        color: ColorsManager.white,
      ),
      displayMedium: TextStyle(
        color: ColorsManager.white,
      ),
      displaySmall: TextStyle(
        color: ColorsManager.white,
      ),
    ),

    // input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        color: ColorsManager.white,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(width: 1.5, color: Colors.black54),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1.5, color: Colors.red),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1.5, color: Colors.white),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1.5, color: Colors.red),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
    ),

    // pop up menu theme
    popupMenuTheme: const PopupMenuThemeData(
      color: Colors.white,
    ),

    // app bar theme
    appBarTheme: const AppBarTheme(
      color: Colors.black,
    ),

    scaffoldBackgroundColor: Colors.black,
  );
}
