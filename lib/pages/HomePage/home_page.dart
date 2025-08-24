import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/pages/HomePage/home_page.view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/AppBar.dart';
import 'package:rota_erzincan/widgets/CategoryList.dart';
import 'package:rota_erzincan/widgets/CategoryListView.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rota_erzincan/widgets/CustomBottomNavBar.dart';
import 'package:rota_erzincan/widgets/CustomDrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late HomePageViewModel _homeModel;

  late AnimationController _controller;
  late Animation<double> _headerAnimation;
  late Animation<double> _subHeaderAnimation;
  late Animation<double> _categoryHeaderAnimation;
  late Animation<double> _categoryListAnimation;
  late Animation<double> _infoCardAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: -50, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _subHeaderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _categoryHeaderAnimation = Tween<double>(begin: -30, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _categoryListAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOutQuart),
      ),
    );

    _infoCardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    // 💡 Asıl düzeltme burada:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeModel = Provider.of<HomePageViewModel>(context, listen: false);
      _homeModel.fetchCategoryData(context);
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget get animatedTextKit => DefaultTextStyle(
        style: GoogleFonts.poppins(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Colors.white.withValues(alpha: 0.95),
        ),
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText('homeAnimatedExplore'.tr(),
                speed: const Duration(milliseconds: 100), cursor: ''),
            TypewriterAnimatedText('homeAnimatedLearn'.tr(),
                speed: const Duration(milliseconds: 100), cursor: ''),
            TypewriterAnimatedText('homeAnimatedTaste'.tr(),
                speed: const Duration(milliseconds: 100), cursor: ''),
            TypewriterAnimatedText('homeAnimatedAdventure'.tr(),
                speed: const Duration(milliseconds: 100), cursor: ''),
          ],
          repeatForever: true,
          pause: const Duration(milliseconds: 1500),
        ),
      );

  @override
  Widget build(BuildContext context) {
    _homeModel = Provider.of<HomePageViewModel>(context, listen: true);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SafeArea(
      top: false,
      child: Scaffold(
        drawer: CustomDrawer(
          toggleTheme: themeProvider.toggleTheme,
          isDarkMode: themeProvider.isDarkMode,
          textColor: themeProvider.textColor,
        ),
        backgroundColor: themeProvider.backgroundColor,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: themeProvider.cardColor.withValues(alpha: 0.8),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: themeProvider.isDarkMode
                      ? Colors.black.withValues(alpha: 0.2)
                      : Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Appbar(
              actionIcon: const Icon(
                Icons.search,
                size: 30,
                color: ColorConstants.buttonColor,
              ),
              onActionPressed: () {
                _homeModel.navigateToSearch();
              },
            ),
          ),
        ),
        body: Stack(
          children: [
            // Ana içerik
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Üst Bölüm - Karşılama
                  Container(
                    height: 240,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          themeProvider.buttonColor.withValues(alpha: 0.8),
                          themeProvider.isDarkMode
                              ? themeProvider.backgroundColor
                                  .withValues(alpha: 0.9)
                              : Colors.black.withValues(alpha: 0.9),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              themeProvider.buttonColor.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Görsel ve desen
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                            child: Stack(
                              children: [
                                // Arka plan görseli - Erzincan şehir görüntüsü
                                Opacity(
                                  opacity: 0.4,
                                  child: Image.network(
                                    "https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/katowice-nasil-bir-sehir-3-1-1024x683.png?alt=media&token=bc607803-290e-4ec7-b358-f52198ea5a1c",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // İçerik
                        SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Animasyonlu başlık
                                AnimatedBuilder(
                                  animation: _headerAnimation,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(0, _headerAnimation.value),
                                      child: Text(
                                        'homeHeaderErzincan'.tr(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 2),
                                              blurRadius: 5,
                                              color: Colors.black26,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                // Animasyonlu alt başlık
                                AnimatedBuilder(
                                  animation: _subHeaderAnimation,
                                  builder: (context, child) {
                                    return Opacity(
                                      opacity: _subHeaderAnimation.value,
                                      child: Row(
                                        children: [
                                          // Değişen kısım
                                          animatedTextKit,
                                          const SizedBox(width: 4),
                                          Text(
                                            'homeHeaderSuffix'.tr(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white
                                                  .withValues(alpha: 0.95),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Popüler Yerler (Yatay Kaydırılabilir) - Animasyonlu Başlık
                  AnimatedBuilder(
                    animation: _categoryHeaderAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _categoryHeaderAnimation.value),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 4,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: themeProvider.buttonColor,
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: themeProvider.buttonColor
                                              .withValues(alpha: 0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ShaderMask(
                                    shaderCallback: (bounds) {
                                      return LinearGradient(
                                        colors: themeProvider.isDarkMode
                                            ? [
                                                Colors.white,
                                                Colors.white
                                                    .withValues(alpha: 0.8)
                                              ]
                                            : [
                                                themeProvider.textColor,
                                                themeProvider.textColor
                                                    .withValues(alpha: 0.8)
                                              ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ).createShader(bounds);
                                    },
                                    child: Text(
                                      'homeSectionTitle'.tr(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  _homeModel.navigateBottomBar(context, 1);
                                },
                                child: Text(
                                  'homeSeeAllText'.tr(),
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
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // Kategori Listesi - Animasyonlu
                  AnimatedBuilder(
                    animation: _categoryListAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _categoryListAnimation.value),
                        child: Opacity(
                          opacity: _controller.value,
                          child: const CategoryList(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // Ana Kategoriler - Animasyonlu
                  AnimatedBuilder(
                    animation: _categoryListAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _categoryListAnimation.value),
                        child: Opacity(
                          opacity: _controller.value,
                          child: const CategoryListView(),
                        ),
                      );
                    },
                  ),

                  // Alt Bilgi - Erzincan Hakkında - Animasyonlu
                  AnimatedBuilder(
                    animation: _infoCardAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _infoCardAnimation.value,
                        child: Transform.translate(
                          offset:
                              Offset(0, 30 * (1 - _infoCardAnimation.value)),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: themeProvider.cardColor,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeProvider.isDarkMode
                                        ? themeProvider.textColor
                                            .withValues(alpha: 0.3)
                                        : themeProvider.buttonColor
                                            .withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: themeProvider.buttonColor
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.info_outline,
                                          color: themeProvider.buttonColor,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'homeAboutTitle'.tr(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: themeProvider.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'homeAboutDescription'.tr(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      height: 1.5,
                                      color: themeProvider.textColor
                                          .withValues(alpha: 0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: context.sized.width,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        final langCode =
                                            context.locale.languageCode;
                                        _homeModel.navigateToDetails(context,
                                            imageUrl:
                                                "https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/c3e4721f-bb4c-4a09-8067-837ef3e98c2e.jpg?alt=media&token=15a6edd4-d9cf-48ab-ad25-addaf92c3f9b",
                                            title: 'drawerAboutErzincan'.tr(),
                                            base: true,
                                            desc: langCode == 'tr'
                                                ? 'Katowice, modern şehir yaşamı ile tarihi dokuyu harmanlayan, kültür ve sanatın kalbinde bir destinasyondur. Ben Atahan Halıcı olarak, bu şehri sizin gözünüzden değil, kendi deneyimlerimden yola çıkarak tanıtıyorum. Katowice’nin etkileyici mimarisi, yeşil alanları ve hareketli sokakları sizi büyüleyecek. Şehrin gizli köşelerini, eşsiz kafelerini, restoranlarını ve sanat galerilerini keşfedin. Her adımda Katowice’nin ruhunu hissedin ve benim keşif notlarımı takip ederek unutulmaz anılar biriktirin.'
                                                : langCode == 'en'
                                                    ? 'Katowice is a city that blends modern urban life with historical charm, placing culture and art at its heart. I, Atahan Halıcı, present this city not from the outside, but through my own experiences. The striking architecture, green spaces, and lively streets of Katowice will captivate you. Explore the hidden corners, unique cafes, restaurants, and art galleries. Feel the spirit of the city in every step and create unforgettable memories by following my personal discovery notes.'
                                                    : 'Katowice to miasto, które łączy nowoczesne życie miejskie z historycznym urokiem, stawiając kulturę i sztukę w centrum uwagi. Ja, Atahan Halıcı, przedstawiam to miasto nie z zewnątrz, ale poprzez własne doświadczenia. Imponująca architektura, zielone przestrzenie i tętniące życiem ulice Katowic oczarują Cię. Odkryj ukryte zakątki, unikalne kawiarnie, restauracje i galerie sztuki. Poczuj ducha miasta na każdym kroku i twórz niezapomniane wspomnienia, podążając za moimi osobistymi notatkami z odkryć.');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            themeProvider.buttonColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('homeMoreInfoText'.tr()),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.arrow_forward,
                                              size: 16),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: const CustomBottomNavBar(
                  currentIndex: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
