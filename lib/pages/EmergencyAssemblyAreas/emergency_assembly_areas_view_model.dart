// view_model/emergency_assembly_areas_view_model.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
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

  final List<Map<String, dynamic>> assemblyPointsTr = [
    {
      'name': 'Spodek Arena',
      'point': const LatLng(50.2599, 19.0216),
      'capacity': 11000,
      'facilities': ['Su İkmal Noktası', 'İlk Yardım Çadırı'],
      'description':
          'Katowice’nin simgesi olan arena, büyük etkinlikler için ideal.',
      'contact': 'Spodek Yönetimi: +48 XXX XXX XXX'
    },
    {
      'name': 'Rynek Meydanı',
      'point': const LatLng(50.2591, 19.0205),
      'capacity': 5000,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'Çadır Alanı'],
      'description': 'Şehrin merkezi meydanı, kolay ulaşım ve geniş alan.',
      'contact': 'Belediye Katowice: +48 XXX XXX XXX'
    },
    {
      'name': 'Nikiszowiec Parkı',
      'point': const LatLng(50.2435, 19.0195),
      'capacity': 2000,
      'facilities': ['Su İkmal Noktası', 'İlk Yardım Çadırı'],
      'description': 'Tarihi Nikiszowiec bölgesinde geniş yeşil alan.',
      'contact': 'Park Yönetimi: +48 XXX XXX XXX'
    },
    {
      'name': 'Silesian Park',
      'point': const LatLng(50.2420, 19.0010),
      'capacity': 8000,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'Yemek Dağıtım Noktası'],
      'description': 'Şehrin en büyük park alanı, etkinlik ve yürüyüş alanı.',
      'contact': 'Silesian Park Yönetimi: +48 XXX XXX XXX'
    },
    {
      'name': 'Muzeum Śląskie Önü',
      'point': const LatLng(50.2640, 19.0015),
      'capacity': 3000,
      'facilities': ['Su İkmal Noktası', 'İlk Yardım Merkezi'],
      'description': 'Modern sanat müzesi önündeki açık alan.',
      'contact': 'Müze İletişim: +48 XXX XXX XXX'
    },
    {
      'name': 'Katowice Üniversite Kampüsü',
      'point': const LatLng(50.2670, 19.0220),
      'capacity': 4000,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'İlk Yardım İstasyonu'],
      'description': 'Üniversite kampüsü içinde geniş ve ulaşımı kolay alan.',
      'contact': 'Üniversite Güvenlik: +48 XXX XXX XXX'
    },
    {
      'name': 'Strefa Kultury Alanı',
      'point': const LatLng(50.2630, 19.0200),
      'capacity': 6000,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'Çadır Alanı'],
      'description': 'Kültürel etkinlik alanı, konum itibariyle merkezi.',
      'contact': 'Strefa Kultury Yönetimi: +48 XXX XXX XXX'
    },
    {
      'name': 'Plac Miarki',
      'point': const LatLng(50.2600, 19.0180),
      'capacity': 2500,
      'facilities': ['Su İkmal Noktası', 'Çadır Alanı'],
      'description': 'Haftalık pazar alanı, açık ve kolay erişilebilir.',
      'contact': 'Belediye Katowice: +48 XXX XXX XXX'
    },
    {
      'name': 'Rybnicka Açık Alan',
      'point': const LatLng(50.2560, 19.0150),
      'capacity': 2000,
      'facilities': ['Tuvalet', 'Su İkmal Noktası'],
      'description': 'Koordinasyon merkezi ve açık etkinlik alanı.',
      'contact': 'Belediye Katowice: +48 XXX XXX XXX'
    },
    {
      'name': 'Valilik Yanı Alanı',
      'point': const LatLng(50.2585, 19.0190),
      'capacity': 1500,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'AFAD Yönetim Merkezi'],
      'description':
          'Valilik binası yakınındaki alan, resmi kurumlarla iletişim kolay.',
      'contact': 'Valilik Katowice: +48 XXX XXX XXX'
    },
  ];

  final List<Map<String, dynamic>> assemblyPointsEn = [
    {
      'name': 'Spodek Arena',
      'point': const LatLng(50.2599, 19.0216),
      'capacity': 11000,
      'facilities': ['Water Supply Station', 'First Aid Tent'],
      'description': 'Iconic arena in Katowice, ideal for large events.',
      'contact': 'Spodek Management: +48 XXX XXX XXX'
    },
    {
      'name': 'Rynek Square',
      'point': const LatLng(50.2591, 19.0205),
      'capacity': 5000,
      'facilities': ['Toilets', 'Water Supply Station', 'Tent Area'],
      'description': 'City center square with wide open area and easy access.',
      'contact': 'Katowice Municipality: +48 XXX XXX XXX'
    },
    {
      'name': 'Nikiszowiec Park',
      'point': const LatLng(50.2435, 19.0195),
      'capacity': 2000,
      'facilities': ['Water Supply Station', 'First Aid Tent'],
      'description': 'Spacious green area in historic Nikiszowiec district.',
      'contact': 'Park Management: +48 XXX XXX XXX'
    },
    {
      'name': 'Silesian Park',
      'point': const LatLng(50.2420, 19.0010),
      'capacity': 8000,
      'facilities': [
        'Toilets',
        'Water Supply Station',
        'Food Distribution Point'
      ],
      'description': 'Largest park in the city, great for events and walks.',
      'contact': 'Silesian Park Management: +48 XXX XXX XXX'
    },
    {
      'name': 'Museum of Silesia Front',
      'point': const LatLng(50.2640, 19.0015),
      'capacity': 3000,
      'facilities': ['Water Supply Station', 'First Aid Center'],
      'description': 'Open area in front of the modern art museum.',
      'contact': 'Museum Contact: +48 XXX XXX XXX'
    },
    {
      'name': 'Katowice University Campus',
      'point': const LatLng(50.2670, 19.0220),
      'capacity': 4000,
      'facilities': ['Toilets', 'Water Supply Station', 'First Aid Station'],
      'description':
          'Spacious area inside university campus, easily accessible.',
      'contact': 'University Security: +48 XXX XXX XXX'
    },
    {
      'name': 'Strefa Kultury Area',
      'point': const LatLng(50.2630, 19.0200),
      'capacity': 6000,
      'facilities': ['Toilets', 'Water Supply Station', 'Tent Area'],
      'description': 'Cultural event area, centrally located.',
      'contact': 'Strefa Kultury Management: +48 XXX XXX XXX'
    },
    {
      'name': 'Plac Miarki',
      'point': const LatLng(50.2600, 19.0180),
      'capacity': 2500,
      'facilities': ['Water Supply Station', 'Tent Area'],
      'description': 'Open-air area where weekly market is held.',
      'contact': 'Katowice Municipality: +48 XXX XXX XXX'
    },
    {
      'name': 'Rybnicka Open Area',
      'point': const LatLng(50.2560, 19.0150),
      'capacity': 2000,
      'facilities': ['Toilets', 'Water Supply Station'],
      'description': 'Coordination center and open event area.',
      'contact': 'Katowice Municipality: +48 XXX XXX XXX'
    },
    {
      'name': 'Next to Governorship Area',
      'point': const LatLng(50.2585, 19.0190),
      'capacity': 1500,
      'facilities': [
        'Toilets',
        'Water Supply Station',
        'AFAD Management Center'
      ],
      'description':
          'Area near governorship, easy coordination with authorities.',
      'contact': 'Katowice Governorship: +48 XXX XXX XXX'
    },
  ];
  final List<Map<String, dynamic>> assemblyPointsPl = [
    {
      'name': 'Spodek Arena',
      'point': const LatLng(50.2599, 19.0216),
      'capacity': 11000,
      'facilities': ['Stacja Zaopatrzenia w Wodę', 'Namiot Pierwszej Pomocy'],
      'description':
          'Ikoniczna arena w Katowicach, idealna na duże wydarzenia.',
      'contact': 'Zarząd Spodek: +48 XXX XXX XXX'
    },
    {
      'name': 'Rynek',
      'point': const LatLng(50.2591, 19.0205),
      'capacity': 5000,
      'facilities': [
        'Toalety',
        'Stacja Zaopatrzenia w Wodę',
        'Strefa Namiotowa'
      ],
      'description':
          'Centralny plac miasta z szeroką przestrzenią i łatwym dostępem.',
      'contact': 'Urząd Miasta Katowice: +48 XXX XXX XXX'
    },
    {
      'name': 'Park Nikiszowiec',
      'point': const LatLng(50.2435, 19.0195),
      'capacity': 2000,
      'facilities': ['Stacja Zaopatrzenia w Wodę', 'Namiot Pierwszej Pomocy'],
      'description':
          'Przestronny teren zielony w historycznej dzielnicy Nikiszowiec.',
      'contact': 'Zarząd Parku: +48 XXX XXX XXX'
    },
    {
      'name': 'Park Śląski',
      'point': const LatLng(50.2420, 19.0010),
      'capacity': 8000,
      'facilities': [
        'Toalety',
        'Stacja Zaopatrzenia w Wodę',
        'Punkt Dystrybucji Żywności'
      ],
      'description':
          'Największy park w mieście, idealny na wydarzenia i spacery.',
      'contact': 'Zarząd Parku Śląskiego: +48 XXX XXX XXX'
    },
    {
      'name': 'Przód Muzeum Śląskiego',
      'point': const LatLng(50.2640, 19.0015),
      'capacity': 3000,
      'facilities': ['Stacja Zaopatrzenia w Wodę', 'Centrum Pierwszej Pomocy'],
      'description': 'Otwarta przestrzeń przed muzeum sztuki nowoczesnej.',
      'contact': 'Kontakt z Muzeum: +48 XXX XXX XXX'
    },
    {
      'name': 'Kampus Uniwersytetu w Katowicach',
      'point': const LatLng(50.2670, 19.0220),
      'capacity': 4000,
      'facilities': [
        'Toalety',
        'Stacja Zaopatrzenia w Wodę',
        'Stanowisko Pierwszej Pomocy'
      ],
      'description':
          'Przestronny teren na kampusie uniwersyteckim, łatwo dostępny.',
      'contact': 'Ochrona Uniwersytetu: +48 XXX XXX XXX'
    },
    {
      'name': 'Strefa Kultury',
      'point': const LatLng(50.2630, 19.0200),
      'capacity': 6000,
      'facilities': [
        'Toalety',
        'Stacja Zaopatrzenia w Wodę',
        'Strefa Namiotowa'
      ],
      'description': 'Centralnie położona strefa wydarzeń kulturalnych.',
      'contact': 'Zarząd Strefy Kultury: +48 XXX XXX XXX'
    },
    {
      'name': 'Plac Miarki',
      'point': const LatLng(50.2600, 19.0180),
      'capacity': 2500,
      'facilities': ['Stacja Zaopatrzenia w Wodę', 'Strefa Namiotowa'],
      'description': 'Otwarta przestrzeń targowa, łatwo dostępna.',
      'contact': 'Urząd Miasta Katowice: +48 XXX XXX XXX'
    },
    {
      'name': 'Otwarte Tereny Rybnicka',
      'point': const LatLng(50.2560, 19.0150),
      'capacity': 2000,
      'facilities': ['Toalety', 'Stacja Zaopatrzenia w Wodę'],
      'description': 'Centrum koordynacyjne i przestrzeń otwarta dla wydarzeń.',
      'contact': 'Urząd Miasta Katowice: +48 XXX XXX XXX'
    },
    {
      'name': 'Teren Obok Województwa',
      'point': const LatLng(50.2585, 19.0190),
      'capacity': 1500,
      'facilities': [
        'Toalety',
        'Stacja Zaopatrzenia w Wodę',
        'Centrum Zarządzania AFAD'
      ],
      'description':
          'Teren przy urzędzie wojewódzkim, łatwa koordynacja z władzami.',
      'contact': 'Urząd Wojewódzki Katowice: +48 XXX XXX XXX'
    },
  ];

  late String langCode;
  void initializeWithContext(BuildContext context) {
    langCode = context.locale.languageCode;
    // Dil kontrolü, tema, medya query vs. gibi şeyleri burada alabilirsin
  }

  Future<void> getUserLocation(MapController mapController) async {
    try {
      // Önce izin durumu kontrol et
      LocationPermission permission = await Geolocator.checkPermission();

      // Eğer izin verilmemişse → iste
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();

        // Yine verilmediyse → çık
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          isLoading = false;
          notifyListeners();
          return;
        }
      }

      // Konum servisi açık mı?
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isLoading = false;
        notifyListeners();
        return;
      }

      // Konum al
      Position? position = await Geolocator.getLastKnownPosition();
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
            ? '${distanceInMeters.toStringAsFixed(0)} ${'unitMeter'.tr()}'
            : '${(distanceInMeters / 1000).toStringAsFixed(1)} ${'unitKilometer'.tr()}';
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic>? getNearestPoint() {
    if (userLocation == null) return null;
    const Distance distance = Distance();
    if (langCode == "tr") {
      return assemblyPointsTr.reduce((a, b) =>
          distance(userLocation!, a['point']) <
                  distance(userLocation!, b['point'])
              ? a
              : b);
    } else {
      return assemblyPointsEn.reduce((a, b) =>
          distance(userLocation!, a['point']) <
                  distance(userLocation!, b['point'])
              ? a
              : b);
    }
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
          ? '${distanceInMeters.toStringAsFixed(0)} ${'unitMeter'.tr()}'
          : '${(distanceInMeters / 1000).toStringAsFixed(1)} ${'unitKilometer'.tr()}';
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
        _mapErrorMessage = 'mapErrorNoAppInstalled'.tr();
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
                  'mapAppSelectionTitle'.tr(),
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
