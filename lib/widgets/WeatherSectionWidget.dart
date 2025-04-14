import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rota_erzincan/theme_provider.dart';

class WeatherSectionWidget extends StatelessWidget {
  final Animation<double> animation;
  final ThemeProvider themeProvider;
  const WeatherSectionWidget(
      {super.key, required this.animation, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    final infoCards = [
      {"label": "Sıcaklık", "value": "-2°C", "icon": Icons.thermostat},
      {"label": "Rüzgar", "value": "15 km/h", "icon": Icons.air},
      {"label": "Hava", "value": "Kar Yağışlı", "icon": Icons.cloud},
      {"label": "3278 m", "value": "150 cm", "icon": Icons.ac_unit},
      {"label": "2355 m", "value": "120 cm", "icon": Icons.ac_unit},
      {"label": "1740 m", "value": "95 cm", "icon": Icons.ac_unit},
    ];
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - animation.value)),
            child: Container(
              margin: const EdgeInsets.only(top: 24),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 4,
                              height: 45,
                              decoration: BoxDecoration(
                                color: themeProvider.buttonColor,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeProvider.buttonColor
                                        .withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: [
                                    themeProvider.textColor,
                                    themeProvider.textColor.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hava ve Kar Durumu",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.swipe,
                                          color: themeProvider.textColor,
                                          size: 14),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Tüm bilgileri görmek için kaydır",
                                        style: GoogleFonts.poppins(
                                          color: themeProvider.textColor,
                                          fontSize: 11.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 140,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: infoCards.length,
                      itemBuilder: (context, index) {
                        final item = infoCards[index];
                        return Container(
                          width: 130,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                themeProvider.buttonColor.withOpacity(0.9),
                                themeProvider.buttonColor.withOpacity(0.6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    themeProvider.buttonColor.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item['icon'] as IconData,
                                color: Colors.white,
                                size: 36,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item['label'] as String,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['value'] as String,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
