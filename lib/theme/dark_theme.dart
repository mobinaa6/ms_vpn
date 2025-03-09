import 'package:flutter/material.dart';
import 'package:ms_vpn/constants/custom_colors.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Colors.black,
    primary: CustomColors.primaryColor,
    onPrimary: CustomColors.darkModeTextColor,
    secondary: CustomColors.darkNotActiveButtonColor,
    onSecondary: Colors.black,
  ),
);
