// Camera List Widget
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/theme_provider.dart';

class LiveCamsCameraList extends StatelessWidget {
  final ThemeProvider themeProvider;
  final List<Map<String, dynamic>> cameras;
  final AnimationController controller;
  final void Function(String url, String title) onTap;

  const LiveCamsCameraList({
    super.key,
    required this.themeProvider,
    required this.cameras,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cameras.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 100, left: 16, right: 16),
      itemBuilder: (context, index) {
        final cam = cameras[index];
        final delay = 0.2 + (index * 0.1);
        final delayedAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              delay < 1.0 ? delay : 0.9,
              (delay + 0.2) < 1.0 ? (delay + 0.2) : 1.0,
              curve: Curves.easeOutQuart,
            ),
          ),
        );

        return AnimatedBuilder(
          animation: delayedAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - delayedAnimation.value)),
              child: Opacity(
                opacity: delayedAnimation.value,
                child: child,
              ),
            );
          },
          child: GestureDetector(
            onTap: () => onTap(cam['url']!, cam['name']!),
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: themeProvider.cardColor.withOpacity(0.85),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: themeProvider.isDarkMode
                        ? Colors.black.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.asset(
                            ImageConstants.logo,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Positioned.fill(
                          child: Center(
                            child: Icon(
                              Icons.play_circle_fill,
                              size: 64,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => onTap(cam['url']!, cam['name']!),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  cam['status'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              cam['icon'],
                              color: themeProvider.buttonColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              cam['name'],
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: themeProvider.textColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cam['description'],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: themeProvider.textColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}