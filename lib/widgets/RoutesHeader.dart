// 🔹 routes_header.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/theme_provider.dart';

class RoutesHeader extends StatelessWidget {
  final Animation<double> headerAnimation;
  final AnimationController controller;

  const RoutesHeader({
    super.key,
    required this.headerAnimation,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: headerAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, headerAnimation.value),
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
                            color: themeProvider.buttonColor
                                .withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: themeProvider.isDarkMode
                              ? [
                                  Colors.white,
                                  Colors.white.withValues(alpha: 0.8)
                                ]
                              : [
                                  themeProvider.textColor,
                                  themeProvider.textColor.withValues(alpha: 0.8)
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: Text(
                        'routesHeader'.tr(),
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
        ),
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Opacity(
              opacity: controller.value,
              child: Padding(
                padding: const EdgeInsets.only(left: 35, right: 35, bottom: 15),
                child: Text(
                  'routesSubheader'.tr(),
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
        ),
      ],
    );
  }
}
