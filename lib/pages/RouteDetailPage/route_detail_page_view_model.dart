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

    if (route.isUserAdded) {
      final db = await DatabaseHelper.instance.database;
      final List<Map<String, dynamic>> stopsData = await db.query(
        'route_stops',
        where: 'routeId = ?',
        whereArgs: [route.id],
      );

      contentItems = stopsData.map((map) {
        return RouteStop(
          id: map['id'] as String,
          title: map['title'] as String,
          description: map['description'] ?? '',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/spodek.jpg?alt=media&token=d4498059-0877-442a-a672-909a130fb2ba',
          latitude: map['latitude'] as double,
          longitude: map['longitude'] as double,
        );
      }).toList();

      // Mesafe ve süreler hesaplanmadan önce gösterim yapılabilsin
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
    } else {
      // 🔹 Hazır (sabit) rota → manuel sabit liste
      final String lang =
          EasyLocalization.of(navigationService.navigatorKey.currentContext!)!
              .locale
              .languageCode;

      final List<RouteStop> contentItemsTr = [
        RouteStop(
          id: '1',
          title: 'Spodek Arena',
          description:
              'Katowice’nin simgesi, konser ve etkinlikler için ünlü arena.',
          imageUrl: 'https://picsum.photos/id/1011/600/400',
          latitude: 50.2599,
          longitude: 19.0216,
        ),
        RouteStop(
          id: '2',
          title: 'Nikiszowiec',
          description:
              'Tarihi işçi yerleşimi, geleneksel mimarisi ve kültürel etkinlikleriyle ünlü.',
          imageUrl: 'https://picsum.photos/id/1025/600/400',
          latitude: 50.2475,
          longitude: 19.0263,
        ),
        RouteStop(
          id: '3',
          title: 'Silesia City Center',
          description:
              'Alışveriş, eğlence ve restoranların bulunduğu büyük bir alışveriş merkezi.',
          imageUrl: 'https://picsum.photos/id/1043/600/400',
          latitude: 50.2570,
          longitude: 19.0250,
        ),
        RouteStop(
          id: '4',
          title: 'Katowice Botanik Bahçesi',
          description:
              'Doğa yürüyüşleri ve bitki çeşitleri ile dolu sakin bir alan.',
          imageUrl: 'https://picsum.photos/id/1062/600/400',
          latitude: 50.2605,
          longitude: 19.0150,
        ),
      ];

      final List<RouteStop> contentItemsEn = [
        RouteStop(
          id: '1',
          title: 'Spodek Arena',
          description:
              'The iconic arena of Katowice, famous for concerts and events.',
          imageUrl: 'https://picsum.photos/id/1011/600/400',
          latitude: 50.2599,
          longitude: 19.0216,
        ),
        RouteStop(
          id: '2',
          title: 'Nikiszowiec',
          description:
              'Historic worker settlement known for traditional architecture and cultural events.',
          imageUrl: 'https://picsum.photos/id/1025/600/400',
          latitude: 50.2475,
          longitude: 19.0263,
        ),
        RouteStop(
          id: '3',
          title: 'Silesia City Center',
          description:
              'A large shopping center with shops, entertainment, and restaurants.',
          imageUrl: 'https://picsum.photos/id/1043/600/400',
          latitude: 50.2570,
          longitude: 19.0250,
        ),
        RouteStop(
          id: '4',
          title: 'Katowice Botanical Garden',
          description:
              'A peaceful area filled with walking paths and plant varieties.',
          imageUrl: 'https://picsum.photos/id/1062/600/400',
          latitude: 50.2605,
          longitude: 19.0150,
        ),
      ];

      final List<RouteStop> contentItemsPl = [
        RouteStop(
          id: '1',
          title: 'Spodek Arena',
          description:
              'Ikoniczna arena w Katowicach, znana z koncertów i wydarzeń.',
          imageUrl: 'https://picsum.photos/id/1011/600/400',
          latitude: 50.2599,
          longitude: 19.0216,
        ),
        RouteStop(
          id: '2',
          title: 'Nikiszowiec',
          description:
              'Historyczne osiedle robotnicze, słynące z tradycyjnej architektury i wydarzeń kulturalnych.',
          imageUrl: 'https://picsum.photos/id/1025/600/400',
          latitude: 50.2475,
          longitude: 19.0263,
        ),
        RouteStop(
          id: '3',
          title: 'Silesia City Center',
          description:
              'Duże centrum handlowe z sklepami, rozrywką i restauracjami.',
          imageUrl: 'https://picsum.photos/id/1043/600/400',
          latitude: 50.2570,
          longitude: 19.0250,
        ),
        RouteStop(
          id: '4',
          title: 'Ogród Botaniczny Katowice',
          description:
              'Spokojny obszar z alejkami spacerowymi i różnorodnością roślin.',
          imageUrl: 'https://picsum.photos/id/1062/600/400',
          latitude: 50.2605,
          longitude: 19.0150,
        ),
      ];

      contentItems = lang == 'tr'
          ? contentItemsTr
          : lang == 'pl'
              ? contentItemsPl
              : contentItemsEn;
    }
    isLoading = false;
    safeNotifyListeners();

    // 🔁 Mesafe ve süre hesaplamasını arka planda başlat
    Future.microtask(() => calculateUserDistancesAsync());
  }

  Future<void> calculateUserDistancesAsync() async {
    if (contentItems.isEmpty) return;

    final currentPosition = await Geolocator.getCurrentPosition();

    for (var stop in contentItems) {
      stop.distanceFromUser = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        stop.latitude,
        stop.longitude,
      );
    }

    // UI'da gösterilecek listeyi güncelle
    route.stops = contentItems
        .map((e) => CategoryContentItem(
              id: e.id,
              title: e.title,
              description: e.description,
              latitude: e.latitude,
              longitude: e.longitude,
              imageUrl: e.imageUrl,
              distanceFromUser: e.distanceFromUser,
            ))
        .toList();

    // Sadece kullanıcı tanımlı rotalarda süre + mesafe gösterilsin
    if (route.isUserAdded) {
      double totalDistance = 0.0;
      for (int i = 0; i < contentItems.length - 1; i++) {
        totalDistance += Geolocator.distanceBetween(
          contentItems[i].latitude,
          contentItems[i].longitude,
          contentItems[i + 1].latitude,
          contentItems[i + 1].longitude,
        );
      }

      final totalKm = totalDistance / 1000;
      final estimatedDuration = Duration(minutes: (totalKm / 50 * 60).round());

      route = route.copyWith(
        distanceKm: double.parse(totalKm.toStringAsFixed(2)),
        duration: estimatedDuration,
      );
    }

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
