import 'package:flutter/material.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/CategoryItem.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/services/api_service.dart';

class CategoryDetailViewModel extends ChangeNotifier with BaseViewModel {
  final ApiService _apiService = ApiService();
  final CategoryItem category;

  List<CategoryContentItem> _contentItems = [];
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  List<CategoryContentItem> get contentItems => _contentItems;

  CategoryDetailViewModel({
    required this.category,
  });

  Future<void> initialize() async {
    await _loadContents();
  }

  Future<void> _loadContents() async {
    if (category.title == "Bu Ayın Etkinlikleri") {
      _contentItems = await _apiService.getEvents();
    } else {
      _contentItems = await _apiService.getContents(category);
    }

    _isLoading = false;

    // 👇 Bu notify çalışmasına rağmen UI değişmiyorsa viewModel'i StatefulWidget içinde State'e taşımadın demektir
    notifyListeners();
  }

  void navigateToSearch() {
    navigationService.navigateToSearchPage();
  }

  Future<void> navigateToPage(CategoryContentItem item) async {
    navigationService.navigateToDetailsPage(item);
  }

  Future<void> navigateToEvent(
      CategoryContentItem item, BuildContext context) async {
    // eventType belirleniyor
    String eventType = item.title.contains('Film') ? 'movie' : 'theater';

    await Navigator.of(context).pushNamed(
      "/eventDetail",
      arguments: {
        'eventType': eventType,
        'imageUrl': item.imageUrl,
        'title': item.title,
        'subtitle': item.description,
        "id": item.id,
      },
    );
  }
}
