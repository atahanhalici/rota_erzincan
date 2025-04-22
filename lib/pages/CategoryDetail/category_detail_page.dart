import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rota_erzincan/pages/CategoryDetail/category_detail_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/ContentSliver.dart';
import 'package:rota_erzincan/widgets/CustomBottomNavBar.dart';
import 'package:rota_erzincan/widgets/CustomDrawer.dart';
import 'package:rota_erzincan/widgets/DetailSliverAppBar.dart';
import 'package:rota_erzincan/widgets/DetailTopBarShadow.dart';
import 'package:rota_erzincan/widgets/ShimmerCard.dart';
import 'package:rota_erzincan/widgets/StatusBarOverlay.dart';
import 'package:rota_erzincan/widgets/StickyHeader.dart';
import 'package:provider/provider.dart';

class CategoryDetailPage extends StatefulWidget {
  const CategoryDetailPage({Key? key}) : super(key: key);

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage>
    with SingleTickerProviderStateMixin {
  late final CategoryDetailViewModel viewModel;
  late final AnimationController _controller;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      viewModel = Provider.of<CategoryDetailViewModel>(context, listen: true);

      viewModel.initialize();
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 900),
      )..forward();

      _isInitialized = true;
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
    return Scaffold(
      drawer: viewModel.category.title == "Bu Ayın Etkinlikleri"
          ? CustomDrawer(
              toggleTheme: themeProvider.toggleTheme,
              isDarkMode: themeProvider.isDarkMode,
              textColor: themeProvider.textColor,
            )
          : null,
      extendBodyBehindAppBar: false,
      backgroundColor: themeProvider.backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              DetailSliverAppBar(
                themeProvider: themeProvider,
                viewModel: viewModel,
                appBarHeight: appBarHeight,
                expandedHeight: expandedHeight,
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              StickyHeader(
                  title: viewModel.category.title,
                  subtitle: viewModel.category.subtitle),
              viewModel.isLoading
                  ? _buildLoadingSliver(themeProvider)
                  : ContentSliver(
                      themeProvider: themeProvider,
                      controller: _controller,
                      viewModel: viewModel,
                    ),
            ],
          ),
          DetailTopBarShadow(themeProvider: themeProvider),
          StatusBarOverlay(themeProvider: themeProvider),
          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: CustomBottomNavBar(
                currentIndex:
                    viewModel.category.title == "Bu Ayın Etkinlikleri" ? 4 : 1),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSliver(ThemeProvider themeProvider) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: List.generate(
              6,
              (index) => ShimmerCard(
                  themeProvider: themeProvider, controller: _controller)),
        ),
      ),
    );
  }
}
