import 'package:flutter/material.dart';
import 'package:rota_erzincan/models/CategoryModel.dart';
import 'package:rota_erzincan/models/FeatureModel.dart';

class ApiService {
  Future<List<CategoryModel>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 500)); // sahte gecikme

    final List<String> titles = [
      "Tarih ve Kültür",
      "Doğa",
      "Gastronomi",
      "İnanç",
      "Müze ve Sanat",
      "Alışveriş",
      "El Sanatları",
      "Gençlik - Spor",
      "Acenteler",
    ];

    return titles.asMap().entries.map((entry) {
      int index = entry.key;
      String title = entry.value;
      return CategoryModel(
        title: title,
        imageUrl: "https://picsum.photos/seed/${index + 1}/600/1000",
      );
    }).toList();
  }

  Future<List<FeatureModel>> fetchFeatures() async {
    await Future.delayed(const Duration(milliseconds: 500)); // sahte gecikme

    final List<Map<String, dynamic>> _features = [
      {
        "title": "Ergan Dağı Kayak Merkezi",
        "subtitle": "Canlı Durum",
        "imageUrl": "https://picsum.photos/id/1036/800/500",
        "icon": Icons.snowboarding,
      },
      {
        "title": "Bu Ayın Etkinlikleri",
        "subtitle": "Kaçırma!",
        "imageUrl": "https://picsum.photos/id/169/800/500",
        "icon": Icons.event,
      },
      {
        "title": "Macera ve Doğa",
        "subtitle": "İç İçe Olduğu Yerler",
        "imageUrl": "https://picsum.photos/id/110/800/500",
        "icon": Icons.terrain,
      },
      {
        "title": "Coğrafi İşaretli Ürünler",
        "subtitle": "Yerel Lezzetler",
        "imageUrl": "https://picsum.photos/id/292/800/500",
        "icon": Icons.verified,
      },
      {
        "title": "Görülmesi Gereken Yerler",
        "subtitle": "Erzincan'ın İncileri",
        "imageUrl": "https://picsum.photos/id/15/800/500",
        "icon": Icons.place,
      },
      {
        "title": "Yapmadan Ayrılmayın",
        "subtitle": "Deneyimler",
        "imageUrl": "https://picsum.photos/id/184/800/500",
        "icon": Icons.star,
      },
      {
        "title": "Konaklama",
        "subtitle": "Nerede Kalınır?",
        "imageUrl": "https://picsum.photos/id/238/800/500",
        "icon": Icons.hotel,
      },
    ];

    return _features.map((item) => FeatureModel.fromJson(item)).toList();
  }
}
