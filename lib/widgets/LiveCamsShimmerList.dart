import 'package:flutter/material.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:shimmer/shimmer.dart';

class LiveCamsShimmerList extends StatelessWidget {
  final ThemeProvider themeProvider;
  final AnimationController controller;

  const LiveCamsShimmerList({
    super.key,
    required this.themeProvider,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final delay = 0.2 + (index * 0.1);
        final delayedAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              delay < 1.0 ? delay : 0.9,
              (delay + 0.2) < 1.0 ? (delay + 0.2) : 1.0,
              curve: Curves.easeOutQuart,
            ),
          ),
        );

        return AnimatedBuilder(
          animation: delayedAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - delayedAnimation.value)),
              child: Opacity(
                opacity: delayedAnimation.value,
                child: child,
              ),
            );
          },
          child: Shimmer.fromColors(
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
          ),
        );
      },
    );
  }
}
