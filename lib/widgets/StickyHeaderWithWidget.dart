// ✅ StickyHeaderWithWidget: subtitle + widget + button destekler
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/theme_provider.dart';

class StickyHeaderWithWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget subtitleWidget;
  final VoidCallback onStartRoutePressed;
  final bool showButton;
  final bool isUserAdded;
  final VoidCallback? onAddPressed; // 👈 yeni parametre

  const StickyHeaderWithWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.subtitleWidget,
    required this.onStartRoutePressed,
    this.showButton = true,
    this.onAddPressed, // 👈
    required this.isUserAdded,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SliverPersistentHeader(
      pinned: true,
      delegate: _StickyHeaderWithWidgetDelegate(
        minHeight: 175,
        maxHeight: 175,
        child: Container(
          color: themeProvider.backgroundColor,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // Başlık ve alt yazılar
                  Padding(
                    padding: isUserAdded
                        ? const EdgeInsets.only(right: 60)
                        : const EdgeInsets.only(
                            right: 0), // Buton için boşluk bırak
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 5,
                              height: 28,
                              decoration: BoxDecoration(
                                color: themeProvider.buttonColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                title,
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: themeProvider.textColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            subtitle,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: themeProvider.textColor
                                  .withValues(alpha: 0.7),
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: subtitleWidget,
                        ),
                      ],
                    ),
                  ),

                  // Sağ üst köşeye yuvarlak buton
                  if (onAddPressed != null && isUserAdded && showButton)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: onAddPressed,
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: themeProvider.buttonColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              ...[
                if (showButton)
                  Column(
                    children: [
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: onStartRoutePressed,
                            icon: const Icon(Icons.directions,
                                color: Colors.white),
                            label: Text(
                              "Tüm Rotayı Haritada Başlat",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeProvider.buttonColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                              shadowColor: Colors.black26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StickyHeaderWithWidgetDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderWithWidgetDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
