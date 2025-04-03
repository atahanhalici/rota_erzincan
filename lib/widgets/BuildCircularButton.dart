import 'package:flutter/material.dart';

class BuildCircularButton extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  const BuildCircularButton({super.key, required this.bgColor, required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: bgColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: bgColor,
        child: Icon(icon, color: iconColor, size: 24),
      ),
    );
  }
}
