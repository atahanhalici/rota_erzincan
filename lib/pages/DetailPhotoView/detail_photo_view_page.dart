import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/pages/DetailPhotoView/detail_photo_view_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/DraggableThumbnailSheet.dart';
import 'package:rota_erzincan/widgets/ShowPhotoDetails.dart';

class DetailPhotoView extends StatelessWidget {
  final String imageUrl;
  final String heroTag;
  final List<String> galleryImages;
  final int initialIndex;
  final String title;

  const DetailPhotoView({
    Key? key,
    required this.imageUrl,
    required this.heroTag,
    required this.galleryImages,
    required this.initialIndex,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DetailPhotoViewPageViewModel viewModel =
        Provider.of<DetailPhotoViewPageViewModel>(context, listen: true);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: themeProvider.textColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back,
                color: themeProvider.textColor,
                size: 20,
              ),
            ),
          ),
        ),
        title: LayoutBuilder(
          builder: (context, constraints) {
            return FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: themeProvider.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20, // maksimum fontSize, dar alanda küçülür
                  shadows: [
                    Shadow(
                      color: themeProvider.backgroundColor.withOpacity(0.5),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        centerTitle: true,
        actions: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => ShowPhotoDetails(
                    cardColor: themeProvider.cardColor,
                    textColor: themeProvider.textColor,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeProvider.buttonColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: themeProvider.buttonColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: viewModel.pageController,
                  itemCount: galleryImages.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Hero(
                        tag: index == initialIndex ? heroTag : 'image$index',
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
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
                            child: InteractiveViewer(
                              clipBehavior: Clip.none,
                              minScale: 0.5,
                              maxScale: 3.0,
                              child: FadeInImage.assetNetwork(
                                placeholder: ImageConstants
                                    .loading, // Yüklenirken gösterilecek resim
                                image: galleryImages[index],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: context.sized.dynamicHeight(0.1)),
            ],
          ),
          DraggableThumbnailSheet(
            // key: ValueKey(viewModel.currentPageIndex),
            images: galleryImages,
            currentIndex: viewModel.currentPageIndex,
            onThumbnailTap: viewModel.goToPage,
            backgroundColor: themeProvider.cardColor,
            buttonColor: themeProvider.buttonColor,
            textColor: themeProvider.textColor,
          ),
        ],
      ),
    );
  }
}
