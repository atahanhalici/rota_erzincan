import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rota_erzincan/init/navigation/navigation_service.dart';
import 'package:rota_erzincan/pages/SplashPage/splash_page_view_model.dart';
import 'package:rota_erzincan/services/connectivity_service.dart';

@immutable
class ApplicationStart {
  const ApplicationStart._();

  static Future<void> init(SplashPageViewModel splashViewModel) async {
    WidgetsFlutterBinding.ensureInitialized();
    // Sadece dikey modda kullanılabilir
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );

    bool hasConnection =
        await ConnectivityService.instance.checkInitialConnection();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!hasConnection) {
        if (splashViewModel.splashFinished) {
          NavigationService.instance.navigateToPageClear("/noNetwork", null);
        }
      } else {
        if (splashViewModel.splashFinished) {
          NavigationService.instance.navigateToPageClear("/home", null);
        }
      }
    });

    // Bağlantıyı sürekli dinlemeye başla
    ConnectivityService.instance.startMonitoring(
      onDisconnected: () {
        if (splashViewModel.splashFinished) {
          NavigationService.instance.navigateToPageClear("/noNetwork", null);
        }
      },
      onReconnected: () async {
        // Eğer bağlantı kesilip geri geldiyse yönlendir
        bool wasDisconnected =
            ConnectivityService.instance.wasPreviouslyDisconnected();
        if (wasDisconnected) {

          NavigationService.instance.navigateToPageClear("/home", null);

          // Bağlantı yeniden sağlandığında durumu sıfırla
          ConnectivityService.instance.resetWasDisconnected();
        }
      },
    );
  }

  // Uygulama sonlandığında dispose işlemi
  static void dispose() {
    ConnectivityService.instance.stopMonitoring();
  }
}
