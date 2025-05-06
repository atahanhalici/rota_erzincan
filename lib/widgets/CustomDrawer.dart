import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/constants/string_constants.dart';
import 'package:rota_erzincan/pages/HomePage/home_page.view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/FancyMenuItem.dart';
import 'package:rota_erzincan/widgets/LanguageSwitcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
    final menuItemBuilders = _buildMenuItems(_homeModel, context);

    return Drawer(
      width: MediaQuery.of(context).size.width > 600
          ? 400
          : MediaQuery.of(context).size.width * 0.75,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;

          // Sabit alanlar
          final headerHeight = height * 0.3;
          final settingsHeight = height * 0.17;
          final footerHeight = height * 0.1;

          // Menüye kalan alanı hesapla
          final remainingHeight =
              height - headerHeight - settingsHeight - footerHeight;

          // Item başına düşen yükseklik
          final menuItemHeight = remainingHeight / menuItemBuilders.length;

          return Container(
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
                // HEADER
                SizedBox(
                  height: headerHeight,
                  child: DrawerHeader(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: headerHeight * 0.5,
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
                ),

                // MENU ITEMS
                ...menuItemBuilders.map((builder) => SizedBox(
                    height: menuItemHeight, child: builder(menuItemHeight))),

                // TEMA / DİL SEÇİCİ
                SizedBox(
                  height: settingsHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildThemeSwitcher(themeProvider),
                        LanguageSwitcher(isDarkMode: isDarkMode),
                      ],
                    ),
                  ),
                ),

                // ALT SİTELER
                SizedBox(
                  height: footerHeight,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildSocialIcons(themeProvider),
                        const SizedBox(height: 4),
                        Text(
                          'drawerCopyright'.tr(namedArgs: {
                            'year': DateTime.now().year.toString()
                          }),
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: textColor.withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget Function(double)> _buildMenuItems(
      HomePageViewModel homeModel, BuildContext context) {
    return [
      (itemHeight) => FancyMenuItem(
            icon: Icons.person,
            label: 'drawerMessageFromGovernor'.tr(),
            onTap: () => homeModel.navigateToDetails(
              context,
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/makam-foto-2.jpeg?alt=media&token=b9eb519f-17de-44c8-aee6-b03fa0bb8c35",
              title: "Valimizden Mesaj",
            ),
            color: ColorConstants.buttonColor.withValues(alpha: 0.1),
            height: itemHeight,
          ),
      (itemHeight) => FancyMenuItem(
            icon: Icons.info_outline,
            label: 'drawerAboutErzincan'.tr(),
            onTap: () => homeModel.navigateToDetails(
              context,
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/erzincana-kar-yeniden-geliyor.jpg?alt=media&token=0b910000-dd18-4edc-8724-66268562adb4",
              title: "Erzincan Hakkında",
            ),
            color: ColorConstants.buttonColor.withValues(alpha: 0.3),
            height: itemHeight,
          ),
      (itemHeight) => FancyMenuItem(
            icon: Icons.location_on,
            label: 'drawerEmergencyAreas'.tr(),
            onTap: () => homeModel.navigateToEmergencyAssemblyAreas(context),
            color: ColorConstants.buttonColor,
            height: itemHeight,
          ),
      (itemHeight) => FancyMenuItem(
            icon: Icons.app_settings_alt,
            label: 'drawerAboutApp'.tr(),
            onTap: () => homeModel.navigateToDetails(
              context,
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/loading.jpg?alt=media&token=1e8517f0-5a7d-4d96-891b-3adb85d850c2",
              title: "Uygulama Hakkında",
            ),
            color: ColorConstants.buttonColor.withValues(alpha: 0.7),
            height: itemHeight,
          ),
      (itemHeight) => FancyMenuItem(
            icon: Icons.feedback_outlined,
            label: 'drawerFeedback'.tr(),
            onTap: () => homeModel.navigateToGiveYourOpinion(context),
            color: ColorConstants.buttonColor.withValues(alpha: 0.9),
            height: itemHeight,
          ),
    ];
  }

  Widget _buildThemeSwitcher(ThemeProvider themeProvider) {
    return GestureDetector(
      onTap: () => toggleTheme(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: themeProvider.textColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: themeProvider.textColor.withValues(alpha: 0.3),
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
              isDarkMode ? 'drawerLightMode'.tr() : 'drawerDarkMode'.tr(),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: themeProvider.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcons(ThemeProvider themeProvider) {
    final socialLinks = <IconData, String>{
      FontAwesomeIcons.facebook: 'https://www.facebook.com/erzincan.valiligi',
      FontAwesomeIcons.instagram: 'https://www.instagram.com/erzincanvaliligi',
      FontAwesomeIcons.xTwitter: 'https://x.com/ervalilik',
      FontAwesomeIcons.youtube:
          'https://www.youtube.com/channel/UCEvKITSEAzNA342u4XEaQTw',
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: socialLinks.entries.map((entry) {
        return InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () async {
            final url = entry.value;
            if (await canLaunchUrlString(url)) {
              await launchUrlString(
                url,
                mode: LaunchMode.inAppWebView,
                webViewConfiguration: const WebViewConfiguration(
                  enableJavaScript: true,
                ),
              );
            } else {
              await launchUrlString(url, mode: LaunchMode.externalApplication);
            }
          },
          child: FaIcon(
            entry.key,
            size: 20,
            color: themeProvider.textColor,
          ),
        );
      }).toList(),
    );
  }
}
