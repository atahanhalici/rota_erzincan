import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/pages/ErganKayakMerkeziPage/ergan_kayak_merkezi_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';

class HeroSectionWidget extends StatelessWidget {
  final Animation<double> animation;
  final ThemeProvider themeProvider;
  const HeroSectionWidget(
      {super.key, required this.animation, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    ErganViewModel _erganModel =
        Provider.of<ErganViewModel>(context, listen: true);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: SizedBox(
              height:
                  340, // 🔑 sabit yükseklik veriyoruz (gerekiyorsa dışarıdan da alınabilir)
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.white, // ✅ Arkaplan rengi burada tanımlandı
                    child: FadeInImage.assetNetwork(
                      placeholder: ImageConstants.logo,
                      image:
                          "https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/spodek_ic.jpg?alt=media&token=f2163062-9335-462b-a5bd-e48cd30dda4f",
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          ImageConstants.loading,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
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
                                            .withValues(alpha: 0.4),
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
                                        'heroSectionBadgeText'.tr(),
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
                              'heroSectionTitle'.tr(),
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
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                  child: _erganModel
                                      .animatedTextKit, // ✅ ViewModel’den geliyor!
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'heroSectionLocation'.tr(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(Icons.access_time,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'heroSectionAltitude'.tr(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
