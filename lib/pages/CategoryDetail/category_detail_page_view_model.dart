import 'package:easy_localization/easy_localization.dart';
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

  Future<void> initialize(BuildContext context) async {
    await _loadContents(context);
  }

  Future<void> _loadContents(BuildContext context) async {
    final locale = context.locale.languageCode;
    if (category.id == 8) {
      _contentItems = locale == 'tr'
          ? await _apiService.getEventsTr()
          : await _apiService.getEventsEn();
    } else {
      _contentItems = locale == 'tr'
          ? await _apiService.getContentsTr(category)
          : await _apiService.getContentsEn(category);
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
    String eventType =
        item.title.contains('Film') || item.title.contains("Showing")
            ? 'movie'
            : 'theater';

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
