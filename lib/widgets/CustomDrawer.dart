import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/constants/string_constants.dart';
import 'package:rota_erzincan/pages/HomePage/home_page.view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/FancyMenuItem.dart';

class CustomDrawer extends StatelessWidget {
  final Function toggleTheme;
  final bool isDarkMode;
  final Color textColor;

  const CustomDrawer({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final _homeModel = Provider.of<HomePageViewModel>(context, listen: false);
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [const Color(0xFF1C1C1E), const Color(0xFF2C2C2E)]
                : [const Color(0xFFF4F6F7), const Color(0xFFE5E8E8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Üstte DrawerHeader
            DrawerHeader(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 9.1,
                      child: Image.asset(ImageConstants.logo),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      StringConstants.appName,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable Menü ve Tema Butonu
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  ..._buildMenuItems(_homeModel, context),
                ],
              ),
            ),
            _buildThemeSwitcher(themeProvider),
            const SizedBox(
              height: 20,
            ),
            // Sabit alt kısım
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: textColor.withOpacity(0.1),
                  ),
                ),
              ),
              child: Column(
                children: [
                  _buildSocialIcons(themeProvider),
                  const SizedBox(height: 14),
                  Text(
                    'Erzincan Valiliği © ${DateTime.now().year}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMenuItems(
      HomePageViewModel homeModel, BuildContext context) {
    return [
      FancyMenuItem(
        icon: Icons.person,
        label: "Valimizden Mesaj",
        onTap: () {
          homeModel.navigateToDetails(context,
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/makam-foto-2.jpeg?alt=media&token=b9eb519f-17de-44c8-aee6-b03fa0bb8c35",
              title: "Valimizden Mesaj");
        },
        color: ColorConstants.buttonColor.withOpacity(0.1),
      ),
      FancyMenuItem(
        icon: Icons.info_outline,
        label: "Erzincan Hakkında",
        onTap: () {
          homeModel.navigateToDetails(context,
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/erzincana-kar-yeniden-geliyor.jpg?alt=media&token=0b910000-dd18-4edc-8724-66268562adb4",
              title: "Erzincan Hakkında");
        },
        color: ColorConstants.buttonColor.withOpacity(0.3),
      ),
      FancyMenuItem(
        icon: Icons.location_on,
        label: "Acil Toplanma Alanları",
        onTap: () {
          homeModel.navigateToEmergencyAssemblyAreas(context);
        },
        color: ColorConstants.buttonColor,
      ),
      FancyMenuItem(
        icon: Icons.app_settings_alt,
        label: "Uygulama Hakkında",
        onTap: () {
          homeModel.navigateToDetails(context,
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/loading.jpg?alt=media&token=1e8517f0-5a7d-4d96-891b-3adb85d850c2",
              title: "Uygulama Hakkında");
        },
        color: ColorConstants.buttonColor.withOpacity(0.7),
      ),
      FancyMenuItem(
        icon: Icons.feedback_outlined,
        label: "Görüş Bildir",
        onTap: () {
          homeModel.navigateToGiveYourOpinion(context);
        },
        color: ColorConstants.buttonColor.withOpacity(0.9),
      ),
    ];
  }

  Widget _buildThemeSwitcher(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: GestureDetector(
        onTap: () => toggleTheme(),
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: themeProvider.textColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: themeProvider.textColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: themeProvider.textColor,
              ),
              const SizedBox(width: 8),
              Text(
                isDarkMode ? "Aydınlık Mod" : "Karanlık Mod",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: themeProvider.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcons(ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FaIcon(FontAwesomeIcons.facebook,
            size: 20, color: themeProvider.textColor),
        FaIcon(FontAwesomeIcons.instagram,
            size: 20, color: themeProvider.textColor),
        FaIcon(FontAwesomeIcons.xTwitter,
            size: 20, color: themeProvider.textColor),
        FaIcon(FontAwesomeIcons.youtube,
            size: 20, color: themeProvider.textColor),
      ],
    );
  }
}
