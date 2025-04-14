import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/pages/HomePage/home_page.view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/DestinationCard.dart';
import 'package:shimmer/shimmer.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final viewModel = Provider.of<HomePageViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: themeProvider.buttonColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Erzincan'ı Keşfet",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: themeProvider.textColor,
                ),
              ),
            ],
          ),
        ),

        // Kategoriler Listesi (Veri Gelene Kadar Shimmer Efekti)
        if (viewModel.isLoading)
          _buildShimmerEffect(themeProvider) // Eğer veri yoksa shimmer göster
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.zero,
            itemCount: viewModel.features.length,
            itemBuilder: (context, index) {
              final feature = viewModel.features[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: DestinationCard(
                  title: feature.title,
                  subtitle: feature.subtitle,
                  imageUrl: feature.imageUrl,
                  icon: feature.icon,
                ),
              );
            },
          ),

        // Boş Alan (Bottom Padding)
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildShimmerEffect(ThemeProvider themeProvider) {
    return Column(
      children: List.generate(6, (index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Shimmer.fromColors(
            baseColor: const Color(0xFFE0E0E0), // açık gri
            highlightColor: const Color(0xFFF5F5F5), // daha açık
            period: const Duration(milliseconds: 1000),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: themeProvider.shimmerColor,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        );
      }),
    );
  }
}
