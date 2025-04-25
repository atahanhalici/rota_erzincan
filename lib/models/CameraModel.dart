import 'package:flutter/material.dart';

class CameraModel {
  final String name;
  final String url;
  final String description;
  final String status;
  final String iconName; // ✅ IconData yerine string ikon adı
  final String thumbnail;

  CameraModel({
    required this.name,
    required this.url,
    required this.description,
    required this.status,
    required this.iconName,
    required this.thumbnail,
  });

  factory CameraModel.fromJson(Map<String, dynamic> json) {
    return CameraModel(
      name: json['name'],
      url: json['url'],
      description: json['description'],
      status: json['status'],
      iconName: json['icon'], // ✅ string ikon adı
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'description': description,
      'status': status,
      'icon': iconName, // ✅ string olarak kaydediliyor
      'thumbnail': thumbnail,
    };
  }

  IconData get icon => _iconFromString(iconName);

  static IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'terrain':
        return Icons.terrain;
      case 'landscape':
        return Icons.landscape;
      case 'downhill_skiing':
        return Icons.downhill_skiing;
      default:
        return Icons.camera_alt; // fallback
    }
  }
}
