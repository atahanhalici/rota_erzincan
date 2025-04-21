import 'package:flutter/material.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/pages/SplashPage/splash_page_view_model.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late SplashPageViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = SplashPageViewModel();
    viewModel.init(this, context);
  }

  @override
  void dispose() {
    viewModel.disposeAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🔹 Arkaplan görseli + Zoom animasyonu
          AnimatedBuilder(
            animation: viewModel.scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: viewModel.scaleAnimation.value,
                child: Image.asset(
                  ImageConstants.splash,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),

          // 🔹 Sol üst logo
          Positioned(
            top: 70,
            left: 20,
            child: Image.asset(
              ImageConstants.logo,
              width: 160,
            ),
          ),
        ],
      ),
    );
  }
}
