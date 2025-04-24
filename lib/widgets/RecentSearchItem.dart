import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/pages/SearchPage/search_page_view_model.dart';

class RecentSearchItemWidget extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  const RecentSearchItemWidget(
      {super.key, required this.text, required this.controller});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final viewModel = Provider.of<SearchPageViewModel>(context, listen: false);

    return Dismissible(
      key: Key(text),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        viewModel.removeFromRecentSearches(text);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: () {
            controller.text = text;
            viewModel.addToRecentSearches(text);
          },
          child: Row(
            children: [
              Icon(Icons.history,
                  color: themeProvider.textColor.withValues(alpha: 0.6),
                  size: 22),
              const SizedBox(width: 16),
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: themeProvider.textColor,
                ),
              ),
              const Spacer(),
              Icon(Icons.north_west,
                  color: themeProvider.textColor.withValues(alpha: 0.4),
                  size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
