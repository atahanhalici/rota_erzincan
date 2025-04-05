import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/services/version_service.dart';
import 'package:rota_erzincan/utilities/version_manager.dart';

class SplashPageViewModel with ChangeNotifier, BaseViewModel {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  void init(TickerProvider vsync) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: false);

    scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );
  }

  void disposeAnimation() {
    controller.dispose();
  }

  final VersionService _versionService = VersionService();
  bool _isRequiredUpdate = false;
  bool _serverError = false;
  bool splashFinished = false;

  bool get isRequiredUpdate => _isRequiredUpdate;

  SplashPageViewModel() {
    handleStartUpLogic();
  }

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
}
