import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rota_erzincan/theme_provider.dart';

class FacilityListWidget extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  final ThemeProvider themeProvider;
  const FacilityListWidget(
      {super.key,
      required this.animationController,
      required this.animation,
      required this.themeProvider});

  @override
  State<FacilityListWidget> createState() => _FacilityListWidgetState();
}

class _FacilityListWidgetState extends State<FacilityListWidget> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "label": "Kameralar",
        "icon": Icons.videocam,
        "active": true,
        "extraText": "İzlemek için tıklayın",
        "onTap": () => Navigator.pushNamed(context, "/kameralar"),
      },
      {
        "label": "Gondol",
        "icon": Icons.cable,
        "active": true,
      },
      {
        "label": "Kızak Pisti",
        "icon": Icons.snowboarding,
        "active": false,
      },
      {
        "label": "T-Bar",
        "icon": Icons.arrow_upward,
        "active": true,
      },
      {
        "label": "1. Etap",
        "icon": Icons.landscape,
        "active": true,
      },
      {
        "label": "2. Etap",
        "icon": Icons.terrain,
        "active": false,
      },
    ];
    // ... aynı map ve animated item rendering işlemleri burada yapılır
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, widget.animation.value),
        child: Opacity(
          opacity: widget.animationController.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return AnimatedBuilder(
                  animation: widget.animationController,
                  builder: (context, child) {
                    // Staggered animation for list items
                    final itemDelay = index * 0.1;
                    final startValue = 0.5 + itemDelay;
                    final endValue = 0.7 + itemDelay;

                    final itemAnimation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval(startValue.clamp(0.0, 1.0),
                            endValue.clamp(0.0, 1.0),
                            curve: Curves.easeOut),
                      ),
                    );

                    return Opacity(
                      opacity: itemAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - itemAnimation.value)),
                        child: GestureDetector(
                          onTap: item["onTap"] as void Function()?,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: widget.themeProvider.cardColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                children: [
                                  // Gradient for active items

                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            item["active"] == true
                                                ? Colors.green.withOpacity(0.1)
                                                : Colors.red.withOpacity(0.1),
                                            Colors.transparent,
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Side indicator for active items

                                  Positioned(
                                    left: 0,
                                    top: 8,
                                    bottom: 8,
                                    child: Container(
                                      width: 4,
                                      decoration: BoxDecoration(
                                        color: item["active"] == true
                                            ? Colors.green
                                            : Colors.red,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),

                                  // Content
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: widget
                                                .themeProvider.buttonColor
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            item["icon"] as IconData,
                                            color: widget
                                                .themeProvider.buttonColor,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item["label"] as String,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: widget
                                                      .themeProvider.textColor,
                                                ),
                                              ),
                                              if (item["extraText"] != null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4.0),
                                                  child: Text(
                                                    item["extraText"] as String,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      color: widget
                                                          .themeProvider
                                                          .textColor
                                                          .withOpacity(0.7),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: (item["active"] as bool)
                                                ? Colors.green.withOpacity(0.2)
                                                : Colors.red.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                (item["active"] as bool)
                                                    ? Icons.check_circle
                                                    : Icons.cancel,
                                                color: (item["active"] as bool)
                                                    ? Colors.green
                                                    : Colors.red,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                (item["active"] as bool)
                                                    ? "  Açık  "
                                                    : "Kapalı",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color:
                                                      (item["active"] as bool)
                                                          ? Colors.green
                                                          : Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
