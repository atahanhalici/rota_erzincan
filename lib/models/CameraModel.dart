import 'package:flutter/material.dart';

class CameraModel {
  final String name;
  final String url;
  final String description;
  final String status;
  final IconData icon;
  final String thumbnail;

  CameraModel({
    required this.name,
    required this.url,
    required this.description,
    required this.status,
    required this.icon,
    required this.thumbnail,
  });

  factory CameraModel.fromJson(Map<String, dynamic> json) {
    return CameraModel(
      name: json['name'],
      url: json['url'],
      description: json['description'],
      status: json['status'],
      icon: _iconFromCodePoint(json['icon']),
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'description': description,
      'status': status,
      'icon': icon.codePoint,
      'thumbnail': thumbnail,
    };
  }

  static IconData _iconFromCodePoint(int codePoint) {
    return IconData(codePoint, fontFamily: 'MaterialIcons');
  }
}
