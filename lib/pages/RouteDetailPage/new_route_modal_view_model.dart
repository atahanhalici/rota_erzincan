import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/models/RouteItem.dart';
import 'package:rota_erzincan/services/database_helper.dart';
import 'package:uuid/uuid.dart';

class NewRouteModalViewModel extends ChangeNotifier {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final uuid = Uuid();

  final List<CategoryContentItem> allItems = [
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
          'Dünyanın en dar geçitlerinden biri, muazzam manzaralı yürüyüş yollarıyla ünlü.',
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
  final Set<String> selectedIds = {};

  NewRouteModalViewModel();

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

    // ✅ Stop'ları kaydet
    for (final stop in stops) {
      await db.insert('route_stops', {
        'id': uuid.v4(),
        'routeId': route.id,
        'latitude': stop.latitude,
        'longitude': stop.longitude,
        'title': stop.title,
      });
    }

    print('Route ve duraklar kaydedildi: ${route.title}');
  }

  void disposeControllers() {
    nameController.dispose();
    descController.dispose();
  }
}
