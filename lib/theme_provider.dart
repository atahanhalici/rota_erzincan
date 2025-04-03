import 'package:flutter/material.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Varsayılan olarak karanlık mod
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    _saveTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? true;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  // 🔥 Dinamik Renk Getirici (ColorConstants ile entegre)
  Color get backgroundColor => isDarkMode
      ? ColorConstants.backgroundColor
      : ColorConstantsLight.backgroundColor;
  Color get cardColor =>
      isDarkMode ? ColorConstants.cardColor : ColorConstantsLight.cardColor;
  Color get buttonColor =>
      isDarkMode ? ColorConstants.buttonColor : ColorConstantsLight.buttonColor;
  Color get textColor =>
      isDarkMode ? ColorConstants.textColor : ColorConstantsLight.textColor;
  Color get infoItemColor => isDarkMode
      ? ColorConstants.infoItemColor
      : ColorConstantsLight.infoItemColor;
  Color get outlinedButtonColor => isDarkMode
      ? ColorConstants.outlinedButtonColor
      : ColorConstantsLight.outlinedButtonColor;
  Color get outlinedButtonTextColor => isDarkMode
      ? ColorConstants.outlinedButtonTextColor
      : ColorConstantsLight.outlinedButtonTextColor;
  Color get outlinedButtonBorderColor => isDarkMode
      ? ColorConstants.outlinedButtonBorderColor
      : ColorConstantsLight.outlinedButtonBorderColor;
  Color get transparentColor => isDarkMode
      ? ColorConstants.transparentColor
      : ColorConstantsLight.transparentColor;
}
