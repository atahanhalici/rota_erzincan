import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/pages/EmergencyAssemblyAreas/emergency_assembly_areas_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'dart:math' as math;

import 'package:rota_erzincan/widgets/EmergencyPhoneBottomSheet.dart';

class FloatingInfoPanel extends StatelessWidget {
  final void Function(Map<String, dynamic> point) onDetailTap;
  final MapController mapController;
  const FloatingInfoPanel(
      {super.key, required this.onDetailTap, required this.mapController});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EmergencyAssemblyAreasViewModel>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final showPanel = viewModel.showFloatingPanel;
    final point = viewModel.floatingPanelData;
    final nearestPoint = viewModel.getNearestPoint();

    return Stack(
      children: [
        if (showPanel && point != null)
          Positioned(
            top: 20 + kToolbarHeight,
            left: 20,
            right: 20,
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: themeProvider.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            point['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                size: 16,
                                color: themeProvider.textColor
                                    .withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${point['capacity']} ${'floatingPanelPersonSuffix'.tr()}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeProvider.textColor
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.local_hospital,
                                size: 16,
                                color: themeProvider.textColor
                                    .withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${point['facilities'].length} ${'floatingPanelFacilitySuffix'.tr()}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeProvider.textColor
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        viewModel.toggleFloatingPanel(null);
                        onDetailTap(point);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        backgroundColor:
                            ColorConstants.buttonColor.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:  Text(
                        'floatingPanelDetailsButton'.tr(),
                        style:const TextStyle(
                          color: ColorConstants.buttonColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Bottom-right action buttons block (EMERGENCY, REFRESH, NEAREST)
        Positioned(
          bottom: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  // Emergency call button
                  FloatingActionButton(
                    heroTag: "emergencyCall",
                    mini: true,
                    backgroundColor: Colors.red,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const EmergencyPhoneBottomSheet(),
                      );
                    },
                    child: const Icon(Icons.phone, color: Colors.white),
                  ),

                  const SizedBox(width: 10),

                  // Refresh location button
                  FloatingActionButton(
                    heroTag: "refreshBtn",
                    mini: true,
                    backgroundColor: themeProvider.cardColor,
                    onPressed: () {
                      viewModel.getUserLocation(mapController);
                    },
                    child: Icon(
                      Icons.refresh,
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Nearest button (large styled)
              ElevatedButton.icon(
                onPressed: () {
                  if (nearestPoint != null) {
                    // 1. Seçili alanı güncelle
                    viewModel.selectPoint(nearestPoint['point']);

                    // 2. Floating paneli en yakın alanla birlikte göster
                    viewModel.toggleFloatingPanel(nearestPoint);
                    mapController.move(nearestPoint['point'], 16);
                    viewModel.openMapApp(
                      context,
                      themeProvider,
                      nearestPoint['point'].latitude,
                      nearestPoint['point'].longitude,
                      nearestPoint['name'],
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.buttonColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                ),
                icon: Transform.rotate(
                  angle: -45 * math.pi / 180,
                  child: const Icon(Icons.navigation, color: Colors.white),
                ),
                label:  Text(
                  'floatingPanelNearestButton'.tr(),
                  style:const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
