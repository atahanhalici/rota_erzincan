import 'package:flutter/material.dart';

@immutable
class ColorConstants {
  const ColorConstants._();

  // Karanlık Tema Renkleri
  static const Color backgroundColor = Color.fromARGB(255, 6, 4, 15);
  static const Color transparentColor = Colors.transparent;
  static const Color cardColor = Color.fromARGB(255, 20, 26, 51);
  static const Color buttonColor = Color.fromARGB(255, 230, 126, 34);
  static const Color textColor = Colors.white;
  static const Color infoItemColor = Color.fromARGB(255, 245, 183, 70);

  // Outlined Button
  static const Color outlinedButtonColor = Colors.transparent;
  static const Color outlinedButtonTextColor = Color(0xFF3F414E);
  static const Color outlinedButtonBorderColor = Color(0xFFA1A4B2);
}

@immutable
class ColorConstantsLight {
  const ColorConstantsLight._();

  // Aydınlık Tema Renkleri
  static const Color backgroundColor = Color.fromARGB(255, 245, 245, 245);
  static const Color transparentColor = Colors.transparent;
  static const Color cardColor = Color.fromARGB(255, 230, 230, 230);
  static const Color buttonColor = Color.fromARGB(255, 255, 140, 0);
  static const Color textColor = Colors.black87;
  static const Color infoItemColor = Color.fromARGB(255, 255, 193, 7);

  // Outlined Button
  static const Color outlinedButtonColor = Colors.transparent;
  static const Color outlinedButtonTextColor = Color(0xFF3F414E);
  static const Color outlinedButtonBorderColor = Color(0xFFA1A4B2);
}
