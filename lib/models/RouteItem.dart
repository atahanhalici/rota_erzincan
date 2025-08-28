import 'package:flutter/material.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';

class RouteItem {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String iconName; // ✅ icon artık string
  final double distanceKm;
  final Duration duration;
  final bool isUserAdded;
  List<CategoryContentItem> stops;

  RouteItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.iconName,
    required this.distanceKm,
    required this.duration,
    required this.isUserAdded,
    required this.stops,
  });

  IconData get icon => _iconFromString(iconName);

  static IconData _iconFromString(String name) {
    switch (name) {
      case 'map':
        return Icons.map;
      case 'child_friendly':
        return Icons.child_friendly;
      case 'nature_people':
        return Icons.nature_people;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'explore':
        return Icons.explore;
      default:
        return Icons.route;
    }
  }

  // ✅ copyWith metodu
  RouteItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? imageUrl,
    String? iconName,
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
      iconName: iconName ?? this.iconName,
      distanceKm: distanceKm ?? this.distanceKm,
      duration: duration ?? this.duration,
      isUserAdded: isUserAdded ?? this.isUserAdded,
      stops: stops ?? this.stops,
    );
  }

  @override
  String toString() {
    return 'RouteItem(id: $id, title: $title, subtitle: $subtitle, '
        'imageUrl: $imageUrl, iconName: $iconName, distanceKm: $distanceKm, '
        'duration: ${duration.inMinutes}m, isUserAdded: $isUserAdded, '
        'stops: ${stops.map((s) => s.title).toList()})';
  }
}
