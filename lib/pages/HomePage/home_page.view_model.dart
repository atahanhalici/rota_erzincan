import 'package:flutter/material.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/models/CategoryItem.dart';
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
    navigationService.navigateToPage(
      "/details",
      CategoryContentItem(
        id: 'content_0',
        title: 'Terzibaba Camii ve Külliyesi 1',
        description:
            'Bu Terzibaba Camii ve Külliyesi 1 kategorisi için içerik 1 açıklamasıdır.',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc',
      ),
    );
  }

  void navigateToErgan(BuildContext context) {
    navigationService.navigateToPage("/ergan", null);
  }

  void navigateToCategoryDetail(
      String title, String subtitle, String imageUrl, IconData icon) {
    CategoryItem _categoryItem = CategoryItem(
        icon: icon, title: title, subtitle: subtitle, imageUrl: imageUrl);
    navigationService.navigateToCategoryDetail(_categoryItem);
  }

  void navigateBottomBar(BuildContext context, int index) {
    if (index == 0) {
      navigationService.navigateToPageClear("/home", null);
    } else if (index == 1) {
      navigationService.navigateToPageClear("/categories", null);
    } else if (index == 2) {
      navigationService.navigateToPageClear("/gallery", null);
    } else if (index == 3) {
      navigationService.navigateToPageClear("/routes", null);
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
