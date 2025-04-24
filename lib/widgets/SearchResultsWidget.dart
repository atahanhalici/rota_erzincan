import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/widgets/PlaceCardWidget.dart';

class SearchResultsWidget extends StatelessWidget {
  final TextEditingController controller;
  final List<CategoryContentItem> items;
  const SearchResultsWidget(
      {super.key, required this.controller, required this.items});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final query = controller.text.toLowerCase();
    final filteredItems = items
        .where((item) => item.title.toLowerCase().contains(query))
        .toList();

    if (filteredItems.isEmpty) {
      return Center(
        child: Text(
          'Sonuç bulunamadı.',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: themeProvider.textColor.withOpacity(0.6),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final place = filteredItems[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 500 + index * 100),
          tween: Tween(begin: 0, end: 1),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: child,
              ),
            );
          },
          child: PlaceCardWidget(place: place, controller: controller),
        );
      },
    );
  }
}
