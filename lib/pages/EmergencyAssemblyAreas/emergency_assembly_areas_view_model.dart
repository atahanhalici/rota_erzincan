// view_model/emergency_assembly_areas_view_model.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/FancyMenuLogoItem.dart';

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
      'point': const LatLng(39.7500, 39.4900),
      'capacity': 1200,
      'facilities': ['Su İkmal Noktası', 'İlk Yardım Çadırı'],
      'description':
          'Geniş açık alan, çocuk oyun parkı bölümü ve ağaçlık alan bulunmakta.',
      'contact': 'Mahalle Muhtarlığı: 0446 XXX XX XX'
    },
    {
      'name': 'Erzincan Merkez Stadyumu',
      'point': const LatLng(39.7475, 39.4905),
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
      'point': const LatLng(39.7489, 39.4922),
      'capacity': 3000,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'İlk Yardım Merkezi'],
      'description': 'Şehir merkezindeki geniş meydan, ulaşımı kolay.',
      'contact': 'Belediye: 0446 XXX XX XX'
    },
    {
      'name': 'Atatürk Mahallesi Cami Önü',
      'point': const LatLng(39.7460, 39.4870),
      'capacity': 800,
      'facilities': ['Su İkmal Noktası'],
      'description': 'Cami önündeki geniş avlu, merkezi konumda.',
      'contact': 'Cami İmamı: 0446 XXX XX XX'
    },
    {
      'name': 'Halitpaşa İlkokulu Bahçesi',
      'point': const LatLng(39.7490, 39.4888),
      'capacity': 1500,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'Mobil Çadır'],
      'description':
          'Okul bahçesindeki geniş alan, etrafı çevrili güvenli bölge.',
      'contact': 'Okul Müdürlüğü: 0446 XXX XX XX'
    },
    {
      'name': 'Üniversite Kavşağı Parkı',
      'point': const LatLng(39.7520, 39.4945),
      'capacity': 1000,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'İlk Yardım İstasyonu'],
      'description': 'Üniversite kampüsü yakınında, ulaşımı kolay.',
      'contact': 'Üniversite Güvenlik: 0446 XXX XX XX'
    },
    {
      'name': 'Erzincan AVM Arkası',
      'point': const LatLng(39.7502, 39.4930),
      'capacity': 2000,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'Yemek Dağıtım Noktası'],
      'description':
          "AVM'nin geniş otopark alanı, kapalı ve açık alanları mevcut.",
      'contact': 'AVM Yönetimi: 0446 XXX XX XX'
    },
    {
      'name': 'Yeni Mahalle Pazar Yeri',
      'point': const LatLng(39.7445, 39.4901),
      'capacity': 2500,
      'facilities': ['Su İkmal Noktası', 'Çadır Alanı'],
      'description': 'Haftalık pazar kurulan geniş alan, üstü açık.',
      'contact': 'Mahalle Muhtarlığı: 0446 XXX XX XX'
    },
    {
      'name': 'Belediye Önü Açık Alan',
      'point': const LatLng(39.7466, 39.4932),
      'capacity': 1200,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'İdari Merkez'],
      'description':
          'Belediye binası önündeki meydan, koordinasyon merkezi olarak kullanılır.',
      'contact': 'Belediye Afet Koordinasyon: 0446 XXX XX XX'
    },
    {
      'name': 'Valilik Yanı Açık Alan',
      'point': const LatLng(39.7472, 39.4940),
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
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
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
    const Distance distance = Distance();
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

  String? _mapErrorMessage;
  String? get mapErrorMessage => _mapErrorMessage;

  void clearMapError() {
    _mapErrorMessage = null;
    notifyListeners();
  }

  Future<void> openMapApp(BuildContext context, ThemeProvider themeProvider,
      double targetLatitude, double targetLongitude, String targetTitle) async {
    _mapErrorMessage = null;
    notifyListeners();

    try {
      final availableMaps = await MapLauncher.installedMaps;

      if (availableMaps.isEmpty) {
        _mapErrorMessage =
            'Cihazınızda yüklü bir harita uygulaması bulunamadı.';
        notifyListeners();
        return;
      }

      if (availableMaps.length == 1) {
        // Tek harita varsa direkt aç
        await MapLauncher.showMarker(
          mapType: availableMaps.first.mapType,
          coords: Coords(targetLatitude, targetLongitude),
          title: targetTitle,
        );
      } else {
        // Birden fazla varsa seçim menüsü göster
        showModalBottomSheet(
          context: context,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Konuma Gitmek İstediğiniz Harita Uygulamasını Seçin",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        themeProvider.cardColor,
                        themeProvider.infoItemColor,
                        themeProvider.cardColor,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ...availableMaps.map((map) {
                  return FancyMenuLogoItem(
                    icon: map.icon,
                    label: map.mapName,
                    color: themeProvider.buttonColor,
                    onTap: () {
                      Navigator.pop(context);
                      MapLauncher.showMarker(
                        mapType: map.mapType,
                        coords: Coords(targetLatitude, targetLongitude),
                        title: targetTitle,
                      );
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mapErrorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    mapErrorMessage!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(12),
            duration: const Duration(seconds: 3),
          ),
        );
      }

      notifyListeners();
    }
  }

  // Her bir galeri öğesi için animasyon oluşturucu yardımcı metodu
  Animation<double> createGalleryItemAnimation(
      int index, AnimationController controller) {
    final delay = 0.5 + (index * 0.1);
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          delay < 1.0 ? delay : 0.9,
          (delay + 0.2) < 1.0 ? (delay + 0.2) : 1.0,
          curve: Curves.easeOutQuart,
        ),
      ),
    );
  }
}
