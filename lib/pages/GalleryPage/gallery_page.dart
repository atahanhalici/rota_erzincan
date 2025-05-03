import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/pages/GalleryPage/gallery_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/AppBar.dart';
import 'package:rota_erzincan/widgets/BuildGalleryItem.dart';
import 'package:rota_erzincan/widgets/CustomBottomNavBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rota_erzincan/widgets/CustomDrawer.dart';
import 'package:shimmer/shimmer.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _headerAnimation;
  late GalleryPageViewModel _viewModel;
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<GalleryPageViewModel>(context, listen: false);
      _viewModel.fetchGalleryPhotos(context);
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
    GalleryPageViewModel _galleryModel =
        Provider.of<GalleryPageViewModel>(context, listen: true);

    return SafeArea(
      top: false,
      child: Scaffold(
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
                _galleryModel.navigateToSearch();
              },
            ),
          ),
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
                                'galleryPageTitle'.tr(),
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
                          'galleryPageSubtitle'.tr(),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color:
                                themeProvider.textColor.withValues(alpha: 0.7),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Kategoriler
                _galleryModel.isLoading
                    ? AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.translate(
                              offset: Offset(0, 50 * (1 - _controller.value)),
                              child: Opacity(
                                opacity: _controller.value,
                                child: Container(
                                  height: 45,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return Shimmer.fromColors(
                                        baseColor:
                                            const Color(0xFFE0E0E0), // açık gri
                                        highlightColor: const Color(
                                            0xFFF5F5F5), // daha açık
                                        period:
                                            const Duration(milliseconds: 1000),
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 12),
                                          width: 90,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: themeProvider.shimmerColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ));
                        })
                    : AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 50 * (1 - _controller.value)),
                            child: Opacity(
                              opacity: _controller.value,
                              child: Container(
                                height: 45,
                                margin: const EdgeInsets.only(bottom: 20),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  itemCount: _galleryModel.categories.length,
                                  itemBuilder: (context, index) {
                                    bool isSelected =
                                        _galleryModel.selectedCategoryIndex ==
                                            index;
                                    return GestureDetector(
                                      onTap: () {
                                        _galleryModel.changeCategory(index);
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? themeProvider.buttonColor
                                              : themeProvider.cardColor
                                                  .withValues(alpha: 0.7),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: isSelected
                                                  ? themeProvider.buttonColor
                                                      .withValues(alpha: 0.4)
                                                  : Colors.black
                                                      .withValues(alpha: 0.05),
                                              blurRadius: isSelected ? 10 : 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            _galleryModel.categories[index],
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? Colors.white
                                                  : themeProvider.textColor
                                                      .withValues(alpha: 0.8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                // Grid alanı
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _galleryModel.isLoading
                        ? GridView.builder(
                            itemCount: 8,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemBuilder: (context, index) {
                              final delay = 0.2 + (index * 0.1);
                              final delayedAnimation =
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: _controller,
                                  curve: Interval(delay < 1.0 ? delay : 0.9,
                                      (delay + 0.2) < 1.0 ? (delay + 0.2) : 1.0,
                                      curve: Curves.easeOutQuart),
                                ),
                              );

                              return AnimatedBuilder(
                                animation: delayedAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                        0, 50 * (1 - delayedAnimation.value)),
                                    child: Opacity(
                                      opacity: delayedAnimation.value,
                                      child: child,
                                    ),
                                  );
                                },
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color(0xFFE0E0E0), // açık gri
                                  highlightColor:
                                      const Color(0xFFF5F5F5), // daha açık
                                  period: const Duration(milliseconds: 1000),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: themeProvider.shimmerColor,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    margin: const EdgeInsets.only(bottom: 4),
                                  ),
                                ),
                              );
                            })
                        : GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 100),
                            itemCount: _galleryModel.currentImageList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemBuilder: (context, index) {
                              final delay = 0.2 + (index * 0.1);
                              final delayedAnimation =
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: _controller,
                                  curve: Interval(delay < 1.0 ? delay : 0.9,
                                      (delay + 0.2) < 1.0 ? (delay + 0.2) : 1.0,
                                      curve: Curves.easeOutQuart),
                                ),
                              );

                              return AnimatedBuilder(
                                animation: delayedAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                        0, 50 * (1 - delayedAnimation.value)),
                                    child: Opacity(
                                      opacity: delayedAnimation.value,
                                      child: child,
                                    ),
                                  );
                                },
                                child: BuildGalleryItem(
                                  index: _galleryModel.currentImageUrls.indexOf(
                                    _galleryModel.currentImageList[index].url,
                                  ),
                                  controller: _controller,
                                  galleryUrls: _galleryModel.currentImageUrls,
                                  imageUrl:
                                      _galleryModel.currentImageList[index].url,
                                  title: _galleryModel
                                      .currentImageList[index].title,
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),

            // Alt Navigation Bar
            const Positioned(
              left: 16,
              right: 16,
              bottom: 0,
              child: CustomBottomNavBar(
                currentIndex: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
