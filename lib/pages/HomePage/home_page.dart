import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
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
    _homeModel = Provider.of<HomePageViewModel>(context, listen: false);

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
          color: Colors.white.withOpacity(0.95),
        ),
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText('Keşfetmeye',
                speed: const Duration(milliseconds: 100), cursor: ''),
            TypewriterAnimatedText('Öğrenmeye',
                speed: const Duration(milliseconds: 100), cursor: ''),
            TypewriterAnimatedText('Tatmaya',
                speed: const Duration(milliseconds: 100), cursor: ''),
            TypewriterAnimatedText('Maceraya',
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

    return Scaffold(
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
            color: themeProvider.cardColor.withOpacity(0.8),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: themeProvider.isDarkMode
                    ? Colors.black.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child:Appbar(
              actionIcon: const Icon(
                Icons.search,
                size: 30,
                color: ColorConstants.buttonColor,
              ),
              onActionPressed: () {
                // Arama butonuna basıldığında yapılacaklar
              },),
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
                        themeProvider.buttonColor.withOpacity(0.8),
                        themeProvider.isDarkMode
                            ? themeProvider.backgroundColor.withOpacity(0.9)
                            : Colors.black.withOpacity(0.9),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: themeProvider.buttonColor.withOpacity(0.2),
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
                                  "https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/YbJ067cDS03GSSQ.jpg?alt=media&token=50bfb43b-07dc-4250-b2a2-7f667fcc1321",
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
                                      "Erzincan'da",
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
                                          "hazır mısın? ",
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.white.withOpacity(0.95),
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
                                            .withOpacity(0.4),
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
                                              Colors.white.withOpacity(0.8)
                                            ]
                                          : [
                                              themeProvider.textColor,
                                              themeProvider.textColor
                                                  .withOpacity(0.8)
                                            ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds);
                                  },
                                  child: Text(
                                    "Ana Başlıklar",
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
                                "Tümünü Gör",
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
                        offset: Offset(0, 30 * (1 - _infoCardAnimation.value)),
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
                                      ? themeProvider.textColor.withOpacity(0.3)
                                      : themeProvider.buttonColor
                                          .withOpacity(0.3),
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
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.info_outline,
                                        color: themeProvider.buttonColor,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      "Erzincan Hakkında",
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
                                  "Doğu Anadolu Bölgesi'nin Yukarı Fırat bölümünde yer alan Erzincan, doğal güzellikleri, tarihi yapıları ve kültürel zenginlikleri ile öne çıkar. Ergan Dağı Kayak Merkezi, Girlevik Şelalesi ve daha pek çok turistik noktası ile keşfedilmeyi bekliyor.",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: themeProvider.textColor
                                        .withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: context.sized.width,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _homeModel.navigateToDetails(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          themeProvider.buttonColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Detaylı Bilgi"),
                                        SizedBox(width: 8),
                                        Icon(Icons.arrow_forward, size: 16),
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
    );
  }
}
