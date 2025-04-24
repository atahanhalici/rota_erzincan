import 'package:flutter/material.dart';
import 'package:rota_erzincan/models/CameraModel.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/models/CategoryItem.dart';
import 'package:rota_erzincan/models/CategoryModel.dart';
import 'package:rota_erzincan/models/FacilityModel.dart';
import 'package:rota_erzincan/models/FeatureModel.dart';
import 'package:rota_erzincan/models/InfoCardModel.dart';
import 'package:rota_erzincan/models/PhotoModel.dart';
import 'package:rota_erzincan/models/RouteItem.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';

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

  Future<List<CategoryItem>> fetchAllCategories() async {
    await Future.delayed(const Duration(milliseconds: 500)); // sahte gecikme

    final List<Map<String, dynamic>> responseData = [
      {
        "title": "Müzeler",
        "subtitle": "Erzincan'ın tarihi müzeleri",
        "imageUrl": "https://picsum.photos/id/1003/600/900",
        "icon": Icons.museum,
      },
      {
        "title": "Lezzet Durakları",
        "subtitle": "Yöresel tatları keşfedin",
        "imageUrl": "https://picsum.photos/id/1080/600/900",
        "icon": Icons.restaurant,
      },
      {
        "title": "Kış Sporları",
        "subtitle": "Kayak ve diğer kış aktiviteleri",
        "imageUrl": "https://picsum.photos/id/1011/600/900",
        "icon": Icons.snowboarding,
      },
      {
        "title": "Şehrin Simgesel Eserleri",
        "subtitle": "Erzincan'ın sembol yapıları",
        "imageUrl": "https://picsum.photos/id/1015/600/900",
        "icon": Icons.location_city,
      },
      {
        "title": "Camiler",
        "subtitle": "Tarihi ve modern camiler",
        "imageUrl": "https://picsum.photos/id/1016/600/900",
        "icon": Icons.mosque,
      },
      {
        "title": "Türbeler",
        "subtitle": "Dini ve tarihi türbeler",
        "imageUrl": "https://picsum.photos/id/1019/600/900",
        "icon": Icons.account_balance,
      },
      {
        "title": "Oteller",
        "subtitle": "Konaklama seçenekleri",
        "imageUrl": "https://picsum.photos/id/1020/600/900",
        "icon": Icons.hotel,
      },
      {
        "title": "Kale ve Köprüler",
        "subtitle": "Tarihi yapılar ve manzaralar",
        "imageUrl": "https://picsum.photos/id/1024/600/900",
        "icon": Icons.fort,
      },
      {
        "title": "Sinemalar",
        "subtitle": "Film ve eğlence mekanları",
        "imageUrl": "https://picsum.photos/id/1025/600/900",
        "icon": Icons.movie,
      },
      {
        "title": "Arkeolojik Alanlar",
        "subtitle": "Antik yerleşimler ve kazı alanları",
        "imageUrl": "https://picsum.photos/id/1026/600/900",
        "icon": Icons.architecture,
      },
      {
        "title": "Kiliseler",
        "subtitle": "Tarihi kiliseler ve manastırlar",
        "imageUrl": "https://picsum.photos/id/1027/600/900",
        "icon": Icons.church,
      },
      {
        "title": "Zanaat ve Halk Sanatları",
        "subtitle": "Yerel el sanatları ve atölyeler",
        "imageUrl": "https://picsum.photos/id/1031/600/900",
        "icon": Icons.brush,
      },
      {
        "title": "Parklar ve Piknik Alanları",
        "subtitle": "Doğayla iç içe alanlar",
        "imageUrl": "https://picsum.photos/id/1033/600/900",
        "icon": Icons.park,
      },
      {
        "title": "Kütüphaneler",
        "subtitle": "Kitap ve kültür merkezleri",
        "imageUrl": "https://picsum.photos/id/1035/600/900",
        "icon": Icons.book,
      },
      {
        "title": "Nasıl Gelirim",
        "subtitle": "Ulaşım rehberi",
        "imageUrl": "https://picsum.photos/id/1036/600/900",
        "icon": Icons.directions_bus,
      },
      {
        "title": "Şehir İçi Ulaşım İmkanları",
        "subtitle": "Toplu taşıma ve araç kiralama",
        "imageUrl": "https://picsum.photos/id/1037/600/900",
        "icon": Icons.emoji_transportation,
      },
      {
        "title": "Erzincan Lezzetleri",
        "subtitle": "Yöresel mutfak ve tarifler",
        "imageUrl": "https://picsum.photos/id/1038/600/900",
        "icon": Icons.restaurant_menu,
      },
      {
        "title": "Spor Alanları",
        "subtitle": "Spor tesisleri ve aktiviteleri",
        "imageUrl": "https://picsum.photos/id/1039/600/900",
        "icon": Icons.sports_soccer,
      },
    ];

    // Map'ten CategoryItem listesine dönüştür
    return responseData.map((data) {
      return CategoryItem(
        title: data['title'],
        subtitle: data['subtitle'],
        imageUrl: data['imageUrl'],
        icon: data['icon'],
      );
    }).toList();
  }

  Future<List<RouteItem>> fetchAllRoutes() async {
    await Future.delayed(const Duration(milliseconds: 500)); // sahte gecikme

    final List<Map<String, dynamic>> responseData = [
      {
        "title": "Tarihin İçinden Rotası",
        "subtitle": "Erzincan'ın tarihi ve kültürel zenginliklerini keşfedin.",
        "imageUrl": "https://picsum.photos/id/1011/600/400",
        "icon": Icons.account_balance,
        "distanceKm": 1.6,
        "durationMinutes": 20,
      },
      {
        "title": "Çocuğumla Geziyorum Rotası",
        "subtitle": "Ailece eğlenebileceğiniz parklar ve etkinlikler.",
        "imageUrl": "https://picsum.photos/id/1027/600/400",
        "icon": Icons.child_friendly,
        "distanceKm": 2.1,
        "durationMinutes": 25,
      },
      {
        "title": "Doğadan Esintiler Rotası",
        "subtitle": "Doğayla iç içe huzurlu rotaları keşfedin.",
        "imageUrl": "https://picsum.photos/id/1043/600/400",
        "icon": Icons.nature_people,
        "distanceKm": 3.0,
        "durationMinutes": 40,
      },
      {
        "title": "Sporcunun Dostu Rotası",
        "subtitle": "Aktif yaşamı sevenler için ideal parkurlar.",
        "imageUrl": "https://picsum.photos/id/1052/600/400",
        "icon": Icons.fitness_center,
        "distanceKm": 2.7,
        "durationMinutes": 32,
      },
      {
        "title": "Erzincan ve Macera Rotası",
        "subtitle": "Adrenalin ve keşif dolu bir Erzincan deneyimi.",
        "imageUrl": "https://picsum.photos/id/1062/600/400",
        "icon": Icons.explore,
        "distanceKm": 4.4,
        "durationMinutes": 55,
      },
    ];
    const uuid = Uuid();
    return responseData.map((data) {
      return RouteItem(
          id: uuid.v4(),
          title: data['title'],
          subtitle: data['subtitle'],
          imageUrl: data['imageUrl'],
          icon: data['icon'],
          distanceKm: data['distanceKm'],
          duration: Duration(minutes: data['durationMinutes']),
          isUserAdded: false,
          stops: []);
    }).toList();
  }

  Future<List<CategoryContentItem>> getContents(CategoryItem category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final Random random = Random();

    return List.generate(
      10,
      (index) {
        // Erzincan merkezine göre ±0.02 derece sapma
        double latitude = 39.75 + (random.nextDouble() * 0.04 - 0.02);
        double longitude = 39.49 + (random.nextDouble() * 0.04 - 0.02);

        return CategoryContentItem(
          id: 'content_${category.title.toLowerCase()}_$index',
          title: 'Terzibaba Camii ve Külliyesi ${index + 1}',
          description:
              'Bu Terzibaba Camii ve Külliyesi ${index + 1} kategorisi için içerik ${index + 1} açıklamasıdır.',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc',
          latitude: latitude,
          longitude: longitude,
        );
      },
    );
  }

  Future<List<CategoryContentItem>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      CategoryContentItem(
        id: 'content_filmler_0',
        title: 'Vizyondaki Filmler',
        description:
            'Erzincan sinemalarında izleyebileceğiniz filmleri keşfedin.',
        imageUrl: 'https://picsum.photos/seed/movie_theater/600/400',
        latitude: 0, // örnek koordinatlar
        longitude: 0,
      ),
      CategoryContentItem(
        id: 'content_tiyatrolar_1',
        title: 'Tiyatrolar',
        description:
            'Kültürel etkinlikler ve sahne sanatları için eşsiz tiyatrolar.',
        imageUrl: 'https://picsum.photos/seed/theater_stage/600/400',
        latitude: 0, // örnek koordinatlar
        longitude: 0,
      ),
    ];
  }

  Future<List<FeatureModel>> fetchFeatures() async {
    await Future.delayed(const Duration(milliseconds: 500)); // sahte gecikme

    final List<Map<String, dynamic>> _features = [
      {
        "title": "Ergan Dağı Kayak Merkezi",
        "subtitle": "Canlı Durum",
        "imageUrl": "https://picsum.photos/id/1036/800/500",
        "icon": Icons.snowboarding,
        "id": 0
      },
      {
        "title": "Bu Ayın Etkinlikleri",
        "subtitle": "Kaçırma!",
        "imageUrl": "https://picsum.photos/id/169/800/500",
        "icon": Icons.event,
        "id": 1
      },
      {
        "title": "Macera ve Doğa",
        "subtitle": "İç İçe Olduğu Yerler",
        "imageUrl": "https://picsum.photos/id/110/800/500",
        "icon": Icons.terrain,
        "id": 2
      },
      {
        "title": "Coğrafi İşaretli Ürünler",
        "subtitle": "Yerel Lezzetler",
        "imageUrl": "https://picsum.photos/id/292/800/500",
        "icon": Icons.verified,
        "id": 3
      },
      {
        "title": "Görülmesi Gereken Yerler",
        "subtitle": "Erzincan'ın İncileri",
        "imageUrl": "https://picsum.photos/id/15/800/500",
        "icon": Icons.place,
        "id": 4
      },
      {
        "title": "Yapmadan Ayrılmayın",
        "subtitle": "Deneyimler",
        "imageUrl": "https://picsum.photos/id/184/800/500",
        "icon": Icons.star,
        "id": 5
      },
      {
        "title": "Konaklama",
        "subtitle": "Nerede Kalınır?",
        "imageUrl": "https://picsum.photos/id/238/800/500",
        "icon": Icons.hotel,
        "id": 6
      },
    ];

    return _features.map((item) => FeatureModel.fromJson(item)).toList();
  }

  Future<List<InfoCardModel>> fetchInfoCards() async {
    await Future.delayed(const Duration(milliseconds: 500)); // sahte gecikme

    final rawData = [
      {"label": "Sıcaklık", "value": "-2°C", "icon": "thermostat"},
      {"label": "Rüzgar", "value": "15 km/h", "icon": "air"},
      {"label": "Hava", "value": "Kar Yağışlı", "icon": "cloud"},
      {"label": "3278 m", "value": "150 cm", "icon": "ac_unit"},
      {"label": "2355 m", "value": "120 cm", "icon": "ac_unit"},
      {"label": "1740 m", "value": "95 cm", "icon": "ac_unit"},
    ];

    List<InfoCardModel> infoCards =
        rawData.map((e) => InfoCardModel.fromJson(e)).toList();
    return infoCards;
  }

  Future<List<FacilityModel>> fetchFacilityItems() async {
    await Future.delayed(const Duration(milliseconds: 500)); // sahte gecikme

    final List<Map<String, dynamic>> items = [
      {
        "label": "Kameralar",
        "icon": Icons.videocam,
        "active": true,
        "extraText": "İzlemek için tıklayın",
        "onTap": () {},
      },
      {
        "label": "Gondol",
        "icon": Icons.cable,
        "active": true,
      },
      {
        "label": "Kızak Pisti",
        "icon": Icons.snowboarding,
        "active": false,
      },
      {
        "label": "T-Bar",
        "icon": Icons.arrow_upward,
        "active": true,
      },
      {
        "label": "1. Etap",
        "icon": Icons.landscape,
        "active": true,
      },
      {
        "label": "2. Etap",
        "icon": Icons.terrain,
        "active": false,
      },
    ];

    List<FacilityModel> facilityItems =
        items.map((e) => FacilityModel.fromJson(e)).toList();
    return facilityItems;
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

  Future<List<CameraModel>> fetchFakeCameras() async {
    await Future.delayed(const Duration(seconds: 1)); // simülasyon gecikmesi

    const String thumbnailUrl =
        'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/ergan.jpeg?alt=media&token=21637606-bf8f-4bf3-b758-ef8858560097';

    final List<Map<String, dynamic>> fakeData = [
      {
        'name': 'Ergan Kayak Merkezi - Göl',
        'url': 'https://tv-trt1.medya.trt.com.tr/master_480.m3u8',
        'description':
            'Ergan Göl bölgesine ait canlı kamera görüntüsü. Göl çevresi ve çevredeki doğal manzarayı anlık izleyebilirsiniz.',
        'status': 'Çevrimiçi',
        'icon': Icons.terrain.codePoint,
        'thumbnail': thumbnailUrl,
      },
      {
        'name': 'Ergan Kayak Merkezi - 1. Etap',
        'url': 'https://tv-trt1.medya.trt.com.tr/master_480.m3u8',
        'description':
            '1. etap kayak pistinden canlı yayın. Pist giriş noktası ve çevresindeki kayak faaliyetlerini buradan takip edin.',
        'status': 'Çevrimiçi',
        'icon': Icons.landscape.codePoint,
        'thumbnail': thumbnailUrl,
      },
      {
        'name': 'Ergan Kayak Merkezi - 2. Etap',
        'url': 'https://tv-trt1.medya.trt.com.tr/master_480.m3u8',
        'description':
            '2. etap zirve bölgesinden panoramik canlı yayın. Geniş manzara, kayak rotaları ve hava durumu takibi için birebir.',
        'status': 'Çevrimiçi',
        'icon': Icons.downhill_skiing.codePoint,
        'thumbnail': thumbnailUrl,
      },
    ];

    return fakeData.map((json) => CameraModel.fromJson(json)).toList();
  }
}
