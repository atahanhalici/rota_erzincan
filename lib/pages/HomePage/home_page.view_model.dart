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

  HomePageViewModel() {
    fetchCategoryData();
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
