import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/pages/SearchPage/search_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';

class SearchChipWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const SearchChipWidget(
      {super.key, required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final viewModel = Provider.of<SearchPageViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () {
        controller.text = label;
        viewModel.addToRecentSearches(label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: themeProvider.buttonColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: themeProvider.buttonColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: themeProvider.buttonColor,
          ),
        ),
      ),
    );
  }
}
