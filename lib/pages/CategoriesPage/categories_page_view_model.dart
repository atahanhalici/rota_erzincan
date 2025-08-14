import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/CategoryItem.dart';
import 'package:rota_erzincan/services/api_service.dart';

class CategoriesPageViewModel extends ChangeNotifier with BaseViewModel {
  final ApiService _apiService = ApiService();
  List<CategoryItem> categoryItems = [];
  bool isLoading = true;

  Future<void> fetchAllCategories(BuildContext context) async {
    isLoading = true;
    notifyListeners(); // shimmer başlasın
    final langCode = context.locale.languageCode;
    categoryItems = langCode == 'tr'
        ? await _apiService.fetchAllCategoriesTr()
        : await _apiService.fetchAllCategoriesEn();

    isLoading = false;
    notifyListeners(); // shimmer dursun, liste gözüksün
  }

  Future<void> navigateToPage(CategoryItem item) async {
    navigationService.navigateToCategoryDetail(item);
  }

  void navigateToSearch() {
    navigationService.navigateToSearchPage();
  }
}
