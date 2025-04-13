import 'package:flutter/material.dart';
import 'package:rota_erzincan/models/CategoryModel.dart';
import 'package:rota_erzincan/models/FeatureModel.dart';
import 'package:rota_erzincan/models/PhotoModel.dart';

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

  Future<Map<String, List<PhotoModel>>> fetchGalleryPhotos() async {
    await Future.delayed(const Duration(milliseconds: 500)); // sahte gecikme

    final Map<String, List<Map<String, String>>> rawCategorizedImages = {
      "Tümü": [
        {
          "title": "Erzincan Vadisi",
          "url": "https://picsum.photos/id/1015/600/900"
        },
        {
          "title": "Dağ Manzarası",
          "url": "https://picsum.photos/id/1016/600/900"
        },
        {
          "title": "Köprü ve Irmak",
          "url": "https://picsum.photos/id/1018/600/900"
        },
        {
          "title": "Tarihi Evler",
          "url": "https://picsum.photos/id/1019/600/900"
        },
        {
          "title": "Erzincan Sofrası",
          "url": "https://picsum.photos/id/1020/600/900"
        },
        {
          "title": "Mimari Detaylar",
          "url": "https://picsum.photos/id/1021/600/900"
        },
        {"title": "Yayla Yolu", "url": "https://picsum.photos/id/1022/600/900"},
        {
          "title": "Kültürel Etkinlik",
          "url": "https://picsum.photos/id/1023/600/900"
        },
        {
          "title": "Lezzetli Tatlar",
          "url": "https://picsum.photos/id/1024/600/900"
        },
        {
          "title": "Erzincan Manzarası",
          "url": "https://picsum.photos/id/1025/600/900"
        },
      ],
      "Doğa": [
        {
          "title": "Erzincan Vadisi",
          "url": "https://picsum.photos/id/1015/600/900"
        },
        {
          "title": "Dağ Manzarası",
          "url": "https://picsum.photos/id/1016/600/900"
        },
        {"title": "Yayla Yolu", "url": "https://picsum.photos/id/1022/600/900"},
        {
          "title": "Erzincan Manzarası",
          "url": "https://picsum.photos/id/1025/600/900"
        },
      ],
      "Mimari": [
        {
          "title": "Tarihi Evler",
          "url": "https://picsum.photos/id/1019/600/900"
        },
        {
          "title": "Mimari Detaylar",
          "url": "https://picsum.photos/id/1021/600/900"
        },
      ],
      "Kültür": [
        {
          "title": "Kültürel Etkinlik",
          "url": "https://picsum.photos/id/1023/600/900"
        },
      ],
      "Yemek": [
        {
          "title": "Erzincan Sofrası",
          "url": "https://picsum.photos/id/1020/600/900"
        },
        {
          "title": "Lezzetli Tatlar",
          "url": "https://picsum.photos/id/1024/600/900"
        },
      ]
    };

    final categorizedImages = <String, List<PhotoModel>>{};

    rawCategorizedImages.forEach((key, value) {
      categorizedImages[key] =
          value.map((item) => PhotoModel.fromJson(item)).toList();
    });

    return categorizedImages;
  }
}
