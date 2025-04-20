import 'package:flutter/material.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/RouteItem.dart';
import 'package:rota_erzincan/services/api_service.dart';

class RoutesPageViewModel extends ChangeNotifier with BaseViewModel {
  final ApiService _apiService = ApiService();
  List<RouteItem> routeItems = [];
  bool isLoading = true;

  final List<Map<String, dynamic>> _userRoutes = [
    {
      'id': '1',
      'name': 'Kemaliye - Karanlık Kanyon',
      'distance': '8.5 km',
      'duration': '2 saat 30 dk',
      'date': '12.04.2025',
    },
    {
      'id': '2',
      'name': 'Girlevik Şelalesi Parkuru',
      'distance': '5.2 km',
      'duration': '1 saat 45 dk',
      'date': '05.03.2025',
    },
  ];

  bool _showUserRoutes = false;

  List<Map<String, dynamic>> get userRoutes => _userRoutes;
  bool get showUserRoutes => _showUserRoutes;

  void toggleUserRoutes() {
    _showUserRoutes = !_showUserRoutes;
    notifyListeners();
  }

  void removeRouteAt(int index) {
    _userRoutes.removeAt(index);
    notifyListeners();
  }

  RoutesPageViewModel() {
    fetchAllCategories();
  }

  Future<void> fetchAllCategories() async {
    isLoading = true;
    notifyListeners(); // shimmer başlasın

    routeItems = await _apiService.fetchAllRoutes();

    isLoading = false;
    notifyListeners(); // shimmer dursun, liste gözüksün
  }

  void navigateToRouteDetails(RouteItem item) {
    navigationService.navigateToRouteDetailsPage(item);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
