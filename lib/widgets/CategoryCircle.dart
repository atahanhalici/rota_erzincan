import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/models/CategoryModel.dart';
import 'package:rota_erzincan/pages/HomePage/home_page.view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';

class CategoryCircle extends StatelessWidget {
  final CategoryModel model;

  const CategoryCircle({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final homeModel = Provider.of<HomePageViewModel>(context, listen: true);
    final screenWidth = MediaQuery.of(context).size.width;

    final double outerSize = screenWidth * 0.25;
    final double innerSize = outerSize * 0.92;
    final double textSize = screenWidth * 0.03;

    return GestureDetector(
      onTap: () {
        homeModel.openStory(context, model);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 8, bottom: 4), // ☝️ Shadow nefes alır
            child: Center(
              child: Container(
                width: outerSize,
                height: outerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.redAccent,
                      ColorConstants.buttonColor,
                      ColorConstants.buttonColor.withValues(alpha:0.8),
                      Colors.red,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeProvider.isDarkMode
                          ? themeProvider.infoItemColor.withValues(alpha:0.4)
                          : Colors.black.withValues(alpha:0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: innerSize,
                    height: innerSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        placeholder: ImageConstants.loading,
                        image: model.imageUrl,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            ImageConstants.loading,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            model.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: textSize.clamp(10, 14),
                fontWeight: FontWeight.w500,
                color: themeProvider.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
