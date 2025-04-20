import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/RouteItem.dart';
import 'package:rota_erzincan/models/RouteStop.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/FancyMenuLogoItem.dart';
import 'package:url_launcher/url_launcher.dart';

class RouteDetailPageViewModel extends ChangeNotifier with BaseViewModel {
  final RouteItem route;
  List<RouteStop> contentItems = [];
  bool isLoading = true;
  String? _mapErrorMessage;
  String? get mapErrorMessage => _mapErrorMessage;

  RouteDetailPageViewModel({required this.route}) {
    _loadContent();
  }

  Future<void> _loadContent() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final currentPosition = await Geolocator.getCurrentPosition();

    contentItems = [
      RouteStop(
        id: '1',
        title: 'Saat Kulesi',
        description: 'Tarihi Erzincan saat kulesi.',
        imageUrl: 'https://picsum.photos/id/200/600/400',
        latitude: 39.7524,
        longitude: 39.4921,
      ),
      RouteStop(
        id: '2',
        title: 'Erzincan Müzesi',
        description: 'Yerel tarih ve kültür zenginliği.',
        imageUrl: 'https://picsum.photos/id/201/600/400',
        latitude: 39.7508,
        longitude: 39.4935,
      ),
      RouteStop(
        id: '3',
        title: 'Erzincan Müzesi 2',
        description: 'Yerel tarih ve kültür zenginliği.',
        imageUrl: 'https://picsum.photos/id/201/600/400',
        latitude: 39.7497,
        longitude: 39.4912,
      ),
      RouteStop(
        id: '4',
        title: 'Erzincan Müzesi 3',
        description: 'Yerel tarih ve kültür zenginliği.',
        imageUrl: 'https://picsum.photos/id/201/600/400',
        latitude: 39.7511,
        longitude: 39.4899,
      ),
    ];

    for (var stop in contentItems) {
      final distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        stop.latitude,
        stop.longitude,
      );
      stop.distanceFromUser = distance;
    }

    isLoading = false;
    notifyListeners();
  }

  void navigateToStop(
      BuildContext context, ThemeProvider themeProvider, RouteStop stop) async {
    debugPrint('📍 Durak detayına gidiliyor: ${stop.title}');

    try {
      final availableMaps = await MapLauncher.installedMaps;

      if (availableMaps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Yüklü bir harita uygulaması bulunamadı.')),
        );
        return;
      }

      final googleMapsApp = availableMaps.firstWhere(
        (map) => map.mapType == MapType.google,
        orElse: () => availableMaps.first,
      );

      if (availableMaps.length == 1 ||
          googleMapsApp.mapType == MapType.google) {
        // Direkt Google Maps ile aç
        final stopUrl = Uri.parse(
          'https://www.google.com/maps/dir/?api=1'
          '&destination=${stop.latitude},${stop.longitude}'
          '&destination_place_id=${stop.title}'
          '&travelmode=driving',
        );

        if (await canLaunchUrl(stopUrl)) {
          await launchUrl(stopUrl, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Google Maps açılamadı.')),
          );
        }
      } else {
        // Kullanıcıya seçim sun
        showModalBottomSheet(
          context: context,
          backgroundColor: themeProvider.cardColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Bu durağı açmak istediğiniz harita uygulamasını seçin",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
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
                const SizedBox(height: 12),
                ...availableMaps.map((map) {
                  return FancyMenuLogoItem(
                    icon: map.icon,
                    label: map.mapName,
                    color: themeProvider.buttonColor,
                    onTap: () async {
                      Navigator.pop(context);
                      await MapLauncher.showMarker(
                        mapType: map.mapType,
                        coords: Coords(stop.latitude, stop.longitude),
                        title: stop.title,
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
      debugPrint('📍 Harita hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harita uygulaması açılırken bir hata oluştu.')),
      );
    }
  }

  Future<double?> getDistanceToStop(RouteStop stop) async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        stop.latitude,
        stop.longitude,
      );
      return distanceInMeters;
    } catch (e) {
      debugPrint("📌 Konum alınamadı: $e");
      return null;
    }
  }

  Future<void> openMapApp(
      BuildContext context, ThemeProvider themeProvider) async {
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

      final lastStop = contentItems.last;

      final List<Waypoint> waypoints = contentItems
          .sublist(0, contentItems.length - 1)
          .map((e) => Waypoint(e.latitude, e.longitude, e.title))
          .toList();

      final googleMapsApp = availableMaps.firstWhere(
        (map) => map.mapType == MapType.google,
        orElse: () => availableMaps.first,
      );

      if (availableMaps.length == 1 ||
          googleMapsApp.mapType == MapType.google) {
        // Eğer sadece Google Maps varsa ya da Google Maps varsa onu kullan
        final origin =
            '${contentItems.first.latitude},${contentItems.first.longitude}';
        final destination = '${lastStop.latitude},${lastStop.longitude}';
        final viaPoints = contentItems
            .sublist(1, contentItems.length - 1)
            .map((e) => '${e.latitude},${e.longitude}')
            .join('|');

        final googleUrl = Uri.parse(
          'https://www.google.com/maps/dir/?api=1'
          '&origin=$origin'
          '&destination=$destination'
          '&waypoints=$viaPoints'
          '&travelmode=driving',
        );

        if (await canLaunchUrl(googleUrl)) {
          await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
        } else {
          _mapErrorMessage = 'Google Maps açılamadı.';
          notifyListeners();
        }
      } else {
        // Diğer haritalar için seçim menüsü
        showModalBottomSheet(
          context: context,
          backgroundColor: themeProvider.cardColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
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
                const SizedBox(height: 12),
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
                const SizedBox(height: 12),
                ...availableMaps.map((map) {
                  return FancyMenuLogoItem(
                    icon: map.icon,
                    label: map.mapName,
                    color: themeProvider.buttonColor,
                    onTap: () async {
                      Navigator.pop(context);
                      await MapLauncher.showDirections(
                        mapType: map.mapType,
                        destination:
                            Coords(lastStop.latitude, lastStop.longitude),
                        destinationTitle: lastStop.title,
                        waypoints: waypoints,
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
      debugPrint('Harita uygulaması açılamadı: $e');
      _mapErrorMessage = 'Harita uygulaması açılırken bir hata oluştu.';
      notifyListeners();
    }
  }
}
