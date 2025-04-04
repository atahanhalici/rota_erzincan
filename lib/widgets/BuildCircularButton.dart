import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class BuildCircularButton extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback? onTap;
  final bool isGlowing;

  const BuildCircularButton(
      {super.key,
      required this.bgColor,
      required this.onTap,
      required this.icon,
      this.isGlowing = false,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: AvatarGlow(
        glowColor: bgColor,
        glowRadiusFactor: 0.2,
        animate: isGlowing, // 🔥 Glow aç/kapat
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            splashColor: Colors.white.withOpacity(0.2), // Hafif bir efekt
            child: Ink(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
              ),
              child: SizedBox(
                width: 44, // radius: 22 için çap = 44
                height: 44,
                child: Center(
                  child: Icon(icon, color: iconColor, size: 24),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
