import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF4DA167);
const Color secondaryColor = Color(0xFFbcfbd0);

var appTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.black,
  ),
  listTileTheme: ListTileThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  scaffoldBackgroundColor: const Color(0xFFfdfdfd),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    toolbarTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  splashColor: primaryColor,
  inputDecorationTheme: _textFieldTheme(),
  dropdownMenuTheme: DropdownMenuThemeData(
    inputDecorationTheme: _textFieldTheme(),
  ),
);

InputDecorationTheme _textFieldTheme() {
  return InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.grey,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: primaryColor,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    labelStyle: const TextStyle(
      color: Colors.black,
    ),
  );
}
