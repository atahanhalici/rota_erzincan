import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:provider/provider.dart';

class EmergencyPhoneBottomSheet extends StatelessWidget {
  const EmergencyPhoneBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 30, top: 10),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 5,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Text(
            'emergencyPhoneTitle'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeProvider.textColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildEmergencyCallButton(
              'emergencyPhone112'.tr(), "112", Colors.red),
          const SizedBox(height: 10),
          _buildEmergencyCallButton(
              'emergencyPhone997'.tr(), "997", Colors.blue),
          const SizedBox(height: 10),
          _buildEmergencyCallButton(
              'emergencyPhone122'.tr(), "998", Colors.orange),
          const SizedBox(height: 10),
          _buildEmergencyCallButton(
              'emergencyPhone999'.tr(), "999", Colors.green),
        ],
      ),
    );
  }

  Widget _buildEmergencyCallButton(String text, String number, Color color) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: TextButton.icon(
        onPressed: () {
          // launchUrl(Uri.parse('tel:$number'));
        },
        icon: Icon(
          Icons.phone,
          color: color,
        ),
        label: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
