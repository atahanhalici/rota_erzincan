import 'package:flutter/material.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
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

  Future<void> navigateToPage(CategoryItem item) async {
    if (item.title.contains("Ulaşım") || item.title.contains("Gelirim")) {
      navigationService.navigateToPage(
        "/details",
        CategoryContentItem(
            id: 'content_0',
            title: 'Terzibaba Camii ve Külliyesi 1',
            description:
                'Bu Terzibaba Camii ve Külliyesi 1 kategorisi için içerik 1 açıklamasıdır.',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc',
            latitude: 39.7508,
            longitude: 39.4977),
      );
    } else {
      navigationService.navigateToCategoryDetail(item);
    }
  }

   void navigateToSearch() {
    navigationService.navigateToSearchPage();
  }
}
