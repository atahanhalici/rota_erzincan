import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';

import '../constants/color_constants.dart';

class OutlinedButtonWithImage extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String imagePath;
  final Color textColor;
  const OutlinedButtonWithImage(
      {super.key,
      required this.onPressed,
      required this.textColor,
      required this.text,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        splashFactory: NoSplash.splashFactory,
        highlightColor: ColorConstants.transparentColor,
        child: Container(
          width: double.infinity,
          height: context.sized.dynamicHeight(0.06),
          decoration: BoxDecoration(
            color: ColorConstants.outlinedButtonColor,
            border: Border.all(color: ColorConstants.outlinedButtonBorderColor),
            borderRadius:
                BorderRadius.circular(context.sized.dynamicHeight(0.06)),
          ),
          child: Center(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: context.padding.onlyLeftMedium,
                    child: Image.asset(imagePath,
                        width: context.sized.dynamicWidth(0.06)),
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      text.toUpperCase(),
                      style: GoogleFonts.poppins(
                          textStyle: context.general.textTheme.labelMedium!
                              .copyWith(
                                  color: textColor,
                                  fontWeight: FontWeight.w600)),
                    )),
              ],
            ),
          ),
        ));
  }
}
