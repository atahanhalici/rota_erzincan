import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rota_erzincan/init/navigation/navigation_service.dart';

class BackButtonOverlay extends StatefulWidget {
  const BackButtonOverlay({super.key});

  @override
  State<BackButtonOverlay> createState() => _BackButtonOverlayState();
}

class _BackButtonOverlayState extends State<BackButtonOverlay> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      child: GestureDetector(
        onTap: _handleBack,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(
            Platform.isIOS
                ? Icons.arrow_back_ios_new_rounded
                : Icons.arrow_back_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
    );
  }

  void _handleBack() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Yön değişimi animasyonu tamamlasın
    await Future.delayed(const Duration(milliseconds: 250));

    // Bir sonraki frame'de çalıştır
    Future.microtask(() {
      if (NavigationService.instance.navigatorKey.currentState?.canPop() ??
          false) {
        NavigationService.instance.navigatorKey.currentState?.pop();
      }
    });
  }
}
