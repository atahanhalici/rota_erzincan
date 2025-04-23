import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:rota_erzincan/init/navigation/navigation_service.dart';
import 'package:rota_erzincan/pages/LiveCamsPage/live_cams_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/widgets/AppBar.dart';
import 'package:rota_erzincan/widgets/CustomBottomNavBar.dart';
import 'package:rota_erzincan/widgets/LiveCamsCameraList.dart';
import 'package:rota_erzincan/widgets/LiveCamsHeader.dart';
import 'package:rota_erzincan/widgets/LiveCamsShimmerList.dart';
import 'package:rota_erzincan/widgets/LiveCamsSubtitle.dart';
import 'package:rota_erzincan/widgets/VideoPlayerBody.dart';

class LiveCamsPage extends StatefulWidget {
  const LiveCamsPage({super.key});

  @override
  State<LiveCamsPage> createState() => _LiveCamsPageState();
}

class _LiveCamsPageState extends State<LiveCamsPage>
    with SingleTickerProviderStateMixin {
  late LiveCamsPageViewModel viewModel;

  late AnimationController _controller;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: -50, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goFullScreen(String url, String title) {
    NavigationService.instance.navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => LiveCamsPageViewModel(),
          child: FastLiveStream(
            url: url,
            title: title,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    viewModel = Provider.of<LiveCamsPageViewModel>(context, listen: true);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
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
            child: Appbar(
              actionIcon: const Icon(
                Icons.search,
                size: 30,
                color: ColorConstants.buttonColor,
              ),
              onActionPressed: () {
                // Arama butonuna basıldığında yapılacaklar
              },
            )),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LiveCamsHeaderTitle(
                animation: _headerAnimation,
                themeProvider: themeProvider,
              ),
              LiveCamsSubtitle(
                animation: _controller,
                themeProvider: themeProvider,
              ),
              Expanded(
                child: viewModel.isLoading
                    ? LiveCamsCameraList(
                        themeProvider: themeProvider,
                        cameras: viewModel.cameras,
                        controller: _controller,
                        onTap: _goFullScreen,
                      )
                    : LiveCamsShimmerList(
                        themeProvider: themeProvider,
                        controller: _controller,
                      ),
              ),
            ],
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
  }
}

class FastLiveStream extends StatefulWidget {
  final String url;
  final String title;

  const FastLiveStream({required this.url, required this.title});

  @override
  State<FastLiveStream> createState() => _FastLiveStreamState();
}

class _FastLiveStreamState extends State<FastLiveStream> {
  bool _isReady = false;
  late LiveCamsPageViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = Provider.of<LiveCamsPageViewModel>(context, listen: false);
    vm.initVideoController(widget.url, () {
      if (mounted) {
        setState(() => _isReady = true);
      }
    });
  }

  @override
  void dispose() {
    vm.disposeVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    SystemChrome.setEnabledSystemUIMode(
      orientation == Orientation.landscape
          ? SystemUiMode.immersiveSticky
          : SystemUiMode.edgeToEdge,
    );

    return GestureDetector(
      onTap: vm.showControlsTemporarily,
      child: WillPopScope(
        onWillPop: () async {
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
          await Future.delayed(const Duration(milliseconds: 250));
          if (mounted) {
            NavigationService.instance.navigatorKey.currentState?.pop();
          }
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: orientation == Orientation.portrait
              ? AppBar(
                  backgroundColor: Colors.black,
                  iconTheme: const IconThemeData(color: Colors.white),
                  centerTitle: true,
                  title: Text(widget.title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                )
              : null,
          body: VideoPlayerBody(isReady: _isReady),
        ),
      ),
    );
  }
}
