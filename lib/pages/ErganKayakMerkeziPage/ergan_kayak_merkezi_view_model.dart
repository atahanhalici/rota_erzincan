import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/FacilityModel.dart';
import 'package:rota_erzincan/models/InfoCardModel.dart';
import 'package:rota_erzincan/services/api_service.dart';
import 'package:rota_erzincan/theme_provider.dart';

class ErganViewModel extends ChangeNotifier with BaseViewModel {
  final ApiService _apiService = ApiService();
  late AnimationController animationController;
  late Animation<double> headerAnimation;
  late Animation<double> infoCardsAnimation;
  late Animation<double> facilityHeaderAnimation;
  late Animation<double> facilityListAnimation;
  late Animation<double> aboutSectionAnimation;

  late ThemeProvider themeProvider;
  bool isLoading = false;
  bool isInitialized = false;
  List<InfoCardModel> infoCards = [];
  List<FacilityModel> facilityItems = [];

  void navigateToSearch() {
    navigationService.navigateToSearchPage();
  }

  Future<void> init() async {
    if (isInitialized) return;

    isLoading = true;
    notifyListeners();

    // 🔽 Buraya API çağrıları

    infoCards = await _apiService.fetchInfoCards(); // örnek
    facilityItems = await _apiService.fetchFacilityItems(); // örnek

    isLoading = false;
    isInitialized = true;
    notifyListeners();
  }

  ErganViewModel({
    required TickerProvider vsync,
    required this.themeProvider,
  }) {
    _initAnimations(vsync);
  }

  void _initAnimations(TickerProvider vsync) {
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1400),
    );

    headerAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    infoCardsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );

    facilityHeaderAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    facilityListAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );

    aboutSectionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    animationController.forward();
  }

  void navigateToCameras() {
    navigationService.navigateToPage("/cameras", null);
  }

  Widget get animatedTextKit => AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText('Heyecan dolu kayak deneyimi',
              speed: const Duration(milliseconds: 100), cursor: ''),
          TypewriterAnimatedText('Kış sporları cenneti',
              speed: const Duration(milliseconds: 100), cursor: ''),
          TypewriterAnimatedText('Kar keyfi sizi bekliyor',
              speed: const Duration(milliseconds: 100), cursor: ''),
        ],
        repeatForever: true,
        pause: const Duration(milliseconds: 1500),
      );

  void disposeController() {
    animationController.dispose();
  }
}
