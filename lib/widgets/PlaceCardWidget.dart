import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/pages/SearchPage/search_page_view_model.dart';

class PlaceCardWidget extends StatelessWidget {
  final CategoryContentItem place;
  final TextEditingController controller;
  const PlaceCardWidget(
      {super.key, required this.place, required this.controller});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final viewModel = Provider.of<SearchPageViewModel>(context, listen: false);

    return GestureDetector(
      onTap: () {
        viewModel.addToRecentSearches(place.title);
        viewModel.navigateToPage(place);
        controller.clear();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: themeProvider.isDarkMode
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child: FadeInImage.assetNetwork(
                placeholder: ImageConstants.loading,
                image: place.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    ImageConstants.loading,
                    fit: BoxFit.cover,
                    height: 180,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: themeProvider.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    place.description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: themeProvider.textColor.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            viewModel.openMapApp(context, themeProvider,
                                place.latitude, place.longitude, place.title);
                          },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: themeProvider.buttonColor
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.map_outlined,
                                      color: themeProvider.buttonColor,
                                      size: 20),
                                  const SizedBox(width: 8),
                                  Text('viewOnMapButton'.tr(),
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          color: themeProvider.buttonColor)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: themeProvider.buttonColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(Icons.arrow_forward_rounded,
                              color: Colors.white, size: 24),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
