import 'package:flutter/material.dart';
import 'package:rota_erzincan/services/api_service.dart'; // iconFromName erişmek için (path'i seninkine göre ayarla)

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
    final iconStr = json['icon']?.toString();

    return FacilityModel(
      id: json['id'],
      label: json['label'] ?? '',
      icon: ApiService.iconFromName(iconStr), // 👈 artık buradan geliyor
      active: json['active'] ?? false,
      extraText: json['extraText'],
      onTap: null, // genelde API'den gelmeyecek, UI'da atanacak
    );
  }
}
