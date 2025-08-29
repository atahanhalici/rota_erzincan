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
    final langCode = context.locale.languageCode;
    return [
      (itemHeight) => FancyMenuItem(
            icon: Icons.person,
            label: 'drawerMessageFromGovernor'.tr(),
            onTap: () {
              Navigator.pop(context);
              homeModel.navigateToDetails(
                context,
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/IMG_6108.JPEG?alt=media&token=99e9dab5-765c-42c3-8bde-f3517211a0a4",
                title: 'drawerMessageFromGovernor'.tr(),
                desc: langCode == 'tr'
                    ? 'Merhaba! Ben Atahan Halıcı, Poznaj Katowice’i tamamen sizin için tasarladım ve geliştirdim. Şehrin gizli köşelerini keşfetmeniz, en etkileyici rotaları takip etmeniz ve Katowice deneyiminizi unutulmaz hâle getirmeniz için her detayı özenle ekledim. Kullanıcı dostu arayüz, hızlı navigasyon, interaktif içerikler ve güncel bilgilerle uygulamayı tamamen optimize ettim. Amacım, her adımda sizin için şehri daha anlamlı ve keyifli hâle getirmek. Her keşfinizde yanınızda olacağım ve Katowice’yi benim gözümden deneyimlemenizi sağlayacağım!'
                    : langCode == 'en'
                        ? 'Hello! I\'m Atahan Halıcı, and I designed and developed Poznaj Katowice entirely for you. I meticulously added every detail so you can explore the city\'s hidden gems, follow the most impressive routes, and make your Katowice experience truly unforgettable. With a user-friendly interface, fast navigation, interactive content, and up-to-date information, I optimized the app completely for your convenience. My goal is to make the city more meaningful and enjoyable at every step, letting you experience Katowice through my eyes!'
                        : 'Cześć! Jestem Atahan Halıcı i całkowicie zaprojektowałem oraz opracowałem Poznaj Katowice dla Ciebie. Starannie dodałem każdy detal, abyś mógł odkrywać ukryte zakątki miasta, śledzić najbardziej imponujące trasy i uczynić swoje doświadczenie w Katowicach naprawdę niezapomnianym. Dzięki przyjaznemu interfejsowi, szybkiej nawigacji, interaktywnym treściom i aktualnym informacjom, zoptymalizowałem aplikację w pełni dla Twojej wygody. Moim celem jest sprawienie, by miasto było bardziej znaczące i przyjemne na każdym kroku, pozwalając Ci doświadczać Katowic moimi oczami!',
              );
            },
            color: ColorConstants.buttonColor.withValues(alpha: 0.1),
            height: itemHeight,
          ),
      (itemHeight) => FancyMenuItem(
            icon: Icons.info_outline,
            label: 'drawerAboutErzincan'.tr(),
            onTap: () {
              Navigator.pop(context);
              homeModel.navigateToDetails(
                context,
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/c3e4721f-bb4c-4a09-8067-837ef3e98c2e.jpg?alt=media&token=15a6edd4-d9cf-48ab-ad25-addaf92c3f9b",
                title: 'drawerAboutErzincan'.tr(),
                desc: langCode == 'tr'
                    ? 'Katowice, modern şehir yaşamı ile tarihi dokuyu harmanlayan, kültür ve sanatın kalbinde bir destinasyondur. Ben Atahan Halıcı olarak, bu şehri sizin gözünüzden değil, kendi deneyimlerimden yola çıkarak tanıtıyorum. Katowice’nin etkileyici mimarisi, yeşil alanları ve hareketli sokakları sizi büyüleyecek. Şehrin gizli köşelerini, eşsiz kafelerini, restoranlarını ve sanat galerilerini keşfedin. Her adımda Katowice’nin ruhunu hissedin ve benim keşif notlarımı takip ederek unutulmaz anılar biriktirin.'
                    : langCode == 'en'
                        ? 'Katowice is a city that blends modern urban life with historical charm, placing culture and art at its heart. I, Atahan Halıcı, present this city not from the outside, but through my own experiences. The striking architecture, green spaces, and lively streets of Katowice will captivate you. Explore the hidden corners, unique cafes, restaurants, and art galleries. Feel the spirit of the city in every step and create unforgettable memories by following my personal discovery notes.'
                        : 'Katowice to miasto, które łączy nowoczesne życie miejskie z historycznym urokiem, stawiając kulturę i sztukę w centrum uwagi. Ja, Atahan Halıcı, przedstawiam to miasto nie z zewnątrz, ale poprzez własne doświadczenia. Imponująca architektura, zielone przestrzenie i tętniące życiem ulice Katowic oczarują Cię. Odkryj ukryte zakątki, unikalne kawiarnie, restauracje i galerie sztuki. Poczuj ducha miasta na każdym kroku i twórz niezapomniane wspomnienia, podążając za moimi osobistymi notatkami z odkryć.',
              );
            },
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
            onTap: () {
              Navigator.pop(context);
              homeModel.navigateToDetails(
                context,
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/loading.jpg?alt=media&token=e6373a4d-70ac-4c60-a206-c51232801210",
                title: 'drawerAboutApp'.tr(),
                desc: langCode == 'tr'
                    ? '“Poznaj Katowice” uygulaması, Katowice’yi keşfetmenin en kolay ve keyifli yolu olarak tasarlandı. Şehrin popüler rotalarını, gizli köşelerini, tarihi ve kültürel noktalarını tek bir yerden görebilir, her mekanın detaylı açıklamalarına, görsellerine ve haritalarına kolayca ulaşabilirsiniz. Favori mekanlarınızı kaydedebilir, kendi keşiflerinizi paylaşabilir ve gezilerinizi tamamen kişiselleştirebilirsiniz. Uygulama, her adımda size rehberlik ederek Katowice deneyiminizi unutulmaz kılmayı hedefliyor.'
                    : langCode == 'en'
                        ? 'The “Poznaj Katowice” app is designed to make exploring Katowice easy and enjoyable. Discover the city’s popular routes, hidden spots, historic and cultural sites, all in one place. Access detailed descriptions, images, and maps for every location. Save your favorite places, share your discoveries, and personalize your trips. The app guides you every step of the way to make your Katowice experience unforgettable.'
                        : 'Aplikacja „Poznaj Katowice” została zaprojektowana tak, aby odkrywanie Katowic było łatwe i przyjemne. Odkryj popularne trasy, ukryte miejsca, zabytki i miejsca kulturalne w jednym miejscu. Uzyskaj dostęp do szczegółowych opisów, zdjęć i map dla każdej lokalizacji. Zapisuj swoje ulubione miejsca, dziel się odkryciami i personalizuj swoje wycieczki. Aplikacja prowadzi Cię na każdym kroku, aby Twoje doświadczenie w Katowicach było niezapomniane.',
              );
            },
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
      FontAwesomeIcons.facebook: 'https://www.facebook.com/atahan.halici.1',
      FontAwesomeIcons.instagram: 'https://www.instagram.com/atahanhalici/',
      FontAwesomeIcons.xTwitter: 'https://x.com/atahanhalici',
      FontAwesomeIcons.youtube: 'https://www.youtube.com/@atahanhalici',
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
