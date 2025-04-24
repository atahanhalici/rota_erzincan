import 'package:flutter/material.dart';

class CategoryItem {
  final int id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final IconData icon;

  CategoryItem(
      {required this.title,
      required this.id,
      required this.subtitle,
      required this.imageUrl,
      required this.icon});
}
