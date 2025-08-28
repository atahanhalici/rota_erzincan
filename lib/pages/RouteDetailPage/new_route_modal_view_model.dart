import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/models/RouteItem.dart';
import 'package:rota_erzincan/services/api_service.dart';
import 'package:rota_erzincan/services/database_helper.dart';
import 'package:uuid/uuid.dart';

class NewRouteModalViewModel extends ChangeNotifier with BaseViewModel {
  final ApiService apiService = ApiService();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final uuid = const Uuid();

  List<CategoryContentItem> allItems = [];
  final Set<String> selectedIds = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  NewRouteModalViewModel({
    CategoryContentItem? initialItem,
    RouteItem? editingRoute,
  }) {
    _init(initialItem: initialItem, editingRoute: editingRoute);
  }

  Future<void> _init({
    CategoryContentItem? initialItem,
    RouteItem? editingRoute,
  }) async {
    await fetchPlaces();

    // ✅ Initial item varsa ekle
    if (initialItem != null) {
      if (!allItems.any((e) => e.id == initialItem.id)) {
        allItems.insert(0, initialItem);
      }
      selectedIds.add(initialItem.id);
    }

    // ✅ Editing route varsa doldur
    if (editingRoute != null) {
      nameController.text = editingRoute.title;
      descController.text = editingRoute.subtitle;

      for (final stop in editingRoute.stops) {
        if (!allItems.any((e) => e.id == stop.id)) {
          allItems.add(stop);
        }
        selectedIds.add(stop.id);
      }
    }

    // ✅ Seçilenleri üste çek
    allItems.sort((a, b) {
      final aSelected = selectedIds.contains(a.id) ? 0 : 1;
      final bSelected = selectedIds.contains(b.id) ? 0 : 1;
      return aSelected.compareTo(bSelected);
    });

    notifyListeners();
  }

  Future<void> fetchPlaces() async {
    if (allItems.isNotEmpty) {
      // ✅ Zaten dolu → tekrar API çağırma
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final lang = EasyLocalization.of(
        navigationService.navigatorKey.currentContext!,
      )!
          .locale
          .languageCode;

      List<CategoryContentItem> results = [];

      if (lang == 'tr') {
        results = await apiService.searchContentsTr("");
      } else if (lang == 'en') {
        results = await apiService.searchContentsEn("");
      } else if (lang == 'pl') {
        results = await apiService.searchContentsPl("");
      }

      allItems = results;
    } catch (e) {
      debugPrint("❌ fetchPlaces error: $e");
      allItems = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Seçim işlemleri
  void toggleSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    notifyListeners();
  }

  List<CategoryContentItem> get selectedStops =>
      allItems.where((e) => selectedIds.contains(e.id)).toList();

  bool get isFormValid =>
      nameController.text.trim().isNotEmpty &&
      descController.text.trim().isNotEmpty &&
      selectedIds.isNotEmpty;

  Future<void> createRoute() async {
    final stops = selectedStops;

    double totalDistance = 0.0;

    for (int i = 0; i < stops.length - 1; i++) {
      final start = stops[i];
      final end = stops[i + 1];

      final distance = Geolocator.distanceBetween(
        start.latitude!,
        start.longitude!,
        end.latitude!,
        end.longitude!,
      );

      totalDistance += distance; // metre cinsinden
    }

    final double totalDistanceKm = totalDistance / 1000;
    final Duration estimatedDuration =
        Duration(minutes: (totalDistanceKm / 50 * 60).round());

    final routeId = uuid.v4();

    final route = RouteItem(
      id: routeId,
      title: nameController.text.trim(),
      subtitle: descController.text.trim(),
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/c3e4721f-bb4c-4a09-8067-837ef3e98c2e.jpg?alt=media&token=15a6edd4-d9cf-48ab-ad25-addaf92c3f9b',
      iconName: "map_rounded",
      distanceKm: double.parse(totalDistanceKm.toStringAsFixed(2)),
      duration: estimatedDuration,
      isUserAdded: true,
      stops: stops,
    );

    final db = await DatabaseHelper.instance.database;

    // ✅ Route'ı kaydet
    await db.insert('routes', {
      'id': route.id,
      'title': route.title,
      'subtitle': route.subtitle,
      'imageUrl': route.imageUrl,
      'icon': route.iconName, // int olarak sakla
      'distanceKm': route.distanceKm,
      'durationMinutes': route.duration.inMinutes,
      'isUserAdded': route.isUserAdded ? 1 : 0,
    });
    int order = 0;
// ✅ Stop ID'lerini kaydet
    for (final stop in stops) {
      await db.insert('route_stops', {
        'stopId': stop.id, // sadece _id
        'routeId': route.id,
        'stopOrder': order++, // sıralı index
      });
    }
  }

  void disposeControllers() {
    nameController.dispose();
    descController.dispose();
  }

  Future<void> updateRoute(String routeId) async {
    final stops = selectedStops;

    double totalDistance = 0.0;
    for (int i = 0; i < stops.length - 1; i++) {
      totalDistance += Geolocator.distanceBetween(
        stops[i].latitude!,
        stops[i].longitude!,
        stops[i + 1].latitude!,
        stops[i + 1].longitude!,
      );
    }

    final db = await DatabaseHelper.instance.database;

    // ✅ Güncelle
    await db.update(
      'routes',
      {
        'title': nameController.text.trim(),
        'subtitle': descController.text.trim(),
        'distanceKm': double.parse((totalDistance / 1000).toStringAsFixed(2)),
        'durationMinutes': ((totalDistance / 1000) / 50 * 60).round(),
      },
      where: 'id = ?',
      whereArgs: [routeId],
    );

    await db.delete('route_stops', where: 'routeId = ?', whereArgs: [routeId]);

    // ✅ Sadece stop _id ve sıralamayı kaydet
    int order = 0;
    for (final stop in stops) {
      await db.insert('route_stops', {
        'stopId': stop.id, // sadece _id
        'routeId': routeId,
        'stopOrder': order++, // sıralı index
      });
    }
  }
}
