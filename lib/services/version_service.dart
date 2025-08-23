import 'dart:io';
import 'package:rota_erzincan/services/api_service.dart';

class VersionService {
  final ApiService _apiService = ApiService();

  Future<String?> getVersionNumber() async {
    try {
      final version = await _apiService.fetchVersion();
      if (Platform.isAndroid) {
        return version!["android"];
      } else if (Platform.isIOS) {
        return version!["ios"];
      }
      return "error";
    } catch (e) {
      // Sunucu veya bağlantı hatası olursa "error" döndür
      return "error";
    }
  }
}
