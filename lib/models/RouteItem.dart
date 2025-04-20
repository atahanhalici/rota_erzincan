import 'package:flutter/material.dart';

class RouteItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final IconData icon;
  final double distanceKm; // ✅ Yeni eklendi
  final Duration duration; // ✅ Yeni eklendi

  RouteItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.icon,
    required this.distanceKm,
    required this.duration,
  });
}
