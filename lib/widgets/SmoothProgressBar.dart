import 'package:flutter/material.dart';

class SmoothProgressBar extends StatelessWidget {
  final Animation<double> animation;

  const SmoothProgressBar({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => LinearProgressIndicator(
        value: animation.value,
        backgroundColor: Colors.white30,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}
