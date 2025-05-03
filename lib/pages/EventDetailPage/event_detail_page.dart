import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/models/MovieItem.dart';
import 'package:rota_erzincan/models/TheaterPlayItem.dart';
import 'package:rota_erzincan/pages/EventDetailPage/event_detail_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/CustomBottomNavBar.dart';
import 'package:rota_erzincan/widgets/DetailTopBarShadow.dart';
import 'package:rota_erzincan/widgets/EventSliverAppBar.dart';
import 'package:rota_erzincan/widgets/MovieCards.dart';
import 'package:rota_erzincan/widgets/StatusBarOverlay.dart';
import 'package:rota_erzincan/widgets/StickyHeader.dart';
import 'package:rota_erzincan/widgets/TheaterCard.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double appBarHeight = kToolbarHeight + statusBarHeight;
    final double expandedHeight = appBarHeight + 160;

    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = EventDetailViewModel();
        viewModel.initialize(args);
        viewModel.fetchData(context);
        return viewModel;
      },
      child: Consumer<EventDetailViewModel>(
        builder: (context, viewModel, _) {
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
                      EventSliverAppBar(
                        themeProvider: themeProvider,
                        viewModel: viewModel,
                        appBarHeight: appBarHeight,
                        expandedHeight: expandedHeight,
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 12)),
                      StickyHeader(
                        title: viewModel.title,
                        subtitle: viewModel.subtitle,
                      ),
                      viewModel.isLoading
                          ? _buildLoadingSliver(
                              themeProvider, viewModel.eventType)
                          : _buildContentSliver(viewModel, themeProvider),
                    ],
                  ),
                  DetailTopBarShadow(
                    themeProvider: themeProvider,
                    onActionPressed: viewModel.navigateToSearch,
                  ),
                  StatusBarOverlay(themeProvider: themeProvider),
                  const Positioned(
                    left: 16,
                    right: 16,
                    bottom: 0,
                    child: CustomBottomNavBar(currentIndex: 4),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingSliver(ThemeProvider themeProvider, String eventType) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return eventType == 'movie'
              ? ShimmerMovieCard(
                  themeProvider: themeProvider,
                )
              : ShimmerTheaterCard(themeProvider: themeProvider);
        },
        childCount: 6,
      ),
    );
  }

  Widget _buildContentSliver(
      EventDetailViewModel viewModel, ThemeProvider themeProvider) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = viewModel.items[index];
          if (item is MovieItem) {
            return MovieCard(
              item: item,
              themeProvider: themeProvider,
            );
          } else if (item is TheaterPlayItem) {
            return TheaterCard(item: item, themeProvider: themeProvider);
          } else {
            return const SizedBox.shrink();
          }
        },
        childCount: viewModel.items.length,
      ),
    );
  }
}
