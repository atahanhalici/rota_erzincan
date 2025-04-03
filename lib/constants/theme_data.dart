import 'package:flutter/material.dart';
import 'color_constants.dart'; // Renk dosyanın adı

@immutable
class AppThemes {
  const AppThemes._();

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ColorConstants.backgroundColor,
    cardColor: ColorConstants.cardColor,
    primaryColor: ColorConstants.buttonColor,
    hintColor: ColorConstants.infoItemColor,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: ColorConstants.textColor),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: ColorConstants.outlinedButtonColor,
        foregroundColor: ColorConstants.outlinedButtonTextColor,
        side: const BorderSide(color: ColorConstants.outlinedButtonBorderColor),
      ),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: ColorConstantsLight.backgroundColor,
    cardColor: ColorConstantsLight.cardColor,
    primaryColor: ColorConstantsLight.buttonColor,
    hintColor: ColorConstantsLight.infoItemColor,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: ColorConstantsLight.textColor),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: ColorConstantsLight.outlinedButtonColor,
        foregroundColor: ColorConstantsLight.outlinedButtonTextColor,
        side: const BorderSide(
            color: ColorConstantsLight.outlinedButtonBorderColor),
      ),
    ),
  );
}
