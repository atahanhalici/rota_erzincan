import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/pages/ErganKayakMerkeziPage/ergan_kayak_merkezi_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:shimmer/shimmer.dart';

class WeatherSectionWidget extends StatelessWidget {
  final Animation<double> animation;
  final ThemeProvider themeProvider;
  const WeatherSectionWidget(
      {super.key, required this.animation, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    ErganViewModel _erganModel =
        Provider.of<ErganViewModel>(context, listen: true);
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
                                        .withValues(alpha: 0.4),
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
                                    themeProvider.textColor
                                        .withValues(alpha: 0.8),
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
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: _erganModel.isLoading
                            ? 4
                            : _erganModel.infoCards.length,
                        itemBuilder: (context, index) {
                          if (_erganModel.isLoading) {
                            // 🔄 SHIMMER göster
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              width: 130,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Shimmer.fromColors(
                                baseColor: const Color(0xFFE0E0E0), // açık gri
                                highlightColor:
                                    const Color(0xFFF5F5F5), // daha açık
                                period: const Duration(milliseconds: 1000),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: themeProvider.shimmerColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            // ✅ NORMAL içerik
                            final item = _erganModel.infoCards[index];
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOut,
                              width: 130,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    themeProvider.buttonColor
                                        .withValues(alpha: 0.9),
                                    themeProvider.buttonColor
                                        .withValues(alpha: 0.6),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeProvider.buttonColor
                                        .withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(item.icon,
                                      color: Colors.white, size: 36),
                                  const SizedBox(height: 12),
                                  Text(
                                    item.label,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.value,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
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
