import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/models/RouteItem.dart';
import 'package:rota_erzincan/services/database_helper.dart';
import 'package:uuid/uuid.dart';

class NewRouteModalViewModel extends ChangeNotifier with BaseViewModel {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final uuid = const Uuid();

  late List<CategoryContentItem> allItems;
  final Set<String> selectedIds = {};

  NewRouteModalViewModel({
    CategoryContentItem? initialItem,
    RouteItem? editingRoute,
  }) {
    final lang =
        EasyLocalization.of(navigationService.navigatorKey.currentContext!)!
            .locale
            .languageCode;

    final List<CategoryContentItem> itemTr = [
      CategoryContentItem(
        id: 'item_0',
        title: 'Spodek Arena',
        description:
            'Katowice’nin simgesi, konser ve etkinlikler için ünlü arena.',
        imageUrl: 'https://picsum.photos/id/1011/600/400',
        latitude: 50.2599,
        longitude: 19.0216,
      ),
      CategoryContentItem(
        id: 'item_1',
        title: 'Nikiszowiec',
        description:
            'Tarihi işçi yerleşimi, geleneksel mimarisi ve kültürel etkinlikleriyle ünlü.',
        imageUrl: 'https://picsum.photos/id/1025/600/400',
        latitude: 50.2475,
        longitude: 19.0263,
      ),
      CategoryContentItem(
        id: 'item_2',
        title: 'Silesia City Center',
        description:
            'Alışveriş, eğlence ve restoranların bulunduğu büyük bir alışveriş merkezi.',
        imageUrl: 'https://picsum.photos/id/1043/600/400',
        latitude: 50.2570,
        longitude: 19.0250,
      ),
      CategoryContentItem(
        id: 'item_3',
        title: 'Katowice Botanik Bahçesi',
        description:
            'Doğa yürüyüşleri ve bitki çeşitleri ile dolu sakin bir alan.',
        imageUrl: 'https://picsum.photos/id/1062/600/400',
        latitude: 50.2605,
        longitude: 19.0150,
      ),
      CategoryContentItem(
        id: 'item_4',
        title: 'Rynek w Katowicach',
        description:
            'Şehrin merkezi meydanı, kafeler ve tarihi yapılarla çevrili.',
        imageUrl: 'https://picsum.photos/id/1050/600/400',
        latitude: 50.2590,
        longitude: 19.0210,
      ),
    ];

    final List<CategoryContentItem> itemEn = [
      CategoryContentItem(
        id: 'item_0',
        title: 'Spodek Arena',
        description:
            'The iconic arena of Katowice, famous for concerts and events.',
        imageUrl: 'https://picsum.photos/id/1011/600/400',
        latitude: 50.2599,
        longitude: 19.0216,
      ),
      CategoryContentItem(
        id: 'item_1',
        title: 'Nikiszowiec',
        description:
            'Historic worker settlement known for traditional architecture and cultural events.',
        imageUrl: 'https://picsum.photos/id/1025/600/400',
        latitude: 50.2475,
        longitude: 19.0263,
      ),
      CategoryContentItem(
        id: 'item_2',
        title: 'Silesia City Center',
        description:
            'A large shopping center with shops, entertainment, and restaurants.',
        imageUrl: 'https://picsum.photos/id/1043/600/400',
        latitude: 50.2570,
        longitude: 19.0250,
      ),
      CategoryContentItem(
        id: 'item_3',
        title: 'Katowice Botanical Garden',
        description:
            'A peaceful area filled with walking paths and plant varieties.',
        imageUrl: 'https://picsum.photos/id/1062/600/400',
        latitude: 50.2605,
        longitude: 19.0150,
      ),
      CategoryContentItem(
        id: 'item_4',
        title: 'Rynek w Katowicach',
        description:
            'The central square of the city, surrounded by cafes and historic buildings.',
        imageUrl: 'https://picsum.photos/id/1050/600/400',
        latitude: 50.2590,
        longitude: 19.0210,
      ),
    ];

    // ✅ Dil kontrolü ile doğru listeyi al
    final selectedLangItems = lang == 'tr' ? itemTr : itemEn;

    // ✅ 1. Benzersiz ID map’i oluştur
    final Map<String, CategoryContentItem> uniqueMap = {};

    for (final item in [
      ...selectedLangItems,
      if (initialItem != null) initialItem,
      if (editingRoute != null) ...editingRoute.stops,
    ]) {
      uniqueMap[item.id] = item;
    }

    // ✅ 2. Listeyi oluştur
    allItems = uniqueMap.values.toList();

    // ✅ 3. Seçili olanları işaretle
    if (initialItem != null) {
      selectedIds.add(initialItem.id);
    }

    if (editingRoute != null) {
      nameController.text = editingRoute.title;
      descController.text = editingRoute.subtitle;
      selectedIds.addAll(editingRoute.stops.map((e) => e.id));
    }

    // ✅ 4. Seçilenleri en üste çek
    allItems.sort((a, b) {
      final aSelected = selectedIds.contains(a.id) ? 0 : 1;
      final bSelected = selectedIds.contains(b.id) ? 0 : 1;
      return aSelected.compareTo(bSelected);
    });
  }

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
        start.latitude,
        start.longitude,
        end.latitude,
        end.longitude,
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
    // ✅ Stop'ları kaydet
    for (final stop in stops) {
      await db.insert('route_stops', {
        'id': stop.id,
        'routeId': route.id,
        'latitude': stop.latitude,
        'longitude': stop.longitude,
        'title': stop.title,
        'description': stop.description,
        'stopOrder': order++, // ✅ sıralı index
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
        stops[i].latitude,
        stops[i].longitude,
        stops[i + 1].latitude,
        stops[i + 1].longitude,
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

    // ✅ Eski durakları sil
    await db.delete('route_stops', where: 'routeId = ?', whereArgs: [routeId]);

    int order = 0;
    for (final stop in stops) {
      await db.insert('route_stops', {
        'id': stop.id,
        'routeId': routeId,
        'latitude': stop.latitude,
        'longitude': stop.longitude,
        'title': stop.title,
        'description': stop.description,
        'stopOrder': order++,
      });
    }
  }
}
