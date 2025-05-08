import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  ConnectivityService._internal();

  static ConnectivityService get instance => _instance;

  StreamSubscription<ConnectivityResult>? _subscription;
  ConnectivityResult? _lastConnectionStatus;
  bool _wasDisconnected = false;
  Timer? _debounceTimer; // Debounce için timer

  // Başlangıçta internet durumu kontrol edilir
  Future<bool> checkInitialConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _lastConnectionStatus = connectivityResult; // İlk durumu sakla
    return connectivityResult != ConnectivityResult.none;
  }

  bool _isMonitoring = false; // Yeni eklendi

  void startMonitoring({
    required void Function() onDisconnected,
    required void Function() onReconnected,
  }) {
    if (_isMonitoring) return;
    _isMonitoring = true;

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

      _debounceTimer = Timer(const Duration(seconds: 2), () {
        if (result == ConnectivityResult.none &&
            _lastConnectionStatus != ConnectivityResult.none) {
          _lastConnectionStatus = ConnectivityResult.none;
          _wasDisconnected = true;
          onDisconnected();
        } else if (result != ConnectivityResult.none &&
            _lastConnectionStatus == ConnectivityResult.none) {
          _lastConnectionStatus = result;
          onReconnected();
        } else {}
      });
    });
  }

  // Bağlantı kesilip geri geldi mi kontrolü
  bool wasPreviouslyDisconnected() {
    return _wasDisconnected;
  }

  // Bağlantı geri geldikten sonra durumu sıfırlama
  void resetWasDisconnected() {
    _wasDisconnected = false; // Artık bağlantı olduğu için durumu sıfırlıyoruz
  }

  void stopMonitoring() {
    _subscription?.cancel();
    _debounceTimer?.cancel();
    _isMonitoring = false; // eklendi
  }
}
