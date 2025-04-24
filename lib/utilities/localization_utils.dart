import 'package:flutter/widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class LocalizationUtils {
  static bool isTR(BuildContext context) =>
      context.locale.languageCode == 'tr';

  static String getText(
    BuildContext context, {
    required String tr,
    required String en,
  }) {
    return isTR(context) ? tr : en;
  }
}
