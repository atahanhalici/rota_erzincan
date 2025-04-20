import 'package:flutter/material.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/RouteItem.dart';
import 'package:rota_erzincan/services/api_service.dart';
import 'package:rota_erzincan/services/database_helper.dart';

class RoutesPageViewModel extends ChangeNotifier with BaseViewModel {
  final ApiService _apiService = ApiService();
  List<RouteItem> routeItems = [];
  bool isLoading = true;

  // 🔹 Kullanıcı tarafından eklenen rotalar
  List<RouteItem> _userRoutes = [];
  List<RouteItem> get userRoutes => _userRoutes;

  bool _showUserRoutes = false;

  bool get showUserRoutes => _showUserRoutes;
  Future<void> loadSavedRoutes() async {
    final db = await DatabaseHelper.instance.database;
    final routeData = await db.query('routes');

    _userRoutes = routeData.map((routeMap) {
      return RouteItem(
        id: routeMap['id'] as String,
        title: routeMap['title'] as String,
        subtitle: routeMap['subtitle'] as String,
        imageUrl: routeMap['imageUrl'] as String,
        icon: IconData(routeMap['icon'] as int, fontFamily: 'MaterialIcons'),
        distanceKm: routeMap['distanceKm'] as double,
        duration: Duration(minutes: routeMap['durationMinutes'] as int),
        isUserAdded: (routeMap['isUserAdded'] as int) == 1,
        stops: [], // stops verisi burada yüklenmedi, istersen ayrıca çekebiliriz
      );
    }).toList();

    notifyListeners();
  }

  void toggleUserRoutes() {
    _showUserRoutes = !_showUserRoutes;
    notifyListeners();
  }

  Future<void> removeRouteAt(int index) async {
    final routeToRemove = _userRoutes[index];

    // 1. Local listeden kaldır
    _userRoutes.removeAt(index);
    notifyListeners();

    // 2. Veritabanından sil (önce stops, sonra route)
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'route_stops',
      where: 'routeId = ?',
      whereArgs: [routeToRemove.id],
    );
    await db.delete(
      'routes',
      where: 'id = ?',
      whereArgs: [routeToRemove.id],
    );
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
