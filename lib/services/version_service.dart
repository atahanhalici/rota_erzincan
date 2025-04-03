class VersionService {
  Future<String?> getVersionNumber() async {
    await Future.delayed(Duration(milliseconds: 500)); // 0.5 saniye bekleme
    return '1.0.0'; // Dönen sonuç
  }
}
