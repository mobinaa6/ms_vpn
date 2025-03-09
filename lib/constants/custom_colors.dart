import 'package:flutter/material.dart';

class CustomColors {
  static const Color primaryColor = Color(0xe18f1ec2);
  static const LinearGradient activeButtonColor =
      LinearGradient(colors: [Color(0xff696EFF), primaryColor]);
  //dark mode
  static const Color darkNotActiveButtonColor = Colors.white;
  static const Color darkModeTextColor = Colors.white24;
  // light mode
  static const Color lightModeNotActiveButtonColor = Colors.black;
  static const Color lightModeTextColor = Colors.black;
}
