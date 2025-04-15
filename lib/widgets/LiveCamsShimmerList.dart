import 'package:flutter/material.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:shimmer/shimmer.dart';

class LiveCamsShimmerList extends StatelessWidget {
  final ThemeProvider themeProvider;

  const LiveCamsShimmerList({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFFE0E0E0),
          highlightColor: const Color(0xFFF5F5F5),
          period: const Duration(milliseconds: 1000),
          child: Container(
            margin: const EdgeInsets.only(bottom: 24),
            height: 240,
            decoration: BoxDecoration(
              color: themeProvider.shimmerColor,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        );
      },
    );
  }
}