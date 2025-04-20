import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/pages/RouteDetailPage/route_detail_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';

class RouteContentSliver extends StatelessWidget {
  final ThemeProvider themeProvider;
  final RouteDetailPageViewModel viewModel;
  final AnimationController controller;

  const RouteContentSliver({
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

            return AnimatedBuilder(
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
                child: GestureDetector(
                  onTap: () {
                    viewModel.navigateToPage(CategoryContentItem(
                      id: item.id,
                      title: item.title,
                      description: item.description,
                      imageUrl: item.imageUrl,
                      latitude: 39.7531, // Erzincan merkez koordinatları
                      longitude: 39.4985,
                    ));
                  },
                  child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                      color: themeProvider.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: themeProvider.isDarkMode
                              ? Colors.black.withOpacity(0.25)
                              : Colors.grey.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'content_${item.id}',
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // 🔥 yazı + buton arası yay
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
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
                                            .withOpacity(0.7),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (item.distanceFromUser != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          item.distanceFromUser! < 1000
                                              ? "Bana uzaklık: < 1 km"
                                              : "Bana uzaklık: ${(item.distanceFromUser! / 1000).toStringAsFixed(1)} km",
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: themeProvider.textColor
                                                .withOpacity(0.6),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () => viewModel.navigateToStop(
                                      context, themeProvider, item),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(right: 16),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: themeProvider.buttonColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.location_on_rounded,
                                              size: 16, color: Colors.white),
                                          const SizedBox(width: 6),
                                          Text(
                                            "Haritada Git",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
