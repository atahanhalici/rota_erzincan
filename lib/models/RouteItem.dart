import 'package:flutter/material.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart'; // ✅ bu satırı unutma

class RouteItem {
  final String id; // ✅ Yeni eklendi
  final String title;
  final String subtitle;
  final String imageUrl;
  final IconData icon;
  final double distanceKm;
  final Duration duration;
  final bool isUserAdded;
  final List<CategoryContentItem> stops;

  RouteItem({
    required this.id, // ✅ constructor'a eklendi
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.icon,
    required this.distanceKm,
    required this.duration,
    required this.isUserAdded,
    required this.stops,
  });

  @override
  String toString() {
    return 'RouteItem(id: $id, title: $title, subtitle: $subtitle, '
        'distanceKm: ${distanceKm.toStringAsFixed(2)}, duration: $duration, '
        'isUserAdded: $isUserAdded, stops: ${stops.map((e) => e.title).toList()})';
  }
}
