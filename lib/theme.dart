import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF0c3d1f);
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
);
