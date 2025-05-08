import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rota_erzincan/pages/GalleryPage/gallery_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:shimmer/shimmer.dart';

class GalleryCategoryBar extends StatelessWidget {
  final ThemeProvider themeProvider;
  final AnimationController controller;
  final GalleryPageViewModel galleryModel;

  const GalleryCategoryBar({
    super.key,
    required this.themeProvider,
    required this.controller,
    required this.galleryModel,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Transform.translate(
            offset: Offset(0, 45 * (1 - controller.value)),
            child: Opacity(
              opacity: controller.value,
              child: SizedBox(
                height: 48, // %80 oran
                child: ListView.builder(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: galleryModel.isLoading
                      ? 5
                      : galleryModel.categories.length,
                  itemBuilder: (context, index) {
                    if (galleryModel.isLoading) {
                      return Shimmer.fromColors(
                        baseColor: const Color(0xFFE0E0E0),
                        highlightColor: const Color(0xFFF5F5F5),
                        period: const Duration(milliseconds: 1000),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 85,
                          height: 34,
                          decoration: BoxDecoration(
                            color: themeProvider.shimmerColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      );
                    } else {
                      final isSelected =
                          galleryModel.selectedCategoryIndex == index;
                      return GestureDetector(
                        onTap: () => galleryModel.changeCategory(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? themeProvider.buttonColor
                                : themeProvider.cardColor.withValues(alpha:0.7),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? themeProvider.buttonColor
                                        .withValues(alpha:0.35)
                                    : Colors.black.withValues(alpha:0.05),
                                blurRadius: isSelected ? 8 : 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              galleryModel.categories[index],
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : themeProvider.textColor.withValues(alpha:0.8),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
