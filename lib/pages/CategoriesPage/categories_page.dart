import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:rota_erzincan/pages/CategoriesPage/categories_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/AppBar.dart';
import 'package:rota_erzincan/widgets/CategoriesView.dart';
import 'package:rota_erzincan/widgets/CustomBottomNavBar.dart';
import 'package:rota_erzincan/widgets/CustomDrawer.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _headerAnimation;
  late CategoriesPageViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _headerAnimation = Tween<double>(begin: -50, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );
    // 💡 Asıl düzeltme burada:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<CategoriesPageViewModel>(context, listen: false);
      _viewModel.fetchAllCategories(context);
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final viewModel =
        Provider.of<CategoriesPageViewModel>(context, listen: false);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      drawer: CustomDrawer(
        toggleTheme: themeProvider.toggleTheme,
        isDarkMode: themeProvider.isDarkMode,
        textColor: themeProvider.textColor,
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: themeProvider.cardColor.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: themeProvider.isDarkMode
                      ? Colors.black.withValues(alpha: 0.4)
                      : Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
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
                viewModel.navigateToSearch();
              },
            )),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              AnimatedBuilder(
                animation: _headerAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _headerAnimation.value),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 5),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 5,
                            height: 28,
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
                          const SizedBox(width: 10),
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                colors: themeProvider.isDarkMode
                                    ? [
                                        Colors.white,
                                        Colors.white.withValues(alpha: 0.8)
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
                              'categoriesTitle'.tr(),
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Alt başlık
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _controller.value,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 35, bottom: 15),
                      child: Text(
                        'categoriesSubtitle'.tr(),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: themeProvider.textColor.withValues(alpha: 0.7),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Yeni kategori listesi
              CategoriesView(controller: _controller),
            ],
          ),

          // Alt Navigation Bar
          const Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: CustomBottomNavBar(
              currentIndex: 1,
            ),
          ),
        ],
      ),
    );
  }
}
