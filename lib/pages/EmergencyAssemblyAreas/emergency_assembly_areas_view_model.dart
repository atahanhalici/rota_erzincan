// view_model/emergency_assembly_areas_view_model.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';

class EmergencyAssemblyAreasViewModel extends ChangeNotifier
    with BaseViewModel {
  LatLng? userLocation;
  LatLng? selectedPoint;
  bool isLoading = true;
  bool showFloatingPanel = false;
  Map<String, dynamic>? floatingPanelData;
  String? distanceToNearest;

  final List<Map<String, dynamic>> assemblyPoints = [
    {
      'name': 'Fatih Mahallesi Parkı',
      'point': LatLng(39.7500, 39.4900),
      'capacity': 1200,
      'facilities': ['Su İkmal Noktası', 'İlk Yardım Çadırı'],
      'description':
          'Geniş açık alan, çocuk oyun parkı bölümü ve ağaçlık alan bulunmakta.',
      'contact': 'Mahalle Muhtarlığı: 0446 XXX XX XX'
    },
    {
      'name': 'Erzincan Merkez Stadyumu',
      'point': LatLng(39.7475, 39.4905),
      'capacity': 5000,
      'facilities': [
        'Tuvalet',
        'Su İkmal Noktası',
        'Mobil Sağlık Ünitesi',
        'Çadır Alanı'
      ],
      'description': 'Büyük kapasiteli alan, tribünlü ve geniş otopark.',
      'contact': 'Stadyum Yönetimi: 0446 XXX XX XX'
    },
    {
      'name': 'Cumhuriyet Meydanı',
      'point': LatLng(39.7489, 39.4922),
      'capacity': 3000,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'İlk Yardım Merkezi'],
      'description': 'Şehir merkezindeki geniş meydan, ulaşımı kolay.',
      'contact': 'Belediye: 0446 XXX XX XX'
    },
    {
      'name': 'Atatürk Mahallesi Cami Önü',
      'point': LatLng(39.7460, 39.4870),
      'capacity': 800,
      'facilities': ['Su İkmal Noktası'],
      'description': 'Cami önündeki geniş avlu, merkezi konumda.',
      'contact': 'Cami İmamı: 0446 XXX XX XX'
    },
    {
      'name': 'Halitpaşa İlkokulu Bahçesi',
      'point': LatLng(39.7490, 39.4888),
      'capacity': 1500,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'Mobil Çadır'],
      'description':
          'Okul bahçesindeki geniş alan, etrafı çevrili güvenli bölge.',
      'contact': 'Okul Müdürlüğü: 0446 XXX XX XX'
    },
    {
      'name': 'Üniversite Kavşağı Parkı',
      'point': LatLng(39.7520, 39.4945),
      'capacity': 1000,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'İlk Yardım İstasyonu'],
      'description': 'Üniversite kampüsü yakınında, ulaşımı kolay.',
      'contact': 'Üniversite Güvenlik: 0446 XXX XX XX'
    },
    {
      'name': 'Erzincan AVM Arkası',
      'point': LatLng(39.7502, 39.4930),
      'capacity': 2000,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'Yemek Dağıtım Noktası'],
      'description':
          "AVM'nin geniş otopark alanı, kapalı ve açık alanları mevcut.",
      'contact': 'AVM Yönetimi: 0446 XXX XX XX'
    },
    {
      'name': 'Yeni Mahalle Pazar Yeri',
      'point': LatLng(39.7445, 39.4901),
      'capacity': 2500,
      'facilities': ['Su İkmal Noktası', 'Çadır Alanı'],
      'description': 'Haftalık pazar kurulan geniş alan, üstü açık.',
      'contact': 'Mahalle Muhtarlığı: 0446 XXX XX XX'
    },
    {
      'name': 'Belediye Önü Açık Alan',
      'point': LatLng(39.7466, 39.4932),
      'capacity': 1200,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'İdari Merkez'],
      'description':
          'Belediye binası önündeki meydan, koordinasyon merkezi olarak kullanılır.',
      'contact': 'Belediye Afet Koordinasyon: 0446 XXX XX XX'
    },
    {
      'name': 'Valilik Yanı Açık Alan',
      'point': LatLng(39.7472, 39.4940),
      'capacity': 1000,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'AFAD Yönetim Merkezi'],
      'description':
          'Valilik binası yanındaki alan, resmi kurumlarla iletişimi kolay.',
      'contact': 'Valilik AFAD Birimi: 0446 XXX XX XX'
    },
  ];

  Future<void> getUserLocation(MapController mapController) async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        isLoading = false;
        notifyListeners();
        return;
      }

      Position? position = await Geolocator.getLastKnownPosition();

      // Eğer cache yoksa yeni konum al
      position ??= await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium, // daha hızlı, daha az pil
      );

      userLocation = LatLng(position.latitude, position.longitude);
      isLoading = false;
      notifyListeners();
      mapController.move(userLocation!, 16);

      // Mesafe hesapla
      final nearest = getNearestPoint();
      if (nearest != null) {
        final distanceInMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          nearest['point'].latitude,
          nearest['point'].longitude,
        );

        distanceToNearest = distanceInMeters < 1000
            ? '${distanceInMeters.toStringAsFixed(0)} metre'
            : '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic>? getNearestPoint() {
    if (userLocation == null) return null;
    final Distance distance = Distance();
    return assemblyPoints.reduce((a, b) => distance(userLocation!, a['point']) <
            distance(userLocation!, b['point'])
        ? a
        : b);
  }

  void updateNearestDistance() {
    final nearest = getNearestPoint();
    if (nearest != null && userLocation != null) {
      final distanceInMeters = Geolocator.distanceBetween(
        userLocation!.latitude,
        userLocation!.longitude,
        nearest['point'].latitude,
        nearest['point'].longitude,
      );

      distanceToNearest = distanceInMeters < 1000
          ? '${distanceInMeters.toStringAsFixed(0)} metre'
          : '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }

  void toggleFloatingPanel(Map<String, dynamic>? pointData) {
    if (pointData == null) {
      showFloatingPanel = false;
      selectedPoint = null;
    } else {
      floatingPanelData = pointData;
      showFloatingPanel = true;
      selectedPoint = pointData['point']; // ✅ Seçimi burada yap!
    }
    notifyListeners();
  }

  void selectPoint(LatLng point) {
    selectedPoint = point;
    notifyListeners();
  }

  void clearSelectedPoint() {
    selectedPoint = null;
    toggleFloatingPanel(null);
  }
}
