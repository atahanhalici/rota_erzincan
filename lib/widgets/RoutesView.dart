import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/pages/routesPage/routes_page_view_model.dart';
import 'package:rota_erzincan/widgets/CategoryCardShimmer.dart';
import 'package:rota_erzincan/widgets/RouteCard.dart';

class RoutesView extends StatelessWidget {
  final AnimationController controller;

  const RoutesView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final _routesModel =
        Provider.of<RoutesPageViewModel>(context, listen: true);

    final items = _routesModel.routeItems;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _routesModel.isLoading
            ? List.generate(
                5,
                (index) {
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
            : List.generate(
                items.length,
                (index) {
                  final item = items[index];
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
                      child: RouteCard(
                        item: item,
                        onTap: () {
                          // _routesModel.navigateToPage(item);
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
