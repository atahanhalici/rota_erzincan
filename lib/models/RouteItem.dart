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
  RouteItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? imageUrl,
    IconData? icon,
    double? distanceKm,
    Duration? duration,
    bool? isUserAdded,
    List<CategoryContentItem>? stops,
  }) {
    return RouteItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      icon: icon ?? this.icon,
      distanceKm: distanceKm ?? this.distanceKm,
      duration: duration ?? this.duration,
      isUserAdded: isUserAdded ?? this.isUserAdded,
      stops: stops ?? this.stops,
    );
  }

  @override
  String toString() {
    return 'RouteItem(id: $id, title: $title, subtitle: $subtitle, '
        'distanceKm: ${distanceKm.toStringAsFixed(2)}, duration: $duration, '
        'isUserAdded: $isUserAdded, stops: ${stops.map((e) => e.title).toList()})';
  }
}
