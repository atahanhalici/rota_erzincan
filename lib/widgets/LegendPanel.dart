import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:rota_erzincan/constants/string_constants.dart';
import 'package:rota_erzincan/theme_provider.dart';

class LegendPanel extends StatelessWidget {
  const LegendPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Positioned(
      bottom: 20,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: themeProvider.cardColor.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringConstants.legendTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeProvider.textColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            _buildLegendItem(
                Colors.blue, StringConstants.legendYourLocation, themeProvider),
            const SizedBox(height: 6),
            _buildLegendItem(ColorConstants.buttonColor,
                StringConstants.legendAssemblyArea, themeProvider),
            const SizedBox(height: 6),
            _buildLegendItem(
                Colors.green, StringConstants.legendNearestArea, themeProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(
      Color color, String label, ThemeProvider themeProvider) {
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: themeProvider.textColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
