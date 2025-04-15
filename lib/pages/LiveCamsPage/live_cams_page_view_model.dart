import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:video_player/video_player.dart';

class LiveCamsPageViewModel extends ChangeNotifier with BaseViewModel {
  late final AnimationController controller;
  late final Animation<double> headerAnimation;
  bool isInitialized = false;
  bool _isDisposed = false;

  final List<Map<String, dynamic>> cameras = [
    {
      'name': 'Ergan Kayak Merkezi - Göl',
      'url': 'https://tv-trt1.medya.trt.com.tr/master_480.m3u8',
      'description':
          'Ergan Göl bölgesine ait canlı kamera görüntüsü. Göl çevresi ve çevredeki doğal manzarayı anlık izleyebilirsiniz.',
      'status': 'Çevrimiçi',
      'icon': Icons.terrain
    },
    {
      'name': 'Ergan Kayak Merkezi - 1. Etap',
      'url': 'https://tv-trt1.medya.trt.com.tr/master_480.m3u8',
      'description':
          '1. etap kayak pistinden canlı yayın. Pist giriş noktası ve çevresindeki kayak faaliyetlerini buradan takip edin.',
      'status': 'Çevrimiçi',
      'icon': Icons.landscape
    },
    {
      'name': 'Ergan Kayak Merkezi - 2. Etap',
      'url': 'https://tv-trt1.medya.trt.com.tr/master_480.m3u8',
      'description':
          '2. etap zirve bölgesinden panoramik canlı yayın. Geniş manzara, kayak rotaları ve hava durumu takibi için birebir.',
      'status': 'Çevrimiçi',
      'icon': Icons.downhill_skiing
    },
  ];

  void initialize(TickerProvider vsync) {
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

    isInitialized = true;
  }

  void disposeController() {
    controller.dispose();
    _isDisposed = true;
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
