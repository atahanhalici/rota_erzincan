import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/string_constants.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/pages/SearchPage/search_page_view_model.dart';
import 'package:rota_erzincan/widgets/RecentSearchItem.dart';

class RecentSearchesWidget extends StatelessWidget {
  final TextEditingController controller;
  const RecentSearchesWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final viewModel = Provider.of<SearchPageViewModel>(context);
    final recentWidgets = viewModel.recentSearches
        .map((search) =>
            RecentSearchItemWidget(text: search, controller: controller))
        .toList();

    if (recentWidgets.isEmpty) {
      return Center(
        child: Text(
          StringConstants.noSearchesText,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: themeProvider.textColor.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StringConstants.recentSearchesTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.textColor,
                  ),
                ),
                TextButton(
                  onPressed: () => viewModel.clearRecentSearches(),
                  child: Text(
                    StringConstants.clearButtonLabel,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: themeProvider.buttonColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...recentWidgets,
        ],
      ),
    );
  }
}
