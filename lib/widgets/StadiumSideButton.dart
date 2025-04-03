import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';

class StadiumSideButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final Color textColor;
  final bool isLoading; // Yüklenme durumu için yeni parametre

  const StadiumSideButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.color,
    required this.textColor,
    this.isLoading = false, // Varsayılan olarak false
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: context.sized.dynamicHeight(0.06),
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : onPressed, // Yükleniyorsa butonu devre dışı bırak
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(context.sized.dynamicHeight(0.06)),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white, // Yüklenme animasyonu için renk
                strokeWidth: 2,
              )
            : Text(text.toUpperCase(),
                style: GoogleFonts.poppins(
                  textStyle: context.general.textTheme.titleSmall
                      ?.copyWith(color: textColor, fontWeight: FontWeight.w500),
                )),
      ),
    );
  }
}
