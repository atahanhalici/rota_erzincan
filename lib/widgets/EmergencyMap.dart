import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:rota_erzincan/pages/EmergencyAssemblyAreas/emergency_assembly_areas_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:latlong2/latlong.dart';

class EmergencyMap extends StatelessWidget {
  final MapController mapController;
  final AnimationController animationController;
  final ThemeProvider themeProvider;

  const EmergencyMap({
    super.key,
    required this.mapController,
    required this.animationController,
    required this.themeProvider,
  });

  bool _isSamePoint(LatLng a, LatLng b) {
    return a.latitude == b.latitude && a.longitude == b.longitude;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EmergencyAssemblyAreasViewModel>(context);
    final userLocation = viewModel.userLocation;
    final selectedPoint = viewModel.selectedPoint;
    final nearest = viewModel.getNearestPoint();
    final lang = context.locale.languageCode;
    final assemblyPoints = lang == 'tr'
        ? viewModel.assemblyPointsTr
        : lang == 'pl'
            ? viewModel.assemblyPointsPl
            : viewModel.assemblyPointsEn;
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: userLocation!,
        initialZoom: 15,
        onTap: (_, __) => viewModel.clearSelectedPoint(),
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'com.poznajkato.app',
        ),
        if (userLocation != null)
          CircleLayer(
            circles: [
              CircleMarker(
                point: userLocation,
                radius: 500,
                color: Colors.blue.withValues(alpha: 0.1),
                borderColor: Colors.blue.withValues(alpha: 0.7),
                borderStrokeWidth: 2,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            if (userLocation != null)
              Marker(
                point: userLocation,
                width: 36,
                height: 36,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.person_pin_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),

            // Diğer tüm markerlar (seçili olan hariç)
            ...assemblyPoints.where((area) {
              final point = area['point'] as LatLng;
              return selectedPoint == null ||
                  !_isSamePoint(point, selectedPoint);
            }).map((area) {
              final point = area['point'] as LatLng;
              final isNearest =
                  nearest != null && _isSamePoint(point, nearest['point']);
              return Marker(
                width: 60,
                height: 60,
                point: point,
                child: GestureDetector(
                  onTap: () => viewModel.toggleFloatingPanel(area),
                  child: _buildMarker(
                    area: area,
                    isSelected: false,
                    isNearest: isNearest,
                  ),
                ),
              );
            }),
          ],
        ),
        // Seçili marker en üste ekleniyor
        if (selectedPoint != null)
          MarkerLayer(
            markers: assemblyPoints
                .where((area) => _isSamePoint(area['point'], selectedPoint))
                .map((area) {
              final point = area['point'] as LatLng;
              final isNearest =
                  nearest != null && _isSamePoint(point, nearest['point']);
              return Marker(
                width: 500,
                height: 80,
                point: point,
                child: GestureDetector(
                  onTap: () => viewModel.toggleFloatingPanel(area),
                  child: _buildMarker(
                    area: area,
                    isSelected: true,
                    isNearest: isNearest,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildMarker({
    required Map<String, dynamic> area,
    required bool isSelected,
    required bool isNearest,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.identity()..translate(0.0, isSelected ? -10.0 : 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue
                  : (isNearest ? Colors.green : ColorConstants.buttonColor),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isSelected
                          ? Colors.blue
                          : (isNearest
                              ? Colors.green
                              : ColorConstants.buttonColor))
                      .withValues(alpha: 0.5),
                  blurRadius: isSelected ? 12 : 8,
                  spreadRadius: isSelected ? 4 : 2,
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.location_on,
              color: Colors.white,
              size: isSelected ? 28 : 24,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              constraints: const BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                area['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
                softWrap: false,
              ),
            ),
        ],
      ),
    );
  }
}
