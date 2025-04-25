import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/models/RouteItem.dart';
import 'package:rota_erzincan/models/RouteStop.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rota_erzincan/services/database_helper.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/FancyMenuLogoItem.dart';
import 'package:url_launcher/url_launcher.dart';

class RouteDetailPageViewModel extends ChangeNotifier with BaseViewModel {
  RouteItem route;
  List<RouteStop> contentItems = [];
  bool isLoading = true;
  String? _mapErrorMessage;
  String? get mapErrorMessage => _mapErrorMessage;
  bool _disposed = false;
  List<CategoryContentItem> get convertedStops => contentItems.map((stop) {
        return CategoryContentItem(
          id: stop.id,
          title: stop.title,
          description: stop.description,
          imageUrl: stop.imageUrl,
          latitude: stop.latitude,
          longitude: stop.longitude,
          distanceFromUser: stop.distanceFromUser,
        );
      }).toList();

  RouteDetailPageViewModel({required this.route}) {
    loadContent();
  }
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_disposed) notifyListeners();
  }

  Future<void> recalculateDistanceAndDuration() async {
    final db = await DatabaseHelper.instance.database;
    final stops = await db.query(
      'route_stops',
      where: 'routeId = ?',
      whereArgs: [route.id],
      orderBy: 'stopOrder ASC',
    );

    double totalDistance = 0.0;
    for (int i = 0; i < stops.length - 1; i++) {
      totalDistance += Geolocator.distanceBetween(
        stops[i]['latitude'] as double,
        stops[i]['longitude'] as double,
        stops[i + 1]['latitude'] as double,
        stops[i + 1]['longitude'] as double,
      );
    }

    final totalKm = totalDistance / 1000;
    final estimatedDuration = Duration(minutes: (totalKm / 50 * 60).round());

    await db.update(
      'routes',
      {
        'distanceKm': double.parse(totalKm.toStringAsFixed(2)),
        'durationMinutes': estimatedDuration.inMinutes,
      },
      where: 'id = ?',
      whereArgs: [route.id],
    );

    // 👇 route modelini da güncelle ki UI'da yenilensin
    route = route.copyWith(
      distanceKm: double.parse(totalKm.toStringAsFixed(2)),
      duration: estimatedDuration,
    );

    await loadContent(); // contentItems güncellenmeye devam etsin
  }

  Future<void> loadContent() async {
    isLoading = true;
    safeNotifyListeners();

    final currentPosition = await Geolocator.getCurrentPosition();

    if (route.isUserAdded) {
      // 🔹 Kullanıcı tarafından eklenen rota → veritabanından çek
      final db = await DatabaseHelper.instance.database;
      final List<Map<String, dynamic>> stopsData = await db.query(
        'route_stops',
        where: 'routeId = ?',
        whereArgs: [route.id],
      );

      contentItems = stopsData.map((map) {
        final stop = RouteStop(
          id: map['id'] as String,
          title: map['title'] as String,
          description: map['description'] ?? '', // veritabanında yoksa boş
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc', // default image
          latitude: map['latitude'] as double,
          longitude: map['longitude'] as double,
        );

        stop.distanceFromUser = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          stop.latitude,
          stop.longitude,
        );
        return stop;
      }).toList();
      route.stops = contentItems
          .map((e) => CategoryContentItem(
                id: e.id,
                title: e.title,
                description: e.description,
                latitude: e.latitude,
                longitude: e.longitude,
                imageUrl: e.imageUrl,
              ))
          .toList();

      double totalDistance = 0.0;
      for (int i = 0; i < contentItems.length - 1; i++) {
        final start = contentItems[i];
        final end = contentItems[i + 1];
        totalDistance += Geolocator.distanceBetween(
          start.latitude,
          start.longitude,
          end.latitude,
          end.longitude,
        );
      }

      final double totalDistanceKm = totalDistance / 1000;
      final Duration estimatedDuration =
          Duration(minutes: (totalDistanceKm / 50 * 60).round());

      route = route.copyWith(
        distanceKm: double.parse(totalDistanceKm.toStringAsFixed(2)),
        duration: estimatedDuration,
      );
    } else {
      // 🔹 Hazır (sabit) rota → manuel sabit liste
      final String lang =
          EasyLocalization.of(navigationService.navigatorKey.currentContext!)!
              .locale
              .languageCode;

      final List<RouteStop> contentItemsTr = [
        RouteStop(
          id: '1',
          title: 'Saat Kulesi',
          description: 'Tarihi Erzincan saat kulesi.',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc',
          latitude: 39.7524,
          longitude: 39.4921,
        ),
        RouteStop(
          id: '2',
          title: 'Erzincan Müzesi',
          description: 'Yerel tarih ve kültür zenginliği.',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc',
          latitude: 39.7508,
          longitude: 39.4935,
        ),
        RouteStop(
          id: '3',
          title: 'Erzincan Müzesi 2',
          description: 'Yerel tarih ve kültür zenginliği.',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc',
          latitude: 39.7497,
          longitude: 39.4912,
        ),
        RouteStop(
          id: '4',
          title: 'Erzincan Müzesi 3',
          description: 'Yerel tarih ve kültür zenginliği.',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc',
          latitude: 39.7511,
          longitude: 39.4899,
        ),
      ];

      final List<RouteStop> contentItemsEn = [
        RouteStop(
          id: '1',
          title: 'Clock Tower',
          description: 'Historic Erzincan clock tower.',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc',
          latitude: 39.7524,
          longitude: 39.4921,
        ),
        RouteStop(
          id: '2',
          title: 'Erzincan Museum',
          description: 'Rich in local history and culture.',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc',
          latitude: 39.7508,
          longitude: 39.4935,
        ),
        RouteStop(
          id: '3',
          title: 'Erzincan Museum 2',
          description: 'Rich in local history and culture.',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc',
          latitude: 39.7497,
          longitude: 39.4912,
        ),
        RouteStop(
          id: '4',
          title: 'Erzincan Museum 3',
          description: 'Rich in local history and culture.',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc',
          latitude: 39.7511,
          longitude: 39.4899,
        ),
      ];
      List<RouteStop> contentItems =
          lang == 'tr' ? contentItemsTr : contentItemsEn;
      // 🔄 Mesafeleri hesapla
      for (var stop in contentItems) {
        final distance = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          stop.latitude,
          stop.longitude,
        );
        stop.distanceFromUser = distance;
      }
      this.contentItems = contentItems;
    }
    isLoading = false;
    safeNotifyListeners();
  }

  Future<void> navigateToPage(CategoryContentItem item) async {
    navigationService.navigateToDetailsPage(item);
  }

  void navigateToStop(BuildContext context, ThemeProvider themeProvider,
      CategoryContentItem stop) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;

      if (availableMaps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'mapErrorNoAppInstalledSimple'.tr(),
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

        return;
      }

      final googleMapsApp = availableMaps.firstWhere(
        (map) => map.mapType == MapType.google,
        orElse: () => availableMaps.first,
      );

      if (availableMaps.length == 1 ||
          googleMapsApp.mapType == MapType.google) {
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
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'mapErrorGoogleMapsFailed'.tr(),
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
      } else {
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
                  'mapAppSelectionStopTitle'.tr(),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'mapErrorGeneric'.tr(),
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
    safeNotifyListeners();

    try {
      final availableMaps = await MapLauncher.installedMaps;

      if (availableMaps.isEmpty) {
        _mapErrorMessage = 'mapErrorNoAppInstalledSimple'.tr();
        safeNotifyListeners();
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
          _mapErrorMessage = 'mapErrorGoogleMapsFailed'.tr();
          safeNotifyListeners();
        }
      } else {
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
                  'mapAppSelectionRouteTitle'.tr(),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
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

      safeNotifyListeners();
    }
  }

  void navigateToSearch() {
    navigationService.navigateToSearchPage();
  }
}
