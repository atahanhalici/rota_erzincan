import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:rota_erzincan/pages/EmergencyAssemblyAreas/emergency_assembly_areas_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EmergencyAssemblyAreasViewModel>(context);
    final userLocation = viewModel.userLocation;
    final selectedPoint = viewModel.selectedPoint;
    final nearest = viewModel.getNearestPoint();


    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: userLocation,
        zoom: 15,
        onTap: (_, __) => viewModel.clearSelectedPoint(),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        if (userLocation != null)
          CircleLayer(
            circles: [
              CircleMarker(
                point: userLocation,
                radius: 500,
                color: Colors.blue.withOpacity(0.1),
                borderColor: Colors.blue.withOpacity(0.7),
                borderStrokeWidth: 2,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            if (userLocation != null)
              Marker(
                point: userLocation,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.person_pin_circle,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ...viewModel.assemblyPoints.map((area) {
              final isNearest =
                  nearest != null && area['point'] == nearest['point'];
              final isSelected =
                  selectedPoint != null && area['point'] == selectedPoint;
              return Marker(
                width: isSelected ? 500 : 60,
                height: isSelected ? 80 : 60,
                point: area['point'],
                child: GestureDetector(
                  onTap: () => viewModel.toggleFloatingPanel(area),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()
                      ..translate(0.0, isSelected ? -10.0 : 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue
                                : (isNearest
                                    ? Colors.green
                                    : ColorConstants.buttonColor),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (isSelected
                                        ? Colors.blue
                                        : (isNearest
                                            ? Colors.green
                                            : ColorConstants.buttonColor))
                                    .withOpacity(0.5),
                                blurRadius: isSelected ? 12 : 8,
                                spreadRadius: isSelected ? 4 : 2,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.emergency,
                            color: Colors.white,
                            size: isSelected ? 28 : 24,
                          ),
                        ),
                        if (isSelected)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            constraints: const BoxConstraints(maxWidth: 500),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
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
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ],
    );
  }
}
