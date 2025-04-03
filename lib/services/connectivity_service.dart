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

  // İnternet bağlantısını dinlemeye başla
  void startMonitoring({
    required void Function() onDisconnected,
    required void Function() onReconnected,
  }) {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Her bağlantı değişiminde debounce uyguluyoruz
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

      _debounceTimer = Timer(Duration(seconds: 2), () {
        // Bağlantı kesilirse
        if (result == ConnectivityResult.none &&
            _lastConnectionStatus != ConnectivityResult.none) {
          _lastConnectionStatus = ConnectivityResult.none;
          _wasDisconnected = true; // Bağlantı kesildiği için işaretliyoruz
          print("Connection lost and _wasDisconnected is set to true");
          onDisconnected();
        }
        // Bağlantı geri gelirse, debounce sonrası kontrol
        else if (result != ConnectivityResult.none &&
            _lastConnectionStatus == ConnectivityResult.none) {
          _lastConnectionStatus = result;
          print("Reconnected after debounce, checking stability...");
          onReconnected();
        }
      });
    });
  }

  // Bağlantı kesilip geri geldi mi kontrolü
  bool wasPreviouslyDisconnected() {
    print("Checking wasPreviouslyDisconnected: $_wasDisconnected");
    return _wasDisconnected;
  }

  // Bağlantı geri geldikten sonra durumu sıfırlama
  void resetWasDisconnected() {
    _wasDisconnected = false; // Artık bağlantı olduğu için durumu sıfırlıyoruz
    print("_wasDisconnected is reset to false");
  }

  // Dinlemeyi durdur
  void stopMonitoring() {
    _subscription?.cancel();
    _debounceTimer?.cancel();
  }
}
