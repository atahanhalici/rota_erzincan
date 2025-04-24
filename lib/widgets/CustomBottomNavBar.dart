import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/string_constants.dart';
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
    final items = [
      _NavItem(icon: Icons.home_outlined, label: StringConstants.bottomNavHome),
      _NavItem(
          icon: Icons.dehaze_outlined,
          label: StringConstants.bottomNavCategories),
      _NavItem(
          icon: Icons.photo_library_outlined,
          label: StringConstants.bottomNavGallery),
      _NavItem(
          icon: Icons.map_outlined, label: StringConstants.bottomNavRoutes),
      _NavItem(
          icon: Icons.event_outlined, label: StringConstants.bottomNavEvents),
    ];

    final themeProvider = Provider.of<ThemeProvider>(context);
    final _homeModel = Provider.of<HomePageViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return SafeArea(
      top: false,
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
              height: 72,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          themeProvider.cardColor.withValues(alpha: 0.7),
                          themeProvider.cardColor.withValues(alpha: 0.5)
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.9),
                          Colors.white.withValues(alpha: 0.8)
                        ],
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? themeProvider.buttonColor.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.08),
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
                          _homeModel.navigateBottomBar(context, idx,
                              title: StringConstants.eventHighlightTitle,
                              subtitle: StringConstants.eventHighlightSubtitle,
                              icon: Icons.event,
                              imageUrl: "https://picsum.photos/id/169/800/500");
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: isSelected
                            ? BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeProvider.buttonColor
                                        .withValues(alpha: 0.75),
                                    blurRadius: 20,
                                    spreadRadius: 1,
                                  ),
                                ],
                              )
                            : const BoxDecoration(
                                color: Colors.transparent,
                              ),
                        child: _buildNavItemContent(
                            item, isSelected, isDark, context),
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
      _NavItem item, bool isSelected, bool isDark, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          item.icon,
          color: isSelected
              ? (isDark ? Colors.white : Colors.black87)
              : (isDark ? Colors.white60 : Colors.black38),
          size: context.sized.dynamicWidth(0.055),
        ),
        const SizedBox(height: 4),
        Text(
          item.label,
          style: TextStyle(
            color: isSelected
                ? (isDark ? Colors.white : Colors.black87)
                : (isDark ? Colors.white60 : Colors.black54),
            fontSize: context.sized.dynamicWidth(0.023),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  _NavItem({required this.icon, required this.label});
}
