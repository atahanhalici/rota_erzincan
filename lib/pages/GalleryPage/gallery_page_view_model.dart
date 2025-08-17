import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/PhotoModel.dart';
import 'package:rota_erzincan/services/api_service.dart';

class GalleryPageViewModel extends ChangeNotifier with BaseViewModel {
  final ApiService _apiService = ApiService();

  List<String> get categories => [
        'galleryCategoryAll'.tr(),
        'galleryCategoryNature'.tr(),
        'galleryCategoryArchitecture'.tr(),
        'galleryCategoryCulture'.tr(),
        'galleryCategoryFood'.tr(),
      ];

  int selectedCategoryIndex = 0;

  Map<String, List<PhotoModel>> categorizedImages = {};
  bool isLoading = false;

  void changeCategory(int index) {
    selectedCategoryIndex = index;
    notifyListeners();
  }

  List<PhotoModel> get currentImageList =>
      categorizedImages[categories[selectedCategoryIndex]] ?? [];

  List<String> get currentImageUrls =>
      currentImageList.map((e) => e.url).toList();

  Future<void> fetchGalleryPhotos(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    final langCode = context.locale.languageCode;
    categorizedImages = langCode == 'tr'
        ? await _apiService.fetchGalleryPhotosTr()
        : langCode == 'pl'
            ? await _apiService.fetchGalleryPhotosPl()
            : await _apiService.fetchGalleryPhotosEn();

    isLoading = false;
    notifyListeners();
  }

  void navigateToSearch() {
    navigationService.navigateToSearchPage();
  }
}
