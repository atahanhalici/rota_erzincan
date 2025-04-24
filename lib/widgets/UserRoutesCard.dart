import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/constants/string_constants.dart';
import 'package:rota_erzincan/pages/RouteDetailPage/new_route_modal_view_model.dart';
import 'package:rota_erzincan/pages/routesPage/routes_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/NewRouteModal.dart';

class UserRoutesCard extends StatelessWidget {
  final RoutesPageViewModel viewModel;
  final AnimationController controller;
  final Animation<Offset> routesCardSlideAnimation;
  final ScrollController scrollController;

  const UserRoutesCard({
    super.key,
    required this.viewModel,
    required this.controller,
    required this.routesCardSlideAnimation,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FadeTransition(
      opacity: controller,
      child: SlideTransition(
        position: routesCardSlideAnimation,
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 25),
          decoration: BoxDecoration(
            color: themeProvider.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: themeProvider.buttonColor.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: viewModel.toggleUserRoutes,
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 4,
                              height: 25,
                              decoration: BoxDecoration(
                                color: themeProvider.buttonColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'addToRouteTitle'.tr(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: themeProvider.textColor,
                                    ),
                                  ),
                                  if (viewModel.showUserRoutes &&
                                      viewModel.userRoutes.isNotEmpty)
                                    Text(
                                      'swipeToDeleteRoutes'.tr(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: themeProvider.textColor
                                            .withValues(alpha: 0.7),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Icon(
                              viewModel.showUserRoutes
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: themeProvider.textColor,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    layoutBuilder:
                        (Widget? currentChild, List<Widget> previousChildren) {
                      return currentChild ?? const SizedBox.shrink();
                    },
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: viewModel.showUserRoutes
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              key: const ValueKey("routes-visible"),
                              children: [
                                if (viewModel.userRoutes.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8),
                                    child: Text(
                                      'noUserRoutesText'.tr(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: themeProvider.textColor
                                            .withValues(alpha: 0.7),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  )
                                else ...[
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxHeight: 300),
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      controller: scrollController,
                                      child: ListView.builder(
                                        controller: scrollController,
                                        shrinkWrap: true,
                                        itemCount: viewModel.userRoutes.length,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final route =
                                              viewModel.userRoutes[index];
                                          return GestureDetector(
                                            onTap: () {
                                              viewModel.navigateToRouteDetails(
                                                  route);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                bottom: index ==
                                                        viewModel.userRoutes
                                                                .length -
                                                            1
                                                    ? 0
                                                    : 10,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Stack(
                                                  children: [
                                                    Positioned.fill(
                                                      child: Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 20),
                                                        color: Colors.redAccent,
                                                        child: const Icon(
                                                            Icons.delete,
                                                            color: Colors.white,
                                                            size: 28),
                                                      ),
                                                    ),
                                                    Dismissible(
                                                      key: Key(route.id),
                                                      direction:
                                                          DismissDirection
                                                              .endToStart,
                                                      resizeDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  200),
                                                      onDismissed: (direction) {
                                                        viewModel.removeRouteAt(
                                                            index);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    color: Colors
                                                                        .white),
                                                                const SizedBox(
                                                                    width: 10),
                                                                Expanded(
                                                                  child: Text(
                                                                    '${route.title}${'routeDeletedSuffix'.tr()}',
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            backgroundColor:
                                                                Colors.green
                                                                    .shade700,
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(12),
                                                            duration:
                                                                const Duration(
                                                                    seconds: 2),
                                                          ),
                                                        );
                                                      },
                                                      background:
                                                          const SizedBox(),
                                                      child: Container(
                                                        color: themeProvider
                                                                .isDarkMode
                                                            ? Colors.grey[850]
                                                            : Colors.grey[100],
                                                        child: ListTile(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      16,
                                                                  vertical: 8),
                                                          title: Text(
                                                            route.title,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  themeProvider
                                                                      .textColor,
                                                            ),
                                                          ),
                                                          subtitle: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.route,
                                                                size: 16,
                                                                color: themeProvider
                                                                    .textColor
                                                                    .withValues(
                                                                        alpha:
                                                                            0.6),
                                                              ),
                                                              const SizedBox(
                                                                  width: 4),
                                                              Text(
                                                                  "${route.distanceKm} ${'unitKilometer'.tr()}",
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        12,
                                                                    color: themeProvider
                                                                        .textColor
                                                                        .withValues(
                                                                            alpha:
                                                                                0.6),
                                                                  )),
                                                              const SizedBox(
                                                                  width: 12),
                                                              Icon(
                                                                Icons
                                                                    .access_time_rounded,
                                                                size: 16,
                                                                color: themeProvider
                                                                    .textColor
                                                                    .withValues(
                                                                        alpha:
                                                                            0.6),
                                                              ),
                                                              const SizedBox(
                                                                  width: 4),
                                                              Text(
                                                                  _formatDuration(
                                                                      route
                                                                          .duration),
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        12,
                                                                    color: themeProvider
                                                                        .textColor
                                                                        .withValues(
                                                                            alpha:
                                                                                0.6),
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                        ),
                                        builder: (context) =>
                                            ChangeNotifierProvider(
                                          create: (_) =>
                                              NewRouteModalViewModel(),
                                          child: const NewRouteModal(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 16),
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            themeProvider.buttonColor,
                                            themeProvider.buttonColor
                                                .withValues(alpha: 0.8),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: themeProvider.buttonColor
                                                .withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                                Icons.add_location_alt_rounded,
                                                color: Colors.white,
                                                size: 20),
                                            const SizedBox(width: 8),
                                            Text(
                                              'newRouteTitle'.tr(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    return StringConstants.formatDuration(duration);
  }
}
