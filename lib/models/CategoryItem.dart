import 'package:flutter/material.dart';
import 'package:rota_erzincan/services/api_service.dart';

class CategoryItem {
  final int id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String iconName; // sadece string tut

  CategoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.iconName,
  });

  // IconData'ya dönüştüren getter
  IconData get icon => ApiService.iconFromName(iconName);

  @override
  String toString() {
    return 'CategoryItem(id: $id, title: $title, subtitle: $subtitle, '
        'imageUrl: $imageUrl, iconName: $iconName)';
  }
}
