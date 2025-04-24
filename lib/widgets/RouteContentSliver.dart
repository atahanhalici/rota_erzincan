import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/constants/string_constants.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/pages/RouteDetailPage/route_detail_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/services/database_helper.dart';

class RouteContentSliver extends StatelessWidget {
  final ThemeProvider themeProvider;
  final RouteDetailPageViewModel viewModel;
  final AnimationController controller;
  final List<CategoryContentItem> items;
  final BuildContext scaffoldContext;
  const RouteContentSliver(
      {super.key,
      required this.themeProvider,
      required this.viewModel,
      required this.controller,
      required this.items,
      required this.scaffoldContext});

  @override
  Widget build(BuildContext context) {
    if (!viewModel.route.isUserAdded) {
      return _buildStaticSliver();
    } else {
      return SliverToBoxAdapter(
        child: ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) => _onReorder(oldIndex, newIndex),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildCard(
              context,
              item,
              index,
              key: ValueKey(item.id),
            );
          },
        ),
      );
    }
  }

  Widget _buildStaticSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = items[index];
          final delay = 0.2 + (index * 0.1);
          final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
            animation: animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 50 * (1 - animation.value)),
                child: Opacity(opacity: animation.value, child: child),
              );
            },
            child: _buildCard(
              context,
              item,
              index,
              key: ValueKey(item.id),
            ),
          );
        },
        childCount: items.length,
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    CategoryContentItem item,
    int index, {
    required Key key,
  }) {
    final isUserAdded = viewModel.route.isUserAdded;
    final card = Container(
      height: 130,
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: themeProvider.isDarkMode
                ? Colors.black.withValues(alpha: 0.25)
                : Colors.grey.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => viewModel.navigateToPage(item),
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Hero(
              tag: 'content_${item.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: FadeInImage.assetNetwork(
                  placeholder: ImageConstants.loading,
                  image: item.imageUrl,
                  fit: BoxFit.cover,
                  width: 110,
                  height: 135,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: themeProvider.textColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.description,
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color:
                                themeProvider.textColor.withValues(alpha: 0.7),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.distanceFromUser != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              item.distanceFromUser! < 1000
                                  ? '${StringConstants.distancePrefix} ${StringConstants.distanceLessThanOne}'
                                  : '${StringConstants.distancePrefix} ${(item.distanceFromUser! / 1000).toStringAsFixed(1)}${StringConstants.distanceUnitKm}',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: themeProvider.textColor
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                      ],
                    ),
                    InkWell(
                      onTap: () => viewModel.navigateToStop(
                          context, themeProvider, item),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: themeProvider.buttonColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on_rounded,
                                  size: 16, color: Colors.white),
                              const SizedBox(width: 6),
                              Text(
                                StringConstants.goToMapButton,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // 🔒 Swipe KAPALIYSA: sadece kart
    if (!isUserAdded) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: card,
      );
    }
    // 🔓 Swipe AÇIKSA: arka plan + dismissible
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 130,
              color: Colors.redAccent,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete_forever,
                  color: Colors.white, size: 28),
            ),
          ),
          Dismissible(
            key: ValueKey(item.id),
            direction: DismissDirection.endToStart,
            resizeDuration: const Duration(milliseconds: 300),
            onDismissed: (_) => _deleteStop(context, index),
            child: card,
          ),
        ],
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    final db = await DatabaseHelper.instance.database;

    final moved = viewModel.contentItems.removeAt(oldIndex);
    viewModel.contentItems.insert(newIndex, moved);

    for (int i = 0; i < viewModel.contentItems.length; i++) {
      await db.update(
        'route_stops',
        {'stopOrder': i},
        where: 'routeId = ? AND id = ?',
        whereArgs: [viewModel.route.id, viewModel.contentItems[i].id],
      );
    }

    await viewModel.recalculateDistanceAndDuration();
  }

  void _deleteStop(BuildContext context, int index) async {
    final db = await DatabaseHelper.instance.database;
    final removed = viewModel.contentItems[index];
    await db.delete(
      'route_stops',
      where: 'routeId = ? AND id = ?',
      whereArgs: [viewModel.route.id, removed.id],
    );

    viewModel.contentItems.removeAt(index);
    await viewModel.recalculateDistanceAndDuration();
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${StringConstants.stopDeletedPrefix} ${removed.title}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: StringConstants.undoButtonLabel,
          textColor: Colors.white,
          onPressed: () async {
            await db.insert('route_stops', {
              'id': removed.id,
              'routeId': viewModel.route.id,
              'latitude': removed.latitude,
              'longitude': removed.longitude,
              'title': removed.title,
              'stopOrder': index,
            });
            viewModel.contentItems.insert(index, removed);
            await viewModel.recalculateDistanceAndDuration();
          },
        ),
      ),
    );
  }
}
