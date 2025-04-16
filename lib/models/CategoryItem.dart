import 'package:flutter/material.dart';

class CategoryItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final IconData icon;

  CategoryItem(
      {required this.title,
      required this.subtitle,
      required this.imageUrl,
      required this.icon});
}