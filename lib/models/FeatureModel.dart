import 'package:flutter/material.dart';

class FeatureModel {
  final String title;
  final String subtitle;
  final String imageUrl;
  final IconData icon;

  FeatureModel({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.icon,
  });

  // JSON'dan nesneye dönüştürme
  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      title: json["title"],
      subtitle: json["subtitle"],
      imageUrl: json["imageUrl"],
      icon: json["icon"], // Direkt icon objesi döndüğümüz için map'e gerek yok
    );
  }
}
