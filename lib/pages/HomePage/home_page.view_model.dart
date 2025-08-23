import 'package:easy_localization/easy_localization.dart';
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

  Future<void> fetchCategoryData(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final langCode = context.locale.languageCode;
    _categories = langCode == 'tr'
        ? await _apiService.fetchCategoriesTr()
        : langCode == 'pl'
            ? await _apiService.fetchCategoriesPl()
            : await _apiService.fetchCategoriesEn();

    _features = langCode == 'tr'
        ? await _apiService.fetchFeaturesTr()
        : langCode == 'pl'
            ? await _apiService.fetchFeaturesPl()
            : await _apiService.fetchFeaturesEn();

    isLoading = false;
    notifyListeners();
  }

  void navigateToDetails(BuildContext context,
      {String? imageUrl, String? title}) {
    if (imageUrl != null) {
      Navigator.pop(context);
    }
    navigationService.navigateToDetailsPage(
      CategoryContentItem(
        id: 'content_0',
        title: title ?? 'Spodek Arena',
        description: 'Spodek Arena kategorisi için içerik açıklamasıdır.',
        imageUrl: imageUrl ??
            'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/spodek.jpg?alt=media&token=d4498059-0877-442a-a672-909a130fb2ba',
        latitude: 50.2599,
        longitude: 19.0216,
      ),
    );
  }

  void navigateToErgan(BuildContext context) {
    navigationService.navigateToPage("/ergan", null);
  }

  void navigateToEmergencyAssemblyAreas(BuildContext context) {
    Navigator.pop(context);
    navigationService.navigateToPage("/emergencyAssemblyAreas", null);
  }

  void navigateToGiveYourOpinion(BuildContext context) {
    Navigator.pop(context);
    navigationService.navigateToPage("/giveYourOpinion", null);
  }


  void navigateToSearch() {
    navigationService.navigateToSearchPage();
  }

  void navigateToCategoryDetail(
    String title, String subtitle, String imageUrl, String iconName, int id) {
  CategoryItem _categoryItem = CategoryItem(
    iconName: iconName,
    title: title,
    subtitle: subtitle,
    imageUrl: imageUrl,
    id: id,
  );

  navigationService.navigateToCategoryDetail(_categoryItem);
}

void navigateBottomBar(BuildContext context, int index,
    {String? title,
    String? subtitle,
    String? imageUrl,
    String? iconName,
    int? id}) {
  if (index == 0) {
    navigationService.navigateToPageClear("/home", null);
  } else if (index == 1) {
    navigationService.navigateToPageClear("/categories", null);
  } else if (index == 2) {
    navigationService.navigateToPageClear("/gallery", null);
  } else if (index == 3) {
    navigationService.navigateToPageClear("/routes", null);
  } else if (index == 4) {
    if (title != null &&
        subtitle != null &&
        imageUrl != null &&
        iconName != null &&
        id != null) {
      navigationService.navigateToCategoryDetailClear(
        CategoryItem(
          title: title,
          subtitle: subtitle,
          imageUrl: imageUrl,
          iconName: iconName,
          id: id,
        ),
      );
    }
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
