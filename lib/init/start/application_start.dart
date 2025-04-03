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
        print("Initial connection failed, navigating to /noNetwork");
        if (splashViewModel.splashFinished) {
          NavigationService.instance.navigateToPageClear("/noNetwork", null);
        }
      } else {
        print("Initial connection successful, navigating to /welcome");
        if (splashViewModel.splashFinished) {
          NavigationService.instance.navigateToPageClear("/home", null);
        }
      }
    });

    // Bağlantıyı sürekli dinlemeye başla
    ConnectivityService.instance.startMonitoring(
      onDisconnected: () {
        print("Navigating to /noNetwork");
        if (splashViewModel.splashFinished) {
          NavigationService.instance.navigateToPageClear("/noNetwork", null);
        }
      },
      onReconnected: () async {
        // Eğer bağlantı kesilip geri geldiyse yönlendir
        bool wasDisconnected =
            ConnectivityService.instance.wasPreviouslyDisconnected();
        print("Was previously disconnected: $wasDisconnected");
        if (wasDisconnected) {
          print("Navigating to /welcome after reconnection");
         

       
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
