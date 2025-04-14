import 'package:flutter/material.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/CategoryModel.dart';
import 'package:rota_erzincan/models/FeatureModel.dart';
import 'package:rota_erzincan/services/api_service.dart';

class HomePageViewModel extends ChangeNotifier with BaseViewModel {
  final ApiService _apiService = ApiService();

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;
  List<FeatureModel> _features = [];
  List<FeatureModel> get features => _features;

  bool isLoading = false;

  // Animasyon kontrolleri
  late AnimationController animationController;
  late Animation<double> headerAnimation;
  late Animation<double> subHeaderAnimation;
  late Animation<double> categoryHeaderAnimation;
  late Animation<double> categoryListAnimation;
  late Animation<double> infoCardAnimation;

  HomePageViewModel() {
    fetchCategoryData();
  }

  void initAnimations(TickerProvider vsync) {
    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: vsync,
    );

    headerAnimation = Tween<double>(begin: -50, end: 0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    subHeaderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    categoryHeaderAnimation = Tween<double>(begin: -30, end: 0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    categoryListAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOutQuart),
      ),
    );

    infoCardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    // Animasyonu başlat
    animationController.forward();
  }

  void disposeAnimations() {
    animationController.dispose();
  }

  void resetAndPlayAnimations() {
    animationController.reset();
    animationController.forward();
  }

  Future<void> fetchCategoryData() async {
    isLoading = true;
    notifyListeners();

    _categories = await _apiService.fetchCategories();
    _features = await _apiService.fetchFeatures();

    isLoading = false;
    notifyListeners();
  }

  void navigateToDetails(BuildContext context) {
    navigationService.navigateToPage("/details", null);
  }

  void navigateBottomBar(BuildContext context, int index) {
    if (index == 0) {
      navigationService.navigateToPageClear("/home", null);
    } else if (index == 1) {
      //navigationService.navigateToPage("/home", null);
    } else if (index == 2) {
      navigationService.navigateToPageClear("/gallery", null);
    }
  }

  void openStory(BuildContext context, CategoryModel model) {
    int currentIndex = categories.indexOf(model);
    navigationService.navigateToPage(
      "/story",
      {
        'list': categories,
        'index': currentIndex,
      },
    );
  }
}
