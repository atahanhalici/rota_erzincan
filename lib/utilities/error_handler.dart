import 'package:rota_erzincan/init/navigation/navigation_service.dart';
import 'package:rota_erzincan/constants/navigator_constants.dart';

class ErrorHandler {
  static void handle(dynamic error) {
    final nav = NavigationService.instance;

    if (error.toString().contains("Server error") ||
        error.toString().contains("Failed host lookup") ||
        error.toString().contains("İnternet bağlantısı yok") ||
        error.toString().contains("timeout") || // 🔥 Timeout eklendi
        error.toString().contains("yanıt alınamadı")) {
      // Türkçe versiyon
      // Sunucuya erişilemediğinde → ServerError sayfasına at
      nav.navigateToPageClear(NavigatorConstants.SERVER_ERROR, null);
    } else {
      // Farklı hataları burada loglayabilirsin
      print("Unhandled error: $error");
    }
  }
}
