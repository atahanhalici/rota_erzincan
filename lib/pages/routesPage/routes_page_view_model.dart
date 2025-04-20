import 'package:flutter/material.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/RouteItem.dart';

class RoutesPageViewModel extends ChangeNotifier with BaseViewModel {
  //final ApiService _apiService = ApiService();
  List<RouteItem> routeItems = [];
  bool isLoading = true;

  List<Map<String, dynamic>> _userRoutes = [
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

    //categoryItems = await _apiService.fetchAllCategories();
    routeItems = [
      RouteItem(
        title: "Tarihin İçinden Rotası",
        subtitle: "Erzincan'ın tarihi ve kültürel zenginliklerini keşfedin.",
        imageUrl:
            "https://picsum.photos/id/1011/600/400", // Tarihi yerler havası
        icon: Icons.account_balance, // Tarihi bina simgesi
      ),
      RouteItem(
        title: "Çocuğumla Geziyorum Rotası",
        subtitle: "Ailece eğlenebileceğiniz parklar ve etkinlikler.",
        imageUrl: "https://picsum.photos/id/1027/600/400", // Çocuk teması
        icon: Icons.child_friendly, // Çocuk dostu simgesi
      ),
      RouteItem(
        title: "Doğadan Esintiler Rotası",
        subtitle: "Doğayla iç içe huzurlu rotaları keşfedin.",
        imageUrl: "https://picsum.photos/id/1043/600/400", // Doğa manzarası
        icon: Icons.nature_people, // Doğa yürüyüşü ikonu
      ),
      RouteItem(
        title: "Sporcunun Dostu Rotası",
        subtitle: "Aktif yaşamı sevenler için ideal parkurlar.",
        imageUrl: "https://picsum.photos/id/1052/600/400", // Spor yapma alanı
        icon: Icons.fitness_center, // Spor ikonu
      ),
      RouteItem(
        title: "Erzincan ve Macera Rotası",
        subtitle: "Adrenalin ve keşif dolu bir Erzincan deneyimi.",
        imageUrl: "https://picsum.photos/id/1062/600/400", // Macera teması
        icon: Icons.explore, // Keşif simgesi
      ),
    ];

    isLoading = false;
    notifyListeners(); // shimmer dursun, liste gözüksün
  }

  /* Future<void> initialize() async {
    await _loadRoutes();
  }

  Future<void> _loadRoutes() async {
    _contentItems = await _apiService.getContents(routes);

    _isLoading = false;

    // 👇 Bu notify çalışmasına rağmen UI değişmiyorsa viewModel'i StatefulWidget içinde State'e taşımadın demektir
    notifyListeners();
  }

  Future<void> navigateToPage(CategoryContentItem item) async {
    navigationService.navigateToDetailsPage(item);
  }*/

  @override
  void dispose() {
    super.dispose();
  }
}
