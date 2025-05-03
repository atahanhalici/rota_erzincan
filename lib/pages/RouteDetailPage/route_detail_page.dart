// ✅ RouteDetailPage (Kategori sayfası yapısına benzetilmiş)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/constants/string_constants.dart';
import 'package:rota_erzincan/pages/RouteDetailPage/new_route_modal_view_model.dart';
import 'package:rota_erzincan/pages/RouteDetailPage/route_detail_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/NewRouteModal.dart';
import 'package:rota_erzincan/widgets/RouteDetailSliverAppBar.dart';
import 'package:rota_erzincan/widgets/DetailTopBarShadow.dart';
import 'package:rota_erzincan/widgets/StatusBarOverlay.dart';
import 'package:rota_erzincan/widgets/CustomBottomNavBar.dart';
import 'package:rota_erzincan/widgets/ShimmerCard.dart';
import 'package:rota_erzincan/widgets/RouteContentSliver.dart';
import 'package:rota_erzincan/widgets/StickyHeaderWithWidget.dart';

class RouteDetailPage extends StatefulWidget {
  const RouteDetailPage({super.key});

  @override
  State<RouteDetailPage> createState() => _RouteDetailPageState();
}

class _RouteDetailPageState extends State<RouteDetailPage>
    with SingleTickerProviderStateMixin {
  late RouteDetailPageViewModel viewModel;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  bool _viewModelInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_viewModelInitialized) {
      viewModel = Provider.of<RouteDetailPageViewModel>(context, listen: true);
      _viewModelInitialized = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double appBarHeight = kToolbarHeight + statusBarHeight;
    final double expandedHeight = appBarHeight + 160;

    return SafeArea(
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: themeProvider.backgroundColor,
        body: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                RouteDetailSliverAppBar(
                  themeProvider: themeProvider,
                  viewModel: viewModel,
                  appBarHeight: appBarHeight,
                  expandedHeight: expandedHeight,
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                StickyHeaderWithWidget(
                  title: viewModel.route.title,
                  subtitle: viewModel.route.subtitle,
                  subtitleWidget: Row(
                    children: [
                      Icon(Icons.route,
                          size: 16,
                          color:
                              themeProvider.textColor.withValues(alpha: 0.6)),
                      const SizedBox(width: 4),
                      Text(
                        "${viewModel.route.distanceKm} ${'unitKilometer'.tr()}",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: themeProvider.textColor.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.access_time_rounded,
                          size: 16,
                          color:
                              themeProvider.textColor.withValues(alpha: 0.6)),
                      const SizedBox(width: 4),
                      Text(
                        _formatDuration(viewModel.route.duration),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: themeProvider.textColor.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  onStartRoutePressed: () {
                    viewModel.openMapApp(context, themeProvider);
                  },
                  showButton: viewModel.convertedStops.isNotEmpty,
                  onAddPressed: () async {
                    if (!viewModel.route.isUserAdded) {
                      // ❌ Sabit rota, düzenlenemez → fonksiyon çalışmaz
                      return;
                    }
                    if (viewModel.route.stops.isEmpty) {
                      return;
                    }

                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) {
                        return ChangeNotifierProvider(
                          create: (_) => NewRouteModalViewModel(
                              editingRoute: viewModel.route),
                          child: NewRouteModal(editingRoute: viewModel.route),
                        );
                      },
                    );

                    // ✅ Modal kapandıktan sonra veriyi yeniden yükle
                    await viewModel.loadContent();
                  },
                  isUserAdded: viewModel.route.isUserAdded,
                ),
                ...[
                  if (viewModel.isLoading)
                    _buildLoadingSliver(themeProvider)
                  else if (viewModel.convertedStops.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 48),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline_rounded,
                                size: 48,
                                color: themeProvider.textColor
                                    .withValues(alpha: 0.4)),
                            const SizedBox(height: 16),
                            Text(
                              'routeNoStopsText'.tr(),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: themeProvider.textColor
                                    .withValues(alpha: 0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    // 🔥 RouteContentSliver zaten Sliver döndürüyorsa direkt çağır
                    RouteContentSliver(
                      themeProvider: themeProvider,
                      controller: _controller,
                      viewModel: viewModel,
                      items: viewModel.convertedStops,
                      scaffoldContext: context,
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 130)),
                  ]
                ]
              ],
            ),
            DetailTopBarShadow(
                themeProvider: themeProvider,
                onActionPressed: viewModel.navigateToSearch),
            StatusBarOverlay(themeProvider: themeProvider),
            const Positioned(
              left: 16,
              right: 16,
              bottom: 0,
              child: CustomBottomNavBar(currentIndex: 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSliver(ThemeProvider themeProvider) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: List.generate(
            1,
            (index) => ShimmerCard(
              themeProvider: themeProvider,
              controller: _controller,
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
