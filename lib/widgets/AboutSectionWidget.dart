import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:rota_erzincan/theme_provider.dart';

class AboutSectionWidget extends StatelessWidget {
  final Animation<double> animation;
  final ThemeProvider themeProvider;
  const AboutSectionWidget({super.key, required this.animation, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - animation.value)),
          child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: themeProvider.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: themeProvider.buttonColor.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: themeProvider.buttonColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: themeProvider.buttonColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Merkez Hakkında",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: themeProvider.textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Ergan Kayak Merkezi, Erzincan'ın en gözde kış turizm noktasıdır. 3278 metre rakıma sahip Ergan Dağı'nda bulunan merkez, farklı zorluk seviyelerinde pistleri, modern telesiyej sistemleri ve panoramik manzarası ile kış sporları tutkunlarına benzersiz bir deneyim sunmaktadır.",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        height: 1.5,
                        color: themeProvider.textColor.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: context.sized.width,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeProvider.buttonColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor:
                              themeProvider.buttonColor.withOpacity(0.3),
                        ),
                        child: const Text("Detaylı Bilgi İçin Tıklayın"),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // YOL TARİFİ (Sekonder buton)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Yol tarifi işlevselliği
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color:
                                    themeProvider.buttonColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: themeProvider.buttonColor
                                        .withOpacity(0.4)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.directions,
                                    color: themeProvider.buttonColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Yol Tarifi",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: themeProvider.buttonColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // ARA (Vurgulu aksiyon)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Telefon işlevselliği
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color:
                                    themeProvider.buttonColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: themeProvider.buttonColor
                                        .withOpacity(0.4)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: themeProvider.buttonColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Ara",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: themeProvider.buttonColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
  }
}