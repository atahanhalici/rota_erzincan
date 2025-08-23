import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/AssemblyPointModel.dart';
import 'package:rota_erzincan/services/api_service.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/FancyMenuLogoItem.dart';

class EmergencyAssemblyAreasViewModel extends ChangeNotifier
    with BaseViewModel {
  LatLng? userLocation;
  LatLng? selectedPoint;
  bool isLoading = true; // sadece ilk açılışta true
  bool showFloatingPanel = false;
  AssemblyPointModel? floatingPanelData;
  String? distanceToNearest;

  final ApiService apiService = ApiService();
  List<AssemblyPointModel> assemblyPoints = [];

  late String langCode;

  void initializeWithContext(BuildContext context) {
    langCode = context.locale.languageCode;

    // build sonrası çağır → notifyListeners çakışmaz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAssemblyPoints();
    });
  }

  Future<void> fetchAssemblyPoints() async {
    try {
      if (assemblyPoints.isEmpty) {
        isLoading = true;
        notifyListeners();
      }

      if (langCode == "tr") {
        assemblyPoints = await apiService.fetchAssemblyPointsTr();
      } else if (langCode == "pl") {
        assemblyPoints = await apiService.fetchAssemblyPointsPl();
      } else {
        assemblyPoints = await apiService.fetchAssemblyPointsEn();
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      assemblyPoints = [];
      notifyListeners();
    }
  }

  Future<void> getUserLocation(MapController mapController) async {
    try {
      // Eğer daha önce hiç konum alınmadıysa → loading göster
      if (userLocation == null && isLoading == false) {
        isLoading = true;
        notifyListeners();
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          isLoading = false;
          notifyListeners();
          return;
        }
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isLoading = false;
        notifyListeners();
        return;
      }

      Position? position = await Geolocator.getLastKnownPosition();
      position ??= await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      userLocation = LatLng(position.latitude, position.longitude);
      isLoading = false;
      notifyListeners();

      // haritayı sadece ilk defa açılışta konuma götür
      if (mapController.camera.center.latitude == 0 &&
          mapController.camera.center.longitude == 0) {
        mapController.move(userLocation!, 16);
      }

      final nearest = getNearestPoint();
      if (nearest != null) {
        final distanceInMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          nearest.point.latitude,
          nearest.point.longitude,
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

  AssemblyPointModel? getNearestPoint() {
    if (userLocation == null || assemblyPoints.isEmpty) return null;
    const Distance distance = Distance();

    return assemblyPoints.reduce((a, b) =>
        distance(userLocation!, a.point) < distance(userLocation!, b.point)
            ? a
            : b);
  }

  void updateNearestDistance() {
    final nearest = getNearestPoint();
    if (nearest != null && userLocation != null) {
      final distanceInMeters = Geolocator.distanceBetween(
        userLocation!.latitude,
        userLocation!.longitude,
        nearest.point.latitude,
        nearest.point.longitude,
      );

      distanceToNearest = distanceInMeters < 1000
          ? '${distanceInMeters.toStringAsFixed(0)} ${'unitMeter'.tr()}'
          : '${(distanceInMeters / 1000).toStringAsFixed(1)} ${'unitKilometer'.tr()}';
    }
  }

  void toggleFloatingPanel(AssemblyPointModel? pointData) {
    if (pointData == null) {
      showFloatingPanel = false;
      selectedPoint = null;
    } else {
      floatingPanelData = pointData;
      showFloatingPanel = true;
      selectedPoint = pointData.point;
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

  Future<void> openMapApp(
    BuildContext context,
    ThemeProvider themeProvider,
    double targetLatitude,
    double targetLongitude,
    String targetTitle,
  ) async {
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
        await MapLauncher.showMarker(
          mapType: availableMaps.first.mapType,
          coords: Coords(targetLatitude, targetLongitude),
          title: targetTitle,
        );
      } else {
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
