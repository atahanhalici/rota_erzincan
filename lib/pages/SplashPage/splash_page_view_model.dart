import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/services/version_service.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/utilities/version_manager.dart';

class SplashPageViewModel with ChangeNotifier, BaseViewModel {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  void init(TickerProvider vsync, BuildContext context) async {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: false);

    scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    while (!await ensureLocationPermission(context)) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    // Konum izni alındıysa uygulamayı başlat
    handleStartUpLogic();
  }

  void disposeAnimation() {
    controller.dispose();
  }

  final VersionService _versionService = VersionService();
  bool _isRequiredUpdate = false;
  bool _serverError = false;
  bool splashFinished = false;

  bool get isRequiredUpdate => _isRequiredUpdate;

  void handleStartUpLogic() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Get the client version.
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String clientVersion = packageInfo.version;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      } else {
        navigationService.navigateToPageClear(("/noNetwork"), null);
        splashFinished = true;
        return;
      }
    } catch (e) {
      navigationService.navigateToPageClear(("/noNetwork"), null);
      splashFinished = true;
      return;
    }

    // Get the current user.

    await checkVersion(clientVersion);
    if (_serverError) {
      return;
    }
    if (_isRequiredUpdate) {
      // Show a dialog to the user to update the app.
      navigationService.navigateToPageClear(("/needUpdate"), null);
      return;
    }
    navigationService.navigateToPageClear(("/home"), null);
    splashFinished = true;
    notifyListeners();
  }

  Future<void> checkVersion(String clientVersion) async {
    final databaseValue = await _versionService.getVersionNumber();

    if (databaseValue == "error") {
      _serverError = true;
      navigationService.navigateToPageClear(("/serverError"), null);
      _isRequiredUpdate = false;
      return;
    }
    if (databaseValue == null || databaseValue.isEmpty) {
      // If the version number is not found in the database, set isRequiredUpdate to false.
      // Maybe we can show a message to the user that an error occurred while fetching the version number.
      _isRequiredUpdate = false;
      return;
    }

    final checkIsNeedUpdate =
        VersionManager(appValue: clientVersion, databaseValue: databaseValue);

    if (checkIsNeedUpdate.isNeedUpdate()) {
      _isRequiredUpdate = true;
      return;
    }

    _isRequiredUpdate = false;
    notifyListeners();
  }

  Future<bool> ensureLocationPermission(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showBlockingDialog(
        context,
        'locationServiceOffTitle'.tr(),
        'locationServiceOffMessage'.tr(),
      );
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await _showBlockingDialog(
          context,
          'locationPermissionDeniedTitle'.tr(),
          'locationPermissionDeniedMessage'.tr(),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await _showBlockingDialog(
        context,
        'locationPermissionPermanentlyDeniedTitle'.tr(),
        'locationPermissionPermanentlyDeniedMessage'.tr(),
        showSettings: true,
      );
      return false;
    }

    return true;
  }

  Future<void> _showBlockingDialog(
    BuildContext context,
    String title,
    String message, {
    bool showSettings = false,
  }) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            color: themeProvider.cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with title
              // Header with title
              Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                decoration: BoxDecoration(
                  color: themeProvider.buttonColor.withValues(alpha: 0.1),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: themeProvider.buttonColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      // 👈 Bu satır eklendi
                      child: Text(
                        title,
                        style: TextStyle(
                          color: themeProvider.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        maxLines: 2, // İsteğe bağlı: En fazla 2 satır olsun
                        overflow: TextOverflow.ellipsis, // Uzunsa üç nokta koy
                      ),
                    ),
                  ],
                ),
              ),

              // Message content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  message,
                  style: TextStyle(
                    color: themeProvider.textColor,
                    fontSize: 16,
                  ),
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  mainAxisAlignment: showSettings
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: [
                    if (showSettings)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Geolocator.openAppSettings(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeProvider.buttonColor
                                .withValues(alpha: 0.9),
                            foregroundColor: Colors.white,
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.settings, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'openSettingsButton'.tr(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (showSettings) const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeProvider.buttonColor,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outline, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'okButtonText'.tr(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
