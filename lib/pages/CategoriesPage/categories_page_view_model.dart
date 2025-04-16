import 'package:flutter/material.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/CategoryItem.dart';
import 'package:rota_erzincan/services/api_service.dart';

class CategoriesPageViewModel extends ChangeNotifier with BaseViewModel {
  final ApiService _apiService = ApiService();
  List<CategoryItem> categoryItems = [];
  bool isLoading = true;

  CategoriesPageViewModel() {
    fetchAllCategories();
  }

  Future<void> fetchAllCategories() async {
    isLoading = true;
    notifyListeners(); // shimmer başlasın

    categoryItems = await _apiService.fetchAllCategories();

    isLoading = false;
    notifyListeners(); // shimmer dursun, liste gözüksün
  }
}
