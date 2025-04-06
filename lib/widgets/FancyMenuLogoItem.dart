import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/theme_provider.dart';

class FancyMenuLogoItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const FancyMenuLogoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark = themeProvider.isDarkMode;

    // Tema uyumlu renkler
    final backgroundColor = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.grey.shade100.withOpacity(0.95);
    final borderColor =
        isDark ? Colors.white.withOpacity(0.2) : Colors.grey.shade300;
    final textColor = isDark ? Colors.white : Colors.black87;
    final iconArrowColor = isDark ? Colors.white60 : Colors.black45;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.9),
                    color.withOpacity(0.7),
                  ],
                ),
              ),
              child: ClipOval(
                child: SvgPicture.asset(
                  icon,
                  fit: BoxFit
                      .cover, // İkonun yuvarlak çerçeveyi tamamen doldurması için
                  width:
                      36, // Yuvarlak çerçeveye tam sığması için genişliği artırabilirsiniz
                  height:
                      36, // Yuvarlak çerçeveye tam sığması için yüksekliği artırabilirsiniz
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: iconArrowColor),
          ],
        ),
      ),
    );
  }
}
