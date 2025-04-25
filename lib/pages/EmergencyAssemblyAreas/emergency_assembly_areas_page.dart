import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/pages/EmergencyAssemblyAreas/emergency_assembly_areas_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/AppBar.dart';
import 'package:rota_erzincan/widgets/EmergencyMap.dart';
import 'package:rota_erzincan/widgets/FloatingInfoPanel.dart';
import 'package:rota_erzincan/widgets/LegendPanel.dart';
import 'package:rota_erzincan/widgets/PointDetailSheet.dart';

class EmergencyAssemblyAreasPage extends StatefulWidget {
  const EmergencyAssemblyAreasPage({super.key});

  @override
  State<EmergencyAssemblyAreasPage> createState() =>
      _EmergencyAssemblyAreasPageState();
}

class _EmergencyAssemblyAreasPageState extends State<EmergencyAssemblyAreasPage>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    Future.microtask(() =>
        Provider.of<EmergencyAssemblyAreasViewModel>(context, listen: false)
            .getUserLocation(_mapController));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel =
          Provider.of<EmergencyAssemblyAreasViewModel>(context, listen: false);
      viewModel.initializeWithContext(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel =
        Provider.of<EmergencyAssemblyAreasViewModel>(context, listen: false);
    viewModel.initializeWithContext(context);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EmergencyAssemblyAreasViewModel>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: themeProvider.cardColor.withValues(alpha: 0.85),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: themeProvider.isDarkMode
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Appbar(
            actionIcon: const Icon(
              Icons.my_location,
              size: 26,
              color: ColorConstants.buttonColor,
            ),
            onActionPressed: () {
              final userLocation = viewModel.userLocation;
              if (userLocation != null) {
                _mapController.move(userLocation, 16);
                viewModel.toggleFloatingPanel(null);
              }
            },
          ),
        ),
      ),
      body: viewModel.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    'locationLoadingText'.tr(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.textColor),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                EmergencyMap(
                  mapController: _mapController,
                  animationController: _animationController,
                  themeProvider: themeProvider,
                ),
                FloatingInfoPanel(
                  onDetailTap: (point) => _showAssemblyPointDetails(
                      context, point, themeProvider, viewModel),
                  mapController: _mapController,
                ),
                const LegendPanel(),
                if (viewModel.userLocation == null)
                  _buildPermissionWarning(themeProvider, viewModel),
              ],
            ),
    );
  }

  void _showAssemblyPointDetails(
      BuildContext context,
      Map<String, dynamic> point,
      ThemeProvider themeProvider,
      EmergencyAssemblyAreasViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PointDetailSheet(
        point: point,
        onNavigatePressed: () {
          viewModel.openMapApp(
            context,
            themeProvider,
            point['point'].latitude,
            point['point'].longitude,
            point['name'],
          );
        },
      ),
    );
  }

  Widget _buildPermissionWarning(
      ThemeProvider themeProvider, EmergencyAssemblyAreasViewModel viewModel) {
    return Positioned.fill(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: themeProvider.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_disabled,
                  color: Colors.red,
                  size: 50,
                ),
                const SizedBox(height: 16),
                Text(
                  'locationPermissionTitle'.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'locationPermissionDescription'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: themeProvider.textColor.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    viewModel.getUserLocation(_mapController);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.buttonColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.location_on),
                  label: Text('locationPermissionButton'.tr()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
