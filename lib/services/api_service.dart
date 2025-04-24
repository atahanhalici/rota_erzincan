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
  Future<List<CategoryModel>> fetchCategoriesTr() async {
    await Future.delayed(const Duration(milliseconds: 500));

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

  Future<List<CategoryModel>> fetchCategoriesEn() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<String> titles = [
      "History & Culture",
      "Nature",
      "Gastronomy",
      "Faith",
      "Museums & Art",
      "Shopping",
      "Handicrafts",
      "Youth & Sports",
      "Agencies",
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

  Future<List<CategoryItem>> fetchAllCategoriesTr() async {
    await Future.delayed(const Duration(milliseconds: 500)); // sahte gecikme

    final List<Map<String, dynamic>> responseData = [
      {
        "id": 0,
        "title": "Müzeler",
        "subtitle": "Erzincan'ın tarihi müzeleri",
        "imageUrl": "https://picsum.photos/id/1003/600/900",
        "icon": Icons.museum,
      },
      {
        "id": 1,
        "title": "Lezzet Durakları",
        "subtitle": "Yöresel tatları keşfedin",
        "imageUrl": "https://picsum.photos/id/1080/600/900",
        "icon": Icons.restaurant,
      },
      {
        "id": 2,
        "title": "Kış Sporları",
        "subtitle": "Kayak ve diğer kış aktiviteleri",
        "imageUrl": "https://picsum.photos/id/1011/600/900",
        "icon": Icons.snowboarding,
      },
      {
        "id": 3,
        "title": "Şehrin Simgesel Eserleri",
        "subtitle": "Erzincan'ın sembol yapıları",
        "imageUrl": "https://picsum.photos/id/1015/600/900",
        "icon": Icons.location_city,
      },
      {
        "id": 4,
        "title": "Camiler",
        "subtitle": "Tarihi ve modern camiler",
        "imageUrl": "https://picsum.photos/id/1016/600/900",
        "icon": Icons.mosque,
      },
      {
        "id": 5,
        "title": "Türbeler",
        "subtitle": "Dini ve tarihi türbeler",
        "imageUrl": "https://picsum.photos/id/1019/600/900",
        "icon": Icons.account_balance,
      },
      {
        "id": 6,
        "title": "Oteller",
        "subtitle": "Konaklama seçenekleri",
        "imageUrl": "https://picsum.photos/id/1020/600/900",
        "icon": Icons.hotel,
      },
      {
        "id": 7,
        "title": "Kale ve Köprüler",
        "subtitle": "Tarihi yapılar ve manzaralar",
        "imageUrl": "https://picsum.photos/id/1024/600/900",
        "icon": Icons.fort,
      },
      {
        "id": 8,
        "title": "Sinemalar",
        "subtitle": "Film ve eğlence mekanları",
        "imageUrl": "https://picsum.photos/id/1025/600/900",
        "icon": Icons.movie,
      },
      {
        "id": 9,
        "title": "Arkeolojik Alanlar",
        "subtitle": "Antik yerleşimler ve kazı alanları",
        "imageUrl": "https://picsum.photos/id/1026/600/900",
        "icon": Icons.architecture,
      },
      {
        "id": 10,
        "title": "Kiliseler",
        "subtitle": "Tarihi kiliseler ve manastırlar",
        "imageUrl": "https://picsum.photos/id/1027/600/900",
        "icon": Icons.church,
      },
      {
        "id": 11,
        "title": "Zanaat ve Halk Sanatları",
        "subtitle": "Yerel el sanatları ve atölyeler",
        "imageUrl": "https://picsum.photos/id/1031/600/900",
        "icon": Icons.brush,
      },
      {
        "id": 12,
        "title": "Parklar ve Piknik Alanları",
        "subtitle": "Doğayla iç içe alanlar",
        "imageUrl": "https://picsum.photos/id/1033/600/900",
        "icon": Icons.park,
      },
      {
        "id": 13,
        "title": "Kütüphaneler",
        "subtitle": "Kitap ve kültür merkezleri",
        "imageUrl": "https://picsum.photos/id/1035/600/900",
        "icon": Icons.book,
      },
      {
        "id": 14,
        "title": "Nasıl Gelirim",
        "subtitle": "Ulaşım rehberi",
        "imageUrl": "https://picsum.photos/id/1036/600/900",
        "icon": Icons.directions_bus,
      },
      {
        "id": 15,
        "title": "Şehir İçi Ulaşım İmkanları",
        "subtitle": "Toplu taşıma ve araç kiralama",
        "imageUrl": "https://picsum.photos/id/1037/600/900",
        "icon": Icons.emoji_transportation,
      },
      {
        "id": 16,
        "title": "Erzincan Lezzetleri",
        "subtitle": "Yöresel mutfak ve tarifler",
        "imageUrl": "https://picsum.photos/id/1038/600/900",
        "icon": Icons.restaurant_menu,
      },
      {
        "id": 17,
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
          id: data["id"]);
    }).toList();
  }

  Future<List<CategoryItem>> fetchAllCategoriesEn() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<Map<String, dynamic>> responseData = [
      {
        "id": 0,
        "title": "Museums",
        "subtitle": "Historical museums of Erzincan",
        "imageUrl": "https://picsum.photos/id/1003/600/900",
        "icon": Icons.museum,
      },
      {
        "id": 1,
        "title": "Taste Stops",
        "subtitle": "Discover local flavors",
        "imageUrl": "https://picsum.photos/id/1080/600/900",
        "icon": Icons.restaurant,
      },
      {
        "id": 2,
        "title": "Winter Sports",
        "subtitle": "Skiing and winter activities",
        "imageUrl": "https://picsum.photos/id/1011/600/900",
        "icon": Icons.snowboarding,
      },
      {
        "id": 3,
        "title": "Iconic Landmarks",
        "subtitle": "Symbolic structures of Erzincan",
        "imageUrl": "https://picsum.photos/id/1015/600/900",
        "icon": Icons.location_city,
      },
      {
        "id": 4,
        "title": "Mosques",
        "subtitle": "Historic and modern mosques",
        "imageUrl": "https://picsum.photos/id/1016/600/900",
        "icon": Icons.mosque,
      },
      {
        "id": 5,
        "title": "Tombs",
        "subtitle": "Religious and historical shrines",
        "imageUrl": "https://picsum.photos/id/1019/600/900",
        "icon": Icons.account_balance,
      },
      {
        "id": 6,
        "title": "Hotels",
        "subtitle": "Accommodation options",
        "imageUrl": "https://picsum.photos/id/1020/600/900",
        "icon": Icons.hotel,
      },
      {
        "id": 7,
        "title": "Castles and Bridges",
        "subtitle": "Historic structures and views",
        "imageUrl": "https://picsum.photos/id/1024/600/900",
        "icon": Icons.fort,
      },
      {
        "id": 8,
        "title": "Cinemas",
        "subtitle": "Film and entertainment venues",
        "imageUrl": "https://picsum.photos/id/1025/600/900",
        "icon": Icons.movie,
      },
      {
        "id": 9,
        "title": "Archaeological Sites",
        "subtitle": "Ancient settlements and excavations",
        "imageUrl": "https://picsum.photos/id/1026/600/900",
        "icon": Icons.architecture,
      },
      {
        "id": 10,
        "title": "Churches",
        "subtitle": "Historical churches and monasteries",
        "imageUrl": "https://picsum.photos/id/1027/600/900",
        "icon": Icons.church,
      },
      {
        "id": 11,
        "title": "Crafts & Folk Arts",
        "subtitle": "Local crafts and workshops",
        "imageUrl": "https://picsum.photos/id/1031/600/900",
        "icon": Icons.brush,
      },
      {
        "id": 12,
        "title": "Parks and Picnic Areas",
        "subtitle": "Places close to nature",
        "imageUrl": "https://picsum.photos/id/1033/600/900",
        "icon": Icons.park,
      },
      {
        "id": 13,
        "title": "Libraries",
        "subtitle": "Book and culture centers",
        "imageUrl": "https://picsum.photos/id/1035/600/900",
        "icon": Icons.book,
      },
      {
        "id": 14,
        "title": "How to Get Here",
        "subtitle": "Transportation guide",
        "imageUrl": "https://picsum.photos/id/1036/600/900",
        "icon": Icons.directions_bus,
      },
      {
        "id": 15,
        "title": "Urban Transport Options",
        "subtitle": "Public transport and car rental",
        "imageUrl": "https://picsum.photos/id/1037/600/900",
        "icon": Icons.emoji_transportation,
      },
      {
        "id": 16,
        "title": "Erzincan Flavors",
        "subtitle": "Local cuisine and recipes",
        "imageUrl": "https://picsum.photos/id/1038/600/900",
        "icon": Icons.restaurant_menu,
      },
      {
        "id": 17,
        "title": "Sports Areas",
        "subtitle": "Sports facilities and activities",
        "imageUrl": "https://picsum.photos/id/1039/600/900",
        "icon": Icons.sports_soccer,
      },
    ];

    return responseData.map((data) {
      return CategoryItem(
        id: data['id'],
        title: data['title'],
        subtitle: data['subtitle'],
        imageUrl: data['imageUrl'],
        icon: data['icon'],
      );
    }).toList();
  }

  Future<List<RouteItem>> fetchAllRoutesTr() async {
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

  Future<List<RouteItem>> fetchAllRoutesEn() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<Map<String, dynamic>> responseData = [
      {
        "title": "Journey Through History",
        "subtitle":
            "Discover the historical and cultural richness of Erzincan.",
        "imageUrl": "https://picsum.photos/id/1011/600/400",
        "icon": Icons.account_balance,
        "distanceKm": 1.6,
        "durationMinutes": 20,
      },
      {
        "title": "Exploring with My Child",
        "subtitle": "Family-friendly parks and activities.",
        "imageUrl": "https://picsum.photos/id/1027/600/400",
        "icon": Icons.child_friendly,
        "distanceKm": 2.1,
        "durationMinutes": 25,
      },
      {
        "title": "Breeze from Nature",
        "subtitle": "Discover peaceful routes in nature.",
        "imageUrl": "https://picsum.photos/id/1043/600/400",
        "icon": Icons.nature_people,
        "distanceKm": 3.0,
        "durationMinutes": 40,
      },
      {
        "title": "Athlete’s Companion Route",
        "subtitle": "Perfect paths for an active lifestyle.",
        "imageUrl": "https://picsum.photos/id/1052/600/400",
        "icon": Icons.fitness_center,
        "distanceKm": 2.7,
        "durationMinutes": 32,
      },
      {
        "title": "Erzincan Adventure Route",
        "subtitle": "An Erzincan experience full of adrenaline and discovery.",
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
        stops: [],
      );
    }).toList();
  }

  Future<List<CategoryContentItem>> getContentsTr(CategoryItem category) async {
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

  Future<List<CategoryContentItem>> getContentsEn(CategoryItem category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final Random random = Random();

    return List.generate(
      10,
      (index) {
        double latitude = 39.75 + (random.nextDouble() * 0.04 - 0.02);
        double longitude = 39.49 + (random.nextDouble() * 0.04 - 0.02);

        return CategoryContentItem(
          id: 'content_${category.title.toLowerCase()}_$index',
          title: 'Terzibaba Mosque and Complex ${index + 1}',
          description:
              'This is the content description ${index + 1} for the Terzibaba Mosque and Complex in category ${index + 1}.',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc',
          latitude: latitude,
          longitude: longitude,
        );
      },
    );
  }

  Future<List<CategoryContentItem>> getEventsTr() async {
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

  Future<List<CategoryContentItem>> getEventsEn() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      CategoryContentItem(
        id: 'content_filmler_0',
        title: 'Now Showing',
        description: 'Discover movies currently playing in Erzincan cinemas.',
        imageUrl: 'https://picsum.photos/seed/movie_theater/600/400',
        latitude: 0,
        longitude: 0,
      ),
      CategoryContentItem(
        id: 'content_tiyatrolar_1',
        title: 'Theaters',
        description: 'Unique theaters for cultural events and performing arts.',
        imageUrl: 'https://picsum.photos/seed/theater_stage/600/400',
        latitude: 0,
        longitude: 0,
      ),
    ];
  }

  Future<List<FeatureModel>> fetchFeaturesTr() async {
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

  Future<List<FeatureModel>> fetchFeaturesEn() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<Map<String, dynamic>> _features = [
      {
        "title": "Ergan Mountain Ski Center",
        "subtitle": "Live Status",
        "imageUrl": "https://picsum.photos/id/1036/800/500",
        "icon": Icons.snowboarding,
        "id": 0
      },
      {
        "title": "This Month's Events",
        "subtitle": "Don’t Miss It!",
        "imageUrl": "https://picsum.photos/id/169/800/500",
        "icon": Icons.event,
        "id": 1
      },
      {
        "title": "Adventure & Nature",
        "subtitle": "Places Surrounded by Nature",
        "imageUrl": "https://picsum.photos/id/110/800/500",
        "icon": Icons.terrain,
        "id": 2
      },
      {
        "title": "Geographical Indications",
        "subtitle": "Local Delicacies",
        "imageUrl": "https://picsum.photos/id/292/800/500",
        "icon": Icons.verified,
        "id": 3
      },
      {
        "title": "Must-See Places",
        "subtitle": "Hidden Gems of Erzincan",
        "imageUrl": "https://picsum.photos/id/15/800/500",
        "icon": Icons.place,
        "id": 4
      },
      {
        "title": "Don't Leave Without Trying",
        "subtitle": "Experiences",
        "imageUrl": "https://picsum.photos/id/184/800/500",
        "icon": Icons.star,
        "id": 5
      },
      {
        "title": "Accommodation",
        "subtitle": "Where to Stay?",
        "imageUrl": "https://picsum.photos/id/238/800/500",
        "icon": Icons.hotel,
        "id": 6
      },
    ];

    return _features.map((item) => FeatureModel.fromJson(item)).toList();
  }

  Future<List<InfoCardModel>> fetchInfoCardsTr() async {
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

  Future<List<InfoCardModel>> fetchInfoCardsEn() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final rawData = [
      {"label": "Temperature", "value": "-2°C", "icon": "thermostat"},
      {"label": "Wind", "value": "15 km/h", "icon": "air"},
      {"label": "Weather", "value": "Snowy", "icon": "cloud"},
      {"label": "3278 m", "value": "150 cm", "icon": "ac_unit"},
      {"label": "2355 m", "value": "120 cm", "icon": "ac_unit"},
      {"label": "1740 m", "value": "95 cm", "icon": "ac_unit"},
    ];

    return rawData.map((e) => InfoCardModel.fromJson(e)).toList();
  }

  Future<List<FacilityModel>> fetchFacilityItemsTr() async {
    await Future.delayed(const Duration(milliseconds: 500)); // sahte gecikme

    final List<Map<String, dynamic>> items = [
      {
        "label": "Kameralar",
        "icon": Icons.videocam,
        "active": true,
        "extraText": "İzlemek için tıklayın",
        "onTap": () {},
        "id": 0
      },
      {"label": "Gondol", "icon": Icons.cable, "active": true, "id": 1},
      {
        "label": "Kızak Pisti",
        "icon": Icons.snowboarding,
        "active": false,
        "id": 2
      },
      {"label": "T-Bar", "icon": Icons.arrow_upward, "active": true, "id": 3},
      {"label": "1. Etap", "icon": Icons.landscape, "active": true, "id": 4},
      {"label": "2. Etap", "icon": Icons.terrain, "active": false, "id": 5},
    ];

    List<FacilityModel> facilityItems =
        items.map((e) => FacilityModel.fromJson(e)).toList();
    return facilityItems;
  }

  Future<List<FacilityModel>> fetchFacilityItemsEn() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<Map<String, dynamic>> items = [
      {
        "label": "Cameras",
        "icon": Icons.videocam,
        "active": true,
        "extraText": "Tap to watch",
        "onTap": () {},
        "id": 0
      },
      {"label": "Gondola", "icon": Icons.cable, "active": true, "id": 1},
      {
        "label": "Sled Track",
        "icon": Icons.snowboarding,
        "active": false,
        "id": 2
      },
      {"label": "T-Bar", "icon": Icons.arrow_upward, "active": true, "id": 3},
      {"label": "Stage 1", "icon": Icons.landscape, "active": true, "id": 4},
      {"label": "Stage 2", "icon": Icons.terrain, "active": false, "id": 5},
    ];

    return items.map((e) => FacilityModel.fromJson(e)).toList();
  }

  Future<Map<String, List<PhotoModel>>> fetchGalleryPhotosTr() async {
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

  Future<Map<String, List<PhotoModel>>> fetchGalleryPhotosEn() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final Map<String, List<Map<String, String>>> rawCategorizedImages = {
      "All": [
        {
          "title": "Erzincan Valley",
          "url": "https://picsum.photos/id/1015/600/900"
        },
        {
          "title": "Mountain View",
          "url": "https://picsum.photos/id/1016/600/900"
        },
        {
          "title": "Bridge and River",
          "url": "https://picsum.photos/id/1018/600/900"
        },
        {
          "title": "Historic Houses",
          "url": "https://picsum.photos/id/1019/600/900"
        },
        {
          "title": "Erzincan Table",
          "url": "https://picsum.photos/id/1020/600/900"
        },
        {
          "title": "Architectural Details",
          "url": "https://picsum.photos/id/1021/600/900"
        },
        {
          "title": "Highland Road",
          "url": "https://picsum.photos/id/1022/600/900"
        },
        {
          "title": "Cultural Event",
          "url": "https://picsum.photos/id/1023/600/900"
        },
        {
          "title": "Tasty Flavors",
          "url": "https://picsum.photos/id/1024/600/900"
        },
        {
          "title": "Erzincan Landscape",
          "url": "https://picsum.photos/id/1025/600/900"
        },
      ],
      "Nature": [
        {
          "title": "Erzincan Valley",
          "url": "https://picsum.photos/id/1015/600/900"
        },
        {
          "title": "Mountain View",
          "url": "https://picsum.photos/id/1016/600/900"
        },
        {
          "title": "Highland Road",
          "url": "https://picsum.photos/id/1022/600/900"
        },
        {
          "title": "Erzincan Landscape",
          "url": "https://picsum.photos/id/1025/600/900"
        },
      ],
      "Architecture": [
        {
          "title": "Historic Houses",
          "url": "https://picsum.photos/id/1019/600/900"
        },
        {
          "title": "Architectural Details",
          "url": "https://picsum.photos/id/1021/600/900"
        },
      ],
      "Culture": [
        {
          "title": "Cultural Event",
          "url": "https://picsum.photos/id/1023/600/900"
        },
      ],
      "Cuisine": [
        {
          "title": "Erzincan Table",
          "url": "https://picsum.photos/id/1020/600/900"
        },
        {
          "title": "Tasty Flavors",
          "url": "https://picsum.photos/id/1024/600/900"
        },
      ],
    };

    final categorizedImages = <String, List<PhotoModel>>{};
    rawCategorizedImages.forEach((key, value) {
      categorizedImages[key] =
          value.map((item) => PhotoModel.fromJson(item)).toList();
    });

    return categorizedImages;
  }

  Future<List<CameraModel>> fetchFakeCamerasTr() async {
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

  Future<List<CameraModel>> fetchFakeCamerasEn() async {
    await Future.delayed(const Duration(seconds: 1));

    const String thumbnailUrl =
        'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/ergan.jpeg?alt=media&token=21637606-bf8f-4bf3-b758-ef8858560097';

    final List<Map<String, dynamic>> fakeData = [
      {
        'name': 'Ergan Ski Center - Lake Area',
        'url': 'https://tv-trt1.medya.trt.com.tr/master_480.m3u8',
        'description':
            'Live camera stream of Ergan Lake area. You can instantly view the lake surroundings and natural scenery.',
        'status': 'Online',
        'icon': Icons.terrain.codePoint,
        'thumbnail': thumbnailUrl,
      },
      {
        'name': 'Ergan Ski Center - Stage 1',
        'url': 'https://tv-trt1.medya.trt.com.tr/master_480.m3u8',
        'description':
            'Live broadcast from the first ski slope. Watch ski activities around the entrance point of the track.',
        'status': 'Online',
        'icon': Icons.landscape.codePoint,
        'thumbnail': thumbnailUrl,
      },
      {
        'name': 'Ergan Ski Center - Stage 2',
        'url': 'https://tv-trt1.medya.trt.com.tr/master_480.m3u8',
        'description':
            'Panoramic live stream from the second peak area. Perfect for viewing ski routes and weather conditions.',
        'status': 'Online',
        'icon': Icons.downhill_skiing.codePoint,
        'thumbnail': thumbnailUrl,
      },
    ];

    return fakeData.map((json) => CameraModel.fromJson(json)).toList();
  }
}
