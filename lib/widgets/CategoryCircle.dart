import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/models/CategoryModel.dart';
import 'package:rota_erzincan/theme_provider.dart';

class CategoryCircle extends StatelessWidget {
  final CategoryModel model;

  const CategoryCircle({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SizedBox(
      width: 110,
      height: 140,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.redAccent,
                      ColorConstants.buttonColor,
                      ColorConstants.buttonColor.withOpacity(0.8),
                      Colors.red,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeProvider.isDarkMode
                          ? themeProvider.infoItemColor.withOpacity(0.4)
                          : Colors.black.withOpacity(0.4), // Gölgenin rengi
                      blurRadius: 8, // Gölgenin bulanıklık derecesi
                      offset: Offset(0, 2), // Gölgenin yeri (x, y)
                    ),
                  ],
                ),
              ),
              Container(
                width: 92,
                height: 92,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: FadeInImage.assetNetwork(
                    placeholder: ImageConstants
                        .loading, // Yüklenirken gösterilecek resim
                    image: model.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            model.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 13,
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
