import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';

import '../constants/color_constants.dart';

class OutlinedButtonWithImage extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String imagePath;
  final Color textColor;
  final Color backgroundColor;

  const OutlinedButtonWithImage({
    super.key,
    required this.onPressed,
    required this.textColor,
    required this.backgroundColor,
    required this.text,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final sized = context.sized;
    final buttonHeight = sized.dynamicHeight(0.06);
    final imageWidth = buttonHeight * 0.5; // Görsel, yüksekliğin yarısı kadar
    final fontSize = buttonHeight * 0.3; // Font yüksekliğin %40'ı

    return InkWell(
      onTap: onPressed,
      splashFactory: NoSplash.splashFactory,
      highlightColor: ColorConstants.transparentColor,
      child: Container(
        width: double.infinity,
        height: buttonHeight,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: ColorConstants.outlinedButtonBorderColor),
          borderRadius: BorderRadius.circular(buttonHeight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: sized.lowValue * 1.5),
              child: Image.asset(
                imagePath,
                width: imageWidth,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              text.toUpperCase(),
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
