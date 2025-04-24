import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/models/MovieItem.dart';
import 'package:rota_erzincan/theme_provider.dart';

class MovieCard extends StatelessWidget {
  final MovieItem item;
  final ThemeProvider themeProvider;

  const MovieCard({
    super.key,
    required this.item,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: themeProvider.isDarkMode
                  ? Colors.black.withValues(alpha: 0.25)
                  : Colors.grey.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: FadeInImage.assetNetwork(
                placeholder: ImageConstants.loading,
                image: item.imageUrl,
                fit: BoxFit.cover,
                width: 110,
                height: 150,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: themeProvider.textColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.cinema,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: themeProvider.textColor
                                  .withValues(alpha: 0.7),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: item.sessions.map((session) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: themeProvider.buttonColor
                                .withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            session,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class ShimmerMovieCard extends StatelessWidget {
  final ThemeProvider themeProvider;

  const ShimmerMovieCard({
    super.key,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: Container(
                width: 110,
                height: 135,
                color: themeProvider.isDarkMode
                    ? Colors.grey.shade800
                    : Colors.grey.shade300,
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
                    Container(
                      height: 16,
                      width: 140,
                      decoration: BoxDecoration(
                        color: themeProvider.isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 12,
                      width: 180,
                      decoration: BoxDecoration(
                        color: themeProvider.isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 120,
                      decoration: BoxDecoration(
                        color: themeProvider.isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
