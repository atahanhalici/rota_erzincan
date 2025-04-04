import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/pages/FullScreenGallery/full_screen_gallery_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';

class FullscreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullscreenGallery({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  _FullscreenGalleryState createState() => _FullscreenGalleryState();
}

class _FullscreenGalleryState extends State<FullscreenGallery> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final viewModel = Provider.of<FullscreenGalleryViewModel>(context);
    double dynamicMaxSize =
        viewModel.calculateDynamicMaxSize(widget.images.length);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: themeProvider.textColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Terzibaba Mezarlığı ve Türbesi',
          style: GoogleFonts.poppins(
            color: themeProvider.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            shadows: [
              Shadow(
                color: themeProvider.backgroundColor.withOpacity(0.5),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: viewModel.pageController,
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Hero(
                        tag: 'image$index',
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: themeProvider.isDarkMode
                                    ? themeProvider.textColor.withOpacity(0.2)
                                    : themeProvider.textColor.withOpacity(0.5),
                                blurRadius: 25,
                                offset: const Offset(0, 12),
                              ),
                              BoxShadow(
                                color:
                                    themeProvider.buttonColor.withOpacity(0.3),
                                blurRadius: 30,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                              widget.images[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // ALT PANEL (Kaydırılabilir)
          DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: dynamicMaxSize,
            snap: true,
            snapSizes: [0.1, dynamicMaxSize],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: themeProvider.isDarkMode
                      ? themeProvider.cardColor
                      : themeProvider.textColor.withOpacity(0.3),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: themeProvider.textColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: themeProvider.textColor.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.photo_library,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "${viewModel.currentPageIndex + 1}/${widget.images.length}",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    // 🟢 GridView yerine SliverGrid
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return GestureDetector(
                              onTap: () {
                                viewModel.goToPage(index);
                              },
                              child: AnimatedScale(
                                scale: viewModel.currentPageIndex == index
                                    ? 1.0
                                    : 0.95, // Seçili resmin boyutunu büyüt
                                duration: const Duration(
                                    milliseconds: 300), // Animasyon süresi
                                curve: Curves.easeInOut, // Animasyon geçişi
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: viewModel.currentPageIndex == index
                                          ? themeProvider.buttonColor
                                              .withOpacity(0.8)
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: themeProvider.buttonColor
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      widget.images[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: widget.images.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
