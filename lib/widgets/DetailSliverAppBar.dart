import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/pages/CategoryDetail/category_detail_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';

class DetailSliverAppBar extends StatelessWidget {
  final ThemeProvider themeProvider;
  final CategoryDetailViewModel viewModel;
  final double appBarHeight;
  final double expandedHeight;

  const DetailSliverAppBar({
    super.key,
    required this.themeProvider,
    required this.viewModel,
    required this.appBarHeight,
    required this.expandedHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: themeProvider.backgroundColor,
      title: Row(
        children: [
          Container(
            width: 5,
            height: 28,
            decoration: BoxDecoration(
              color: themeProvider.buttonColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.category.title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: themeProvider.textColor,
                ),
              ),
              Text(
                viewModel.category.subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: themeProvider.textColor.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: Padding(
            padding: EdgeInsets.only(top: appBarHeight),
            child: Hero(
              tag: 'category_${viewModel.category.title}',
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FadeInImage.assetNetwork(
                      placeholder: ImageConstants.loading,
                      image: viewModel.category.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}