import 'package:flutter/material.dart';
import 'package:ms_vpn/constants/custom_colors.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: CustomColors.primaryColor,
      onPrimary: CustomColors.lightModeTextColor,
      secondary: CustomColors.lightModeNotActiveButtonColor,
      onSecondary: Colors.white,
    ));
