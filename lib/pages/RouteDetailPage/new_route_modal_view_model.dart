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
        title: 'Ergan Dağı Kayak Merkezi',
        description:
            'Kış turizmiyle öne çıkan, doğayla iç içe bir kayak merkezi.',
        imageUrl: 'https://picsum.photos/id/1011/600/400',
        latitude: 39.6152,
        longitude: 39.5558,
      ),
      CategoryContentItem(
        id: 'item_1',
        title: 'Girlevik Şelalesi',
        description:
            'Doğal güzelliğiyle ünlü, piknik ve fotoğrafçılık için harika bir şelale.',
        imageUrl: 'https://picsum.photos/id/1025/600/400',
        latitude: 39.6255,
        longitude: 39.7813,
      ),
      CategoryContentItem(
        id: 'item_2',
        title: 'Kemaliye Karanlık Kanyon',
        description:
            'Dünyanın en dar geçitlerinden biri, manzaralı yürüyüş yollarıyla ünlü.',
        imageUrl: 'https://picsum.photos/id/1043/600/400',
        latitude: 39.2601,
        longitude: 38.4968,
      ),
      CategoryContentItem(
        id: 'item_3',
        title: 'Ekşisu Mesire Alanı',
        description: 'Doğal maden suyu kaynakları ve piknik alanları ile ünlü.',
        imageUrl: 'https://picsum.photos/id/1062/600/400',
        latitude: 39.6613,
        longitude: 39.6907,
      ),
      CategoryContentItem(
        id: 'item_4',
        title: 'Erzincan Kalesi',
        description:
            'Tarihi dokusunu koruyan ve şehre hâkim bir noktada bulunan kale.',
        imageUrl: 'https://picsum.photos/id/1050/600/400',
        latitude: 39.7508,
        longitude: 39.4977,
      ),
    ];

    final List<CategoryContentItem> itemEn = [
      CategoryContentItem(
        id: 'item_0',
        title: 'Ergan Mountain Ski Center',
        description:
            'A ski resort integrated with nature, famous for winter tourism.',
        imageUrl: 'https://picsum.photos/id/1011/600/400',
        latitude: 39.6152,
        longitude: 39.5558,
      ),
      CategoryContentItem(
        id: 'item_1',
        title: 'Girlevik Waterfall',
        description: 'A beautiful waterfall ideal for picnics and photography.',
        imageUrl: 'https://picsum.photos/id/1025/600/400',
        latitude: 39.6255,
        longitude: 39.7813,
      ),
      CategoryContentItem(
        id: 'item_2',
        title: 'Kemaliye Dark Canyon',
        description:
            'One of the narrowest canyons in the world, famous for its scenic trails.',
        imageUrl: 'https://picsum.photos/id/1043/600/400',
        latitude: 39.2601,
        longitude: 38.4968,
      ),
      CategoryContentItem(
        id: 'item_3',
        title: 'Ekşisu Recreation Area',
        description: 'Famous for its natural mineral springs and picnic areas.',
        imageUrl: 'https://picsum.photos/id/1062/600/400',
        latitude: 39.6613,
        longitude: 39.6907,
      ),
      CategoryContentItem(
        id: 'item_4',
        title: 'Erzincan Castle',
        description: 'A historical castle overlooking the city.',
        imageUrl: 'https://picsum.photos/id/1050/600/400',
        latitude: 39.7508,
        longitude: 39.4977,
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
          'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/erzincana-kar-yeniden-geliyor.jpg?alt=media&token=0b910000-dd18-4edc-8724-66268562adb4',
      icon: Icons.map_rounded,
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
      'icon': route.icon.codePoint, // int olarak sakla
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
