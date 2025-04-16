import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/pages/ErganKayakMerkeziPage/ergan_kayak_merkezi_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/AboutSectionWidget.dart';
import 'package:rota_erzincan/widgets/AppBar.dart';
import 'package:rota_erzincan/widgets/CustomBottomNavBar.dart';
import 'package:rota_erzincan/widgets/FacilityHeaderWidget.dart';
import 'package:rota_erzincan/widgets/FacilityListWidget.dart';
import 'package:rota_erzincan/widgets/HeroSectionWidget.dart';
import 'package:rota_erzincan/widgets/WeatherSectionWidget.dart';

class ErganKayakMerkeziPage extends StatefulWidget {
  const ErganKayakMerkeziPage({super.key});

  @override
  State<ErganKayakMerkeziPage> createState() => _ErganKayakMerkeziPageState();
}

class _ErganKayakMerkeziPageState extends State<ErganKayakMerkeziPage>
    with SingleTickerProviderStateMixin {
  late ErganViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _viewModel = ErganViewModel(vsync: this, themeProvider: themeProvider);
    _viewModel.init();
  }

  @override
  void dispose() {
    _viewModel.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ErganViewModel>.value(
      value: _viewModel,
      child: Consumer2<ThemeProvider, ErganViewModel>(
        builder: (context, themeProvider, viewModel, _) {
          return Scaffold(
            backgroundColor: themeProvider.backgroundColor,
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: themeProvider.cardColor.withOpacity(0.85),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeProvider.isDarkMode
                          ? Colors.black.withOpacity(0.4)
                          : Colors.grey.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Appbar(),
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeroSectionWidget(
                        animation: viewModel.headerAnimation,
                        themeProvider: themeProvider,
                      ),
                      WeatherSectionWidget(
                        animation: viewModel.infoCardsAnimation,
                        themeProvider: themeProvider,
                      ),
                      FacilityHeaderWidget(
                        animation: viewModel.facilityHeaderAnimation,
                        themeProvider: themeProvider,
                      ),
                      FacilityListWidget(
                        animation: viewModel.facilityListAnimation,
                        animationController: viewModel.animationController,
                        themeProvider: themeProvider,
                      ),
                      AboutSectionWidget(
                        animation: viewModel.aboutSectionAnimation,
                        themeProvider: themeProvider,
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  left: 16,
                  right: 16,
                  bottom: 0,
                  child: CustomBottomNavBar(
                    currentIndex: 0,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
