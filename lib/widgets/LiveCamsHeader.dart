import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rota_erzincan/theme_provider.dart';

class LiveCamsHeaderTitle extends StatelessWidget {
  final Animation<double> animation;
  final ThemeProvider themeProvider;

  const LiveCamsHeaderTitle({
    super.key,
    required this.animation,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 5),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 5,
                  height: 28,
                  decoration: BoxDecoration(
                    color: themeProvider.buttonColor,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: themeProvider.buttonColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: themeProvider.isDarkMode
                        ? [Colors.white, Colors.white.withOpacity(0.8)]
                        : [
                            themeProvider.textColor,
                            themeProvider.textColor.withOpacity(0.8)
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    "Canlı Kameralar",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}