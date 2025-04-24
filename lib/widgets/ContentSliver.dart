import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/pages/CategoryDetail/category_detail_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';

class ContentSliver extends StatelessWidget {
  final ThemeProvider themeProvider;
  final CategoryDetailViewModel viewModel;
  final AnimationController controller;

  const ContentSliver({
    super.key,
    required this.themeProvider,
    required this.viewModel,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 120, top: 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = viewModel.contentItems[index];
            final delay = 0.2 + (index * 0.1);
            final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: controller,
                curve: Interval(
                  delay < 1.0 ? delay : 0.9,
                  (delay + 0.2) < 1.0 ? (delay + 0.2) : 1.0,
                  curve: Curves.easeOutQuart,
                ),
              ),
            );

            return GestureDetector(
              onTap: () {
                if (viewModel.category.id==1) {
                  viewModel.navigateToEvent(item, context);
                } else {
                  viewModel.navigateToPage(item);
                }
              },
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - animation.value)),
                    child: Opacity(opacity: animation.value, child: child),
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    height: 135,
                    decoration: BoxDecoration(
                      color: themeProvider.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: themeProvider.isDarkMode
                              ? Colors.black.withValues(alpha: 0.25)
                              : Colors.grey.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Hero(
                          tag:
                              viewModel.category.id==1
                                  ? "event_${item.id}"
                                  : 'content_${item.id}',
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            child: FadeInImage.assetNetwork(
                              placeholder: ImageConstants.loading,
                              image: item.imageUrl,
                              fit: BoxFit.cover,
                              width: 110,
                              height: 135,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: themeProvider.textColor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.description,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: themeProvider.textColor
                                        .withValues(alpha: 0.7),
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: themeProvider.buttonColor
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: themeProvider.buttonColor,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: viewModel.contentItems.length,
        ),
      ),
    );
  }
}
