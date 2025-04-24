import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/string_constants.dart';
import 'package:rota_erzincan/pages/ErganKayakMerkeziPage/ergan_kayak_merkezi_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:shimmer/shimmer.dart';

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
    ErganViewModel _erganModel =
        Provider.of<ErganViewModel>(context, listen: true);
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                    children: (_erganModel.isLoading
                        ? List.generate(4, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              height: 90,
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
                          })
                        : _erganModel.facilityItems
                            .asMap()
                            .entries
                            .map((entry) {
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
                                    offset: Offset(
                                        0, 20 * (1 - itemAnimation.value)),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (item.id==0) {
                                          _erganModel.navigateToCameras();
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        decoration: BoxDecoration(
                                          color: widget.themeProvider.cardColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.1),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            )
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Stack(
                                            children: [
                                              // Gradient for active items

                                              Positioned.fill(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        item.active == true
                                                            ? Colors.green
                                                                .withValues(
                                                                    alpha: 0.1)
                                                            : Colors.red
                                                                .withValues(
                                                                    alpha: 0.1),
                                                        Colors.transparent,
                                                      ],
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
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
                                                    color: item.active == true
                                                        ? Colors.green
                                                        : Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ),
                                              ),

                                              // Content
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 16),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                        color: widget
                                                            .themeProvider
                                                            .buttonColor
                                                            .withValues(
                                                                alpha: 0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Icon(
                                                        item.icon,
                                                        color: widget
                                                            .themeProvider
                                                            .buttonColor,
                                                        size: 24,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item.label,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: widget
                                                                  .themeProvider
                                                                  .textColor,
                                                            ),
                                                          ),
                                                          if (item.extraText !=
                                                              null)
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 4.0),
                                                              child: Text(
                                                                item.extraText
                                                                    as String,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 13,
                                                                  color: widget
                                                                      .themeProvider
                                                                      .textColor
                                                                      .withValues(
                                                                          alpha:
                                                                              0.7),
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12,
                                                          vertical: 6),
                                                      decoration: BoxDecoration(
                                                        color: (item.active)
                                                            ? Colors.green
                                                                .withValues(
                                                                    alpha: 0.2)
                                                            : Colors.red
                                                                .withValues(
                                                                    alpha: 0.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            (item.active)
                                                                ? Icons
                                                                    .check_circle
                                                                : Icons.cancel,
                                                            color: (item.active)
                                                                ? Colors.green
                                                                : Colors.red,
                                                            size: 16,
                                                          ),
                                                          const SizedBox(
                                                              width: 4),
                                                          Text(
                                                            (item.active)
                                                                ? StringConstants
                                                                    .facilityOpenLabel
                                                                : StringConstants
                                                                    .facilityClosedLabel,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12,
                                                              color: (item
                                                                      .active)
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
                          }).toList()),
                  ),
                ),
              ),
            ));
  }
}
