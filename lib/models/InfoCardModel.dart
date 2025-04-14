import 'package:flutter/material.dart';

class InfoCardModel {
  final String label;
  final String value;
  final IconData icon;

  InfoCardModel({
    required this.label,
    required this.value,
    required this.icon,
  });

  factory InfoCardModel.fromJson(Map<String, dynamic> json) {
    return InfoCardModel(
      label: json['label'],
      value: json['value'],
      icon: _mapIcon(json['icon']),
    );
  }

  static IconData _mapIcon(String iconName) {
    switch (iconName) {
      case 'thermostat':
        return Icons.thermostat;
      case 'air':
        return Icons.air;
      case 'cloud':
        return Icons.cloud;
      case 'ac_unit':
        return Icons.ac_unit;
      default:
        return Icons.info;
    }
  }
}
