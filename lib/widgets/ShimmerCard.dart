import 'package:flutter/material.dart';
import 'package:rota_erzincan/theme_provider.dart';

class ShimmerCard extends StatelessWidget {
  final ThemeProvider themeProvider;
  final AnimationController controller;

  const ShimmerCard(
      {super.key, required this.themeProvider, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 6,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
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
          child: Container(
            height: 135,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: themeProvider.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: themeProvider.isDarkMode
                      ? Colors.black.withValues(alpha: 0.2)
                      : Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Shimmer efekti için görsel alanı
                Container(
                  width: 135,
                  height: 135,
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkMode
                        ? Colors.grey[800]
                        : Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 16,
                        width: 150,
                        decoration: BoxDecoration(
                          color: themeProvider.isDarkMode
                              ? Colors.grey[800]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 12,
                        width: 200,
                        decoration: BoxDecoration(
                          color: themeProvider.isDarkMode
                              ? Colors.grey[800]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
