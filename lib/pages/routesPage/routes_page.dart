// 🔹 routes_page.dart (temizlenmiş)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/pages/routesPage/routes_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/AppBar.dart';
import 'package:rota_erzincan/widgets/CustomBottomNavBar.dart';
import 'package:rota_erzincan/widgets/CustomDrawer.dart';
import 'package:rota_erzincan/widgets/RoutesHeader.dart';
import 'package:rota_erzincan/widgets/RoutesView.dart';
import 'package:rota_erzincan/widgets/UserRoutesCard.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _headerAnimation;
  late Animation<Offset> _routesCardSlideAnimation;
  late final ScrollController _scrollController;
  late RoutesPageViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _headerAnimation = Tween<double>(begin: -50, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _routesCardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<RoutesPageViewModel>(context, listen: false);
      _viewModel.fetchAllRoutes(context);
      _controller.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final viewModel = Provider.of<RoutesPageViewModel>(context, listen: false);
    viewModel.loadSavedRoutes();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final viewModel = Provider.of<RoutesPageViewModel>(context);

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: themeProvider.backgroundColor,
        drawer: CustomDrawer(
          toggleTheme: themeProvider.toggleTheme,
          isDarkMode: themeProvider.isDarkMode,
          textColor: themeProvider.textColor,
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: themeProvider.cardColor.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: themeProvider.isDarkMode
                      ? Colors.black.withValues(alpha: 0.4)
                      : Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Appbar(
              actionIcon: const Icon(
                Icons.search,
                size: 30,
                color: ColorConstants.buttonColor,
              ),
              onActionPressed: () {
                viewModel.navigateToSearch();
              },
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                RoutesHeader(
                  headerAnimation: _headerAnimation,
                  controller: _controller,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 80),
                    children: [
                      UserRoutesCard(
                        viewModel: viewModel,
                        controller: _controller,
                        routesCardSlideAnimation: _routesCardSlideAnimation,
                        scrollController: _scrollController,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 4,
                              height: 24,
                              decoration: BoxDecoration(
                                color: themeProvider.buttonColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'routesReadyTitle'.tr(),
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: themeProvider.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RoutesView(controller: _controller),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomBottomNavBar(currentIndex: 3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
