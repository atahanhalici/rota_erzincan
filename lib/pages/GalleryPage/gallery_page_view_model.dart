import 'package:flutter/material.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/PhotoModel.dart';
import 'package:rota_erzincan/services/api_service.dart';

class GalleryPageViewModel extends ChangeNotifier with BaseViewModel {
  final ApiService _apiService = ApiService();
  GalleryPageViewModel() {
    fetchGalleryPhotos();
  }

  final List<String> categories = ["Tümü", "Doğa", "Mimari", "Kültür", "Yemek"];
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

  Future<void> fetchGalleryPhotos() async {
    isLoading = true;
    notifyListeners();
    categorizedImages = await _apiService.fetchGalleryPhotos();
    isLoading = false;
    notifyListeners();
  }
}
