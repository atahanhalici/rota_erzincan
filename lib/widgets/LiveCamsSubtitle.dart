// Subtitle Widget
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rota_erzincan/constants/string_constants.dart';
import 'package:rota_erzincan/theme_provider.dart';

class LiveCamsSubtitle extends StatelessWidget {
  final Animation<double> animation;
  final ThemeProvider themeProvider;

  const LiveCamsSubtitle({
    super.key,
    required this.animation,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Padding(
            padding: const EdgeInsets.only(left: 35, bottom: 15),
            child: Text(
              StringConstants.liveCamsSubtitle,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: themeProvider.textColor.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        );
      },
    );
  }
}
