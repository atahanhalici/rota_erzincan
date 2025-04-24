import 'package:flutter/material.dart';

class FacilityModel {
  final int id;
  final String label;
  final IconData icon;
  final bool active;
  final String? extraText;
  final void Function()? onTap;

  FacilityModel({
    required this.label,
    required this.id,
    required this.icon,
    required this.active,
    this.extraText,
    this.onTap,
  });

  factory FacilityModel.fromJson(Map<String, dynamic> json) {
    return FacilityModel(
      id: json['id'],
      label: json['label'],
      icon: json['icon'] is String
          ? _mapIcon(json['icon'])
          : json['icon'] as IconData,
      active: json['active'] ?? false,
      extraText: json['extraText'],
      onTap: null, // genelde API'den gelmeyecek, UI'da atanacak
    );
  }

  static IconData _mapIcon(String iconName) {
    switch (iconName) {
      case 'videocam':
        return Icons.videocam;
      case 'cable':
        return Icons.cable;
      case 'snowboarding':
        return Icons.snowboarding;
      case 'arrow_upward':
        return Icons.arrow_upward;
      case 'landscape':
        return Icons.landscape;
      case 'terrain':
        return Icons.terrain;
      default:
        return Icons.help_outline;
    }
  }
}
