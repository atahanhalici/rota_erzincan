// hero_section_widget.dart
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rota_erzincan/theme_provider.dart';

class HeroSectionWidget extends StatelessWidget {
  final Animation<double> animation;
  final ThemeProvider themeProvider;
  const HeroSectionWidget(
      {super.key, required this.animation, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: Container(
            height: 340,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: themeProvider.backgroundColor,
              image: const DecorationImage(
                image: NetworkImage(
                  "https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/ergan.jpeg?alt=media&token=21637606-bf8f-4bf3-b758-ef8858560097",
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: themeProvider.buttonColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: themeProvider.buttonColor
                                      .withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.white, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  "En Popüler",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Ergan Dağı Kayak Merkezi",
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            const Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 4,
                              color: Colors.black45,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          DefaultTextStyle(
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Heyecan dolu kayak deneyimi',
                                  speed: const Duration(milliseconds: 100),
                                  cursor: '',
                                ),
                                TypewriterAnimatedText(
                                  'Kış sporları cenneti',
                                  speed: const Duration(milliseconds: 100),
                                  cursor: '',
                                ),
                                TypewriterAnimatedText(
                                  'Kar keyfi sizi bekliyor',
                                  speed: const Duration(milliseconds: 100),
                                  cursor: '',
                                ),
                              ],
                              repeatForever: true,
                              pause: const Duration(milliseconds: 1500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Colors.white.withOpacity(0.9), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "Erzincan, Türkiye",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.height,
                              color: Colors.white.withOpacity(0.9), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "3278m Rakım",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
