import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const BuildInfoItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.8),
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
