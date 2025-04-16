import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/CameraModel.dart';
import 'package:rota_erzincan/services/api_service.dart';
import 'package:video_player/video_player.dart';

class LiveCamsPageViewModel extends ChangeNotifier with BaseViewModel {
  final ApiService _apiService = ApiService();
  late final AnimationController controller;
  late final Animation<double> headerAnimation;
  bool isInitialized = false;
  bool _isDisposed = false;
  bool isLoading = false;

  List<CameraModel> cameras = [];
  /* LiveCamsPageViewModel() {
    loadCameras();
  }*/

  Future<void> loadCameras() async {
    print("sa");
    isLoading = false;
    cameras =
        await _apiService.fetchFakeCameras(); // burası sahte veriyi alacak
    isLoading = true;
    notifyListeners();
  }

  void initialize(TickerProvider vsync) {
    // 🛡️ controller zaten varsa yeniden oluşturma
    if (isInitialized) return;
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: vsync,
    )..forward();

    headerAnimation = Tween<double>(begin: -50, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );
    loadCameras();
    isInitialized = true;
  }

  @override
  void dispose() {
    _isDisposed = true;

    // eğer controller varsa, dispose et
    try {
      controller.dispose();
    } catch (_) {}

    super.dispose();
  }

  void showControlsTemporarily() {
    if (_isDisposed) return; // ✅ önce dispose kontrolü

    showPlayPause = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 3)).then((_) {
      if (_isDisposed) return;
      showPlayPause = false;
      notifyListeners(); // ✅ sadece hâlâ aktifse
    });
  }

  void disposeVideo() {
    videoController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _isDisposed = true;
  }

  late VideoPlayerController videoController;
  bool isVideoReady = false;
  bool showPlayPause = false;

  void initVideoController(String url, VoidCallback onReady) {
    videoController = VideoPlayerController.network(url)
      ..initialize().then((_) {
        isVideoReady = true;
        videoController.play();
        notifyListeners();
        onReady(); // FastLiveStream içinde setState tetiklemek için
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      });
  }

  void togglePlayback() {
    if (videoController.value.isPlaying) {
      videoController.pause();
    } else {
      videoController.play();
    }
    notifyListeners();
  }
}
