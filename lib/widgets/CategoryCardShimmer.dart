import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:shimmer/shimmer.dart';

class CategoryCardShimmer extends StatelessWidget {
  const CategoryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: themeProvider.shimmerColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Arkaplan shimmer
            Positioned.fill(
              child: Shimmer.fromColors(
                baseColor: const Color(0xFFE0E0E0), // açık gri
                highlightColor: const Color(0xFFF5F5F5), // daha açık
                period: const Duration(milliseconds: 1000),
                child: Container(color: themeProvider.shimmerColor),
              ),
            ),
            // İçerik shimmer blokları
            Positioned(
              bottom: 20,
              left: 24,
              right: 24,
              child: Row(
                children: [
                  // Icon alanı
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Text alanı
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
