import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/pages/HomePage/home_page.view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final _homeModel = Provider.of<HomePageViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final bottomPadding = mediaQuery.padding.bottom;
    final scaleFactor = mediaQuery.textScaleFactor;

    // 🔧 Responsive ayarlar
    final barHeight = (screenHeight * 0.085).clamp(68.0, 84.0);
    final iconSize = (screenWidth * 0.052).clamp(20.0, 26.0);
    final isTablet = screenWidth >= 600;
    final fontSize = isTablet
        ? ((screenWidth * 0.029) / scaleFactor).clamp(11.0, 13.0) // tablet
        : ((screenWidth * 0.027) / scaleFactor).clamp(9.5, 12.0); // telefon

    final items = [
      _NavItem(icon: Icons.home_outlined, labelKey: 'bottomNavHome'),
      _NavItem(icon: Icons.dehaze_outlined, labelKey: 'bottomNavCategories'),
      _NavItem(
          icon: Icons.photo_library_outlined, labelKey: 'bottomNavGallery'),
      _NavItem(icon: Icons.map_outlined, labelKey: 'bottomNavRoutes'),
      _NavItem(icon: Icons.event_outlined, labelKey: 'bottomNavEvents'),
    ];

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 8), // taşma koruması
      child: Padding(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: bottomPadding > 0 ? bottomPadding : 12,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: barHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          themeProvider.cardColor.withOpacity(0.7),
                          themeProvider.cardColor.withOpacity(0.5),
                        ]
                      : [
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.8),
                        ],
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? themeProvider.buttonColor.withOpacity(0.3)
                        : Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: items.asMap().entries.map((entry) {
                  int idx = entry.key;
                  _NavItem item = entry.value;
                  final isSelected = idx == currentIndex;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (idx != 4) {
                          _homeModel.navigateBottomBar(context, idx);
                        } else {
                          _homeModel.navigateBottomBar(
                            context,
                            idx,
                            title: 'eventHighlightTitle'.tr(),
                            subtitle: 'eventHighlightSubtitle'.tr(),
                            icon: Icons.event,
                            imageUrl: "https://picsum.photos/id/169/800/500",
                            id: 8,
                          );
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: isSelected
                            ? BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeProvider.buttonColor
                                        .withOpacity(0.75),
                                    blurRadius: 20,
                                    spreadRadius: 1,
                                  ),
                                ],
                              )
                            : const BoxDecoration(
                                color: Colors.transparent,
                              ),
                        child: _buildNavItemContent(
                          item,
                          isSelected,
                          isDark,
                          iconSize: iconSize,
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItemContent(
    _NavItem item,
    bool isSelected,
    bool isDark, {
    required double iconSize,
    required double fontSize,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          item.icon,
          color: isSelected
              ? (isDark ? Colors.white : Colors.black87)
              : (isDark ? Colors.white60 : Colors.black38),
          size: iconSize,
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            item.labelKey.tr(),
            style: TextStyle(
              height: 1.0, // taşmayı azaltır
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? (isDark ? Colors.white : Colors.black87)
                  : (isDark ? Colors.white60 : Colors.black54),
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

class _NavItem {
  final IconData icon;
  final String labelKey;

  _NavItem({required this.icon, required this.labelKey});
}
