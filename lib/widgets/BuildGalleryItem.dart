import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/pages/DetailPhotoView/detail_photo_view_page.dart';
import 'package:rota_erzincan/pages/DetailPhotoView/detail_photo_view_page_view_model.dart';

class BuildGalleryItem extends StatelessWidget {
  final int index;
  final AnimationController controller;
  final List<String> galleryUrls;
  final String imageUrl;
  final String title;

  const BuildGalleryItem({
    super.key,
    required this.index,
    required this.controller,
    required this.galleryUrls,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'gallery_image_$imageUrl', // unique olsun diye url kullandık
      child: Material(
        borderRadius: BorderRadius.circular(18),
        elevation: 6,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => DetailPhotoViewPageViewModel(
                    galleryUrls.indexOf(imageUrl), // 🎯 Doğru index burada
                  ),
                  child: DetailPhotoView(
                    imageUrl: imageUrl,
                    heroTag: 'gallery_image_$imageUrl',
                    galleryImages: galleryUrls,
                    initialIndex: galleryUrls.indexOf(imageUrl),
                    title: 'galleryItemTitle'.tr(),
                  ),
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              fit: StackFit.expand,
              children: [
                FadeInImage.assetNetwork(
                  placeholder: ImageConstants.loading,
                  image: imageUrl,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      ImageConstants.loading,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                        stops: const [0.7, 1.0],
                      ),
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: const Alignment(-0.8, -0.8),
                            end: const Alignment(0.8, 0.8),
                            colors: [
                              Colors.white.withValues(alpha: 0.0),
                              Colors.white.withValues(
                                  alpha: 0.2 *
                                      math.sin(controller.value * math.pi)),
                              Colors.white.withValues(alpha: 0.0),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 1),
                                blurRadius: 3,
                                color: Colors.black.withValues(alpha: 0.5),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.zoom_in,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
