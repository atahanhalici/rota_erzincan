import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/CameraModel.dart';
import 'package:rota_erzincan/services/api_service.dart';
import 'package:video_player/video_player.dart';

class LiveCamsPageViewModel extends ChangeNotifier with BaseViewModel {
  final ApiService _apiService = ApiService();
  bool _isDisposed = false;
  bool isLoading = false;

  List<CameraModel> cameras = [];
  LiveCamsPageViewModel() {
    loadCameras();
  }

  Future<void> loadCameras() async {
    isLoading = false;
    _isDisposed = false;
    cameras = await _apiService.fetchFakeCameras();
    isLoading = true;
    notifyListeners();
  }

  @override
  void dispose() {
    if (!_isDisposed) {
      try {
        videoController.dispose();
      } catch (_) {}
      _isDisposed = true;
    }
    super.dispose();
  }

  void showControlsTemporarily() {
    if (_isDisposed) return;
    showPlayPause = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 3)).then((_) {
      if (_isDisposed) return;
      showPlayPause = false;
      notifyListeners();
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
        onReady();
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
