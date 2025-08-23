import 'package:flutter/material.dart';
import 'package:rota_erzincan/services/api_service.dart'; // iconFromName erişmek için (path'i seninkine göre ayarla)

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
    final iconStr = json['icon']?.toString();

    return InfoCardModel(
      label: json['label'] ?? '',
      value: json['value'] ?? '',
      icon: ApiService.iconFromName(iconStr), // 👈 buradan çeviriyor
    );
  }
}
