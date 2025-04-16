import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/pages/CategoriesPage/categories_page_view_model.dart';
import 'package:rota_erzincan/widgets/CategoryCard.dart';
import 'package:rota_erzincan/widgets/CategoryCardShimmer.dart';

class CategoriesView extends StatelessWidget {
  final AnimationController controller;

  const CategoriesView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final _categoriesModel =
        Provider.of<CategoriesPageViewModel>(context, listen: true);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _categoriesModel.isLoading
            ? ListView.builder(
                itemCount: 5, // Şu an için 5 shimmer item
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 120, top: 8),
                itemBuilder: (context, index) {
                  final delay = 0.2 + (index * 0.1);
                  final delayedAnimation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
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
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: CategoryCardShimmer(),
                    ),
                  );
                },
              )
            : ListView.builder(
                itemCount: _categoriesModel.categoryItems.length,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 120, top: 8),
                itemBuilder: (context, index) {
                  final item = _categoriesModel.categoryItems[index];
                  final delay = 0.2 + (index * 0.1);
                  final delayedAnimation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: CategoryCard(
                        item: item,
                        onTap: () {
                          _categoriesModel.navigateToPage(item.title);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
