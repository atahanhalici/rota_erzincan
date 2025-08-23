/*import 'package:flutter/material.dart';
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
      "Endüstri", // Endüstri ve Madencilik Mirası
      "Doğa Parkları", // Parklar ve Doğa Alanları
      "Silezya Mutfağı", // Silezya Mutfağı
      "Dini Miras", // Dini Miras
      "Müzeler", // Müzeler ve Modern Sanat
      "Alışveriş", // Alışveriş ve Pazarlar
      "El Sanatları", // Yerel El Sanatları ve Tasarım
      "Etkinlikler", // Etkinlikler ve Spor
      "Turizm Ofisleri" // Turizm Ofisleri ve Acenteler
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
      "Industry", // Industrial & Mining Heritage
      "Nature", // Parks & Nature Areas
      "Cuisine", // Silesian Cuisine
      "Religion", // Religious Heritage
      "Museums", // Museums & Modern Art
      "Shopping", // Shopping & Markets
      "Crafts", // Local Handicrafts & Design
      "Events", // Events & Sports
      "Tourism" // Tourist Offices & Agencies
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

  Future<List<CategoryModel>> fetchCategoriesPl() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<String> titles = [
      "Przemysł", // Dziedzictwo przemysłowe i górnicze
      "Parki i Przyroda", // Parki i obszary przyrodnicze
      "Kuchnia Śląska", // Kuchnia Śląska
      "Dziedzictwo Religijne", // Dziedzictwo religijne
      "Muzea", // Muzea i sztuka nowoczesna
      "Zakupy", // Zakupy i targi
      "Rękodzieło", // Rękodzieło lokalne i design
      "Wydarzenia", // Wydarzenia i sport
      "Biura Turystyczne" // Biura turystyczne i agencje
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
    await Future.delayed(const Duration(milliseconds: 500));

    final List<Map<String, dynamic>> responseData = [
      {
        "id": 0,
        "title": "Müzeler",
        "subtitle": "Silezya Müzesi ve diğer kültürel merkezler",
        "imageUrl": "https://picsum.photos/id/1003/600/900",
        "icon": Icons.museum,
      },
      {
        "id": 1,
        "title": "Lezzet Durakları",
        "subtitle": "Silezya mutfağının yerel tatlarını keşfedin",
        "imageUrl": "https://picsum.photos/id/1080/600/900",
        "icon": Icons.restaurant,
      },
      {
        "id": 2,
        "title": "Etkinlikler ve Spor",
        "subtitle": "Spodek Arena ve şehirdeki spor aktiviteleri",
        "imageUrl": "https://picsum.photos/id/1011/600/900",
        "icon": Icons.sports_soccer,
      },
      {
        "id": 3,
        "title": "Simgesel Yapılar",
        "subtitle": "Spodek, Nikiszowiec ve diğer önemli noktalar",
        "imageUrl": "https://picsum.photos/id/1015/600/900",
        "icon": Icons.location_city,
      },
      {
        "id": 4,
        "title": "Kiliseler",
        "subtitle": "Tarihi ve modern ibadethaneler",
        "imageUrl": "https://picsum.photos/id/1016/600/900",
        "icon": Icons.church,
      },
      {
        "id": 5,
        "title": "Endüstri Mirası",
        "subtitle": "Eski madenler, fabrikalar ve müzeler",
        "imageUrl": "https://picsum.photos/id/1019/600/900",
        "icon": Icons.factory,
      },
      {
        "id": 6,
        "title": "Oteller",
        "subtitle": "Konforlu konaklama seçenekleri",
        "imageUrl": "https://picsum.photos/id/1020/600/900",
        "icon": Icons.hotel,
      },
      {
        "id": 7,
        "title": "Köprüler ve Meydanlar",
        "subtitle": "Tarihi köprüler ve şehir meydanları",
        "imageUrl": "https://picsum.photos/id/1024/600/900",
        "icon": Icons.fort,
      },
      {
        "id": 8,
        "title": "Tiyatro ve Sinema",
        "subtitle": "Kültürel sahneler ve sinema salonları",
        "imageUrl": "https://picsum.photos/id/1025/600/900",
        "icon": Icons.movie,
      },
      {
        "id": 9,
        "title": "Madencilik Alanları",
        "subtitle": "Maden turları ve açık hava müzeleri",
        "imageUrl": "https://picsum.photos/id/1026/600/900",
        "icon": Icons.architecture,
      },
      {
        "id": 10,
        "title": "Sanat Galerileri",
        "subtitle": "Modern sanat galerileri ve sergiler",
        "imageUrl": "https://picsum.photos/id/1027/600/900",
        "icon": Icons.brush,
      },
      {
        "id": 11,
        "title": "Yerel El Sanatları",
        "subtitle": "Seramik, tekstil ve el işi ürünler",
        "imageUrl": "https://picsum.photos/id/1031/600/900",
        "icon": Icons.handyman,
      },
      {
        "id": 12,
        "title": "Parklar ve Bahçeler",
        "subtitle": "Silezya Parkı ve doğal alanlar",
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
        "subtitle": "Katowice ulaşım rehberi",
        "imageUrl": "https://picsum.photos/id/1036/600/900",
        "icon": Icons.directions_bus,
      },
      {
        "id": 15,
        "title": "Şehir İçi Ulaşım",
        "subtitle": "Tramvay, otobüs ve bisiklet yolları",
        "imageUrl": "https://picsum.photos/id/1037/600/900",
        "icon": Icons.emoji_transportation,
      },
      {
        "id": 16,
        "title": "Katowice Lezzetleri",
        "subtitle": "Yerel restoranlar ve tarifler",
        "imageUrl": "https://picsum.photos/id/1038/600/900",
        "icon": Icons.restaurant_menu,
      },
      {
        "id": 17,
        "title": "Spor Alanları",
        "subtitle": "Açık hava ve kapalı spor tesisleri",
        "imageUrl": "https://picsum.photos/id/1039/600/900",
        "icon": Icons.sports,
      },
    ];

    return responseData.map((data) {
      return CategoryItem(
        title: data['title'],
        subtitle: data['subtitle'],
        imageUrl: data['imageUrl'],
        icon: data['icon'],
        id: data["id"],
      );
    }).toList();
  }

  Future<List<CategoryItem>> fetchAllCategoriesEn() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<Map<String, dynamic>> responseData = [
      {
        "id": 0,
        "title": "Museums",
        "subtitle": "Silesian Museum and cultural centers",
        "imageUrl": "https://picsum.photos/id/1003/600/900",
        "icon": Icons.museum,
      },
      {
        "id": 1,
        "title": "Taste Stops",
        "subtitle": "Discover Silesian cuisine",
        "imageUrl": "https://picsum.photos/id/1080/600/900",
        "icon": Icons.restaurant,
      },
      {
        "id": 2,
        "title": "Events & Sports",
        "subtitle": "Spodek Arena and sports activities",
        "imageUrl": "https://picsum.photos/id/1011/600/900",
        "icon": Icons.sports_soccer,
      },
      {
        "id": 3,
        "title": "Iconic Landmarks",
        "subtitle": "Spodek, Nikiszowiec and other highlights",
        "imageUrl": "https://picsum.photos/id/1015/600/900",
        "icon": Icons.location_city,
      },
      {
        "id": 4,
        "title": "Churches",
        "subtitle": "Historic and modern places of worship",
        "imageUrl": "https://picsum.photos/id/1016/600/900",
        "icon": Icons.church,
      },
      {
        "id": 5,
        "title": "Industrial Heritage",
        "subtitle": "Former mines, factories and museums",
        "imageUrl": "https://picsum.photos/id/1019/600/900",
        "icon": Icons.factory,
      },
      {
        "id": 6,
        "title": "Hotels",
        "subtitle": "Comfortable accommodation options",
        "imageUrl": "https://picsum.photos/id/1020/600/900",
        "icon": Icons.hotel,
      },
      {
        "id": 7,
        "title": "Bridges & Squares",
        "subtitle": "Historic bridges and city squares",
        "imageUrl": "https://picsum.photos/id/1024/600/900",
        "icon": Icons.fort,
      },
      {
        "id": 8,
        "title": "Theatre & Cinema",
        "subtitle": "Cultural stages and cinemas",
        "imageUrl": "https://picsum.photos/id/1025/600/900",
        "icon": Icons.movie,
      },
      {
        "id": 9,
        "title": "Mining Sites",
        "subtitle": "Mine tours and open-air museums",
        "imageUrl": "https://picsum.photos/id/1026/600/900",
        "icon": Icons.architecture,
      },
      {
        "id": 10,
        "title": "Art Galleries",
        "subtitle": "Modern art exhibitions and galleries",
        "imageUrl": "https://picsum.photos/id/1027/600/900",
        "icon": Icons.brush,
      },
      {
        "id": 11,
        "title": "Local Handicrafts",
        "subtitle": "Ceramics, textiles and handmade goods",
        "imageUrl": "https://picsum.photos/id/1031/600/900",
        "icon": Icons.handyman,
      },
      {
        "id": 12,
        "title": "Parks & Gardens",
        "subtitle": "Silesian Park and green areas",
        "imageUrl": "https://picsum.photos/id/1033/600/900",
        "icon": Icons.park,
      },
      {
        "id": 13,
        "title": "Libraries",
        "subtitle": "Book and cultural centers",
        "imageUrl": "https://picsum.photos/id/1035/600/900",
        "icon": Icons.book,
      },
      {
        "id": 14,
        "title": "How to Get Here",
        "subtitle": "Transportation guide for Katowice",
        "imageUrl": "https://picsum.photos/id/1036/600/900",
        "icon": Icons.directions_bus,
      },
      {
        "id": 15,
        "title": "Urban Transport",
        "subtitle": "Trams, buses and bike lanes",
        "imageUrl": "https://picsum.photos/id/1037/600/900",
        "icon": Icons.emoji_transportation,
      },
      {
        "id": 16,
        "title": "Katowice Flavors",
        "subtitle": "Local restaurants and recipes",
        "imageUrl": "https://picsum.photos/id/1038/600/900",
        "icon": Icons.restaurant_menu,
      },
      {
        "id": 17,
        "title": "Sports Areas",
        "subtitle": "Indoor and outdoor sports facilities",
        "imageUrl": "https://picsum.photos/id/1039/600/900",
        "icon": Icons.sports,
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

  Future<List<CategoryItem>> fetchAllCategoriesPl() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<Map<String, dynamic>> responseData = [
      {
        "id": 0,
        "title": "Muzea",
        "subtitle": "Śląskie Muzeum i centra kultury",
        "imageUrl": "https://picsum.photos/id/1003/600/900",
        "icon": Icons.museum,
      },
      {
        "id": 1,
        "title": "Przystanki Smakowe",
        "subtitle": "Odkryj kuchnię śląską",
        "imageUrl": "https://picsum.photos/id/1080/600/900",
        "icon": Icons.restaurant,
      },
      {
        "id": 2,
        "title": "Wydarzenia i Sport",
        "subtitle": "Spodek Arena i aktywności sportowe",
        "imageUrl": "https://picsum.photos/id/1011/600/900",
        "icon": Icons.sports_soccer,
      },
      {
        "id": 3,
        "title": "Ikoniczne Punkty",
        "subtitle": "Spodek, Nikiszowiec i inne atrakcje",
        "imageUrl": "https://picsum.photos/id/1015/600/900",
        "icon": Icons.location_city,
      },
      {
        "id": 4,
        "title": "Kościoły",
        "subtitle": "Historyczne i nowoczesne miejsca kultu",
        "imageUrl": "https://picsum.photos/id/1016/600/900",
        "icon": Icons.church,
      },
      {
        "id": 5,
        "title": "Dziedzictwo Przemysłowe",
        "subtitle": "Dawne kopalnie, fabryki i muzea",
        "imageUrl": "https://picsum.photos/id/1019/600/900",
        "icon": Icons.factory,
      },
      {
        "id": 6,
        "title": "Hotele",
        "subtitle": "Komfortowe opcje zakwaterowania",
        "imageUrl": "https://picsum.photos/id/1020/600/900",
        "icon": Icons.hotel,
      },
      {
        "id": 7,
        "title": "Mosty i Place",
        "subtitle": "Historyczne mosty i place miejskie",
        "imageUrl": "https://picsum.photos/id/1024/600/900",
        "icon": Icons.fort,
      },
      {
        "id": 8,
        "title": "Teatr i Kino",
        "subtitle": "Sceny kulturalne i sale kinowe",
        "imageUrl": "https://picsum.photos/id/1025/600/900",
        "icon": Icons.movie,
      },
      {
        "id": 9,
        "title": "Tereny Górnicze",
        "subtitle": "Wycieczki po kopalniach i skanseny",
        "imageUrl": "https://picsum.photos/id/1026/600/900",
        "icon": Icons.architecture,
      },
      {
        "id": 10,
        "title": "Galerie Sztuki",
        "subtitle": "Wystawy i galerie sztuki nowoczesnej",
        "imageUrl": "https://picsum.photos/id/1027/600/900",
        "icon": Icons.brush,
      },
      {
        "id": 11,
        "title": "Rękodzieło Lokalnie",
        "subtitle": "Ceramika, tekstylia i ręcznie robione produkty",
        "imageUrl": "https://picsum.photos/id/1031/600/900",
        "icon": Icons.handyman,
      },
      {
        "id": 12,
        "title": "Parki i Ogrody",
        "subtitle": "Park Śląski i tereny zielone",
        "imageUrl": "https://picsum.photos/id/1033/600/900",
        "icon": Icons.park,
      },
      {
        "id": 13,
        "title": "Biblioteki",
        "subtitle": "Centra książki i kultury",
        "imageUrl": "https://picsum.photos/id/1035/600/900",
        "icon": Icons.book,
      },
      {
        "id": 14,
        "title": "Jak Dotrzeć",
        "subtitle": "Przewodnik transportowy po Katowicach",
        "imageUrl": "https://picsum.photos/id/1036/600/900",
        "icon": Icons.directions_bus,
      },
      {
        "id": 15,
        "title": "Transport Miejski",
        "subtitle": "Tramwaje, autobusy i ścieżki rowerowe",
        "imageUrl": "https://picsum.photos/id/1037/600/900",
        "icon": Icons.emoji_transportation,
      },
      {
        "id": 16,
        "title": "Smaki Katowic",
        "subtitle": "Lokalne restauracje i przepisy",
        "imageUrl": "https://picsum.photos/id/1038/600/900",
        "icon": Icons.restaurant_menu,
      },
      {
        "id": 17,
        "title": "Obiekty Sportowe",
        "subtitle": "Hale i obiekty sportowe na świeżym powietrzu",
        "imageUrl": "https://picsum.photos/id/1039/600/900",
        "icon": Icons.sports,
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
    await Future.delayed(const Duration(milliseconds: 500));

    final List<Map<String, dynamic>> responseData = [
      {
        "title": "Tarihi Mahalleler",
        "subtitle": "Nikiszowiec ve Giszowiec'te geçmişe yolculuk.",
        "imageUrl": "https://picsum.photos/id/1011/600/400",
        "icon": "account_balance",
        "distanceKm": 2.0,
        "durationMinutes": 30,
      },
      {
        "title": "Sanat ve Müze",
        "subtitle": "Silesian Museum ve modern sanat noktaları.",
        "imageUrl": "https://picsum.photos/id/1027/600/400",
        "icon": "museum",
        "distanceKm": 1.8,
        "durationMinutes": 25,
      },
      {
        "title": "Doğa ve Parklar",
        "subtitle": "Silesian Park ve Üç Gölet Vadisi'nde huzur.",
        "imageUrl": "https://picsum.photos/id/1043/600/400",
        "icon": "nature_people",
        "distanceKm": 3.5,
        "durationMinutes": 45,
      },
      {
        "title": "Spor ve Etkinlikler",
        "subtitle": "Spodek Arena ve şehir spor alanları.",
        "imageUrl": "https://picsum.photos/id/1052/600/400",
        "icon": "fitness_center",
        "distanceKm": 2.5,
        "durationMinutes": 35,
      },
      {
        "title": "Madencilik Mirası",
        "subtitle": "Kömür madeni turları ve maden müzeleri.",
        "imageUrl": "https://picsum.photos/id/1062/600/400",
        "icon": "explore",
        "distanceKm": 4.0,
        "durationMinutes": 50,
      },
    ];

    const uuid = Uuid();
    return responseData.map((data) {
      return RouteItem(
        id: uuid.v4(),
        title: data['title'],
        subtitle: data['subtitle'],
        imageUrl: data['imageUrl'],
        iconName: data['icon'],
        distanceKm: data['distanceKm'],
        duration: Duration(minutes: data['durationMinutes']),
        isUserAdded: false,
        stops: [],
      );
    }).toList();
  }

  Future<List<RouteItem>> fetchAllRoutesEn() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<Map<String, dynamic>> responseData = [
      {
        "title": "Historic Districts",
        "subtitle": "Travel back in time in Nikiszowiec and Giszowiec.",
        "imageUrl": "https://picsum.photos/id/1011/600/400",
        "icon": "account_balance",
        "distanceKm": 2.0,
        "durationMinutes": 30,
      },
      {
        "title": "Art & Museums",
        "subtitle": "Explore the Silesian Museum and modern art spots.",
        "imageUrl": "https://picsum.photos/id/1027/600/400",
        "icon": "museum",
        "distanceKm": 1.8,
        "durationMinutes": 25,
      },
      {
        "title": "Nature & Parks",
        "subtitle": "Peaceful walks in Silesian Park and Three Ponds Valley.",
        "imageUrl": "https://picsum.photos/id/1043/600/400",
        "icon": "nature_people",
        "distanceKm": 3.5,
        "durationMinutes": 45,
      },
      {
        "title": "Sports & Events",
        "subtitle": "Experience Spodek Arena and city sports facilities.",
        "imageUrl": "https://picsum.photos/id/1052/600/400",
        "icon": "fitness_center",
        "distanceKm": 2.5,
        "durationMinutes": 35,
      },
      {
        "title": "Mining Heritage",
        "subtitle": "Coal mine tours and mining museums.",
        "imageUrl": "https://picsum.photos/id/1062/600/400",
        "icon": "explore",
        "distanceKm": 4.0,
        "durationMinutes": 50,
      },
    ];

    const uuid = Uuid();
    return responseData.map((data) {
      return RouteItem(
        id: uuid.v4(),
        title: data['title'],
        subtitle: data['subtitle'],
        imageUrl: data['imageUrl'],
        iconName: data['icon'],
        distanceKm: data['distanceKm'],
        duration: Duration(minutes: data['durationMinutes']),
        isUserAdded: false,
        stops: [],
      );
    }).toList();
  }

  Future<List<RouteItem>> fetchAllRoutesPl() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<Map<String, dynamic>> responseData = [
      {
        "title": "Historyczne Dzielnice",
        "subtitle": "Podróż w czasie w Nikiszowiec i Giszowiec.",
        "imageUrl": "https://picsum.photos/id/1011/600/400",
        "icon": "account_balance",
        "distanceKm": 2.0,
        "durationMinutes": 30,
      },
      {
        "title": "Sztuka i Muzea",
        "subtitle": "Odkryj Śląskie Muzeum i nowoczesne miejsca sztuki.",
        "imageUrl": "https://picsum.photos/id/1027/600/400",
        "icon": "museum",
        "distanceKm": 1.8,
        "durationMinutes": 25,
      },
      {
        "title": "Przyroda i Parki",
        "subtitle": "Spokojne spacery w Parku Śląskim i Dolinie Trzech Stawów.",
        "imageUrl": "https://picsum.photos/id/1043/600/400",
        "icon": "nature_people",
        "distanceKm": 3.5,
        "durationMinutes": 45,
      },
      {
        "title": "Sport i Wydarzenia",
        "subtitle": "Doświadcz Spodek Areny i miejskich obiektów sportowych.",
        "imageUrl": "https://picsum.photos/id/1052/600/400",
        "icon": "fitness_center",
        "distanceKm": 2.5,
        "durationMinutes": 35,
      },
      {
        "title": "Dziedzictwo Górnictwa",
        "subtitle": "Wycieczki po kopalniach i muzeach górniczych.",
        "imageUrl": "https://picsum.photos/id/1062/600/400",
        "icon": "explore",
        "distanceKm": 4.0,
        "durationMinutes": 50,
      },
    ];

    const uuid = Uuid();
    return responseData.map((data) {
      return RouteItem(
        id: uuid.v4(),
        title: data['title'],
        subtitle: data['subtitle'],
        imageUrl: data['imageUrl'],
        iconName: data['icon'],
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

    final List<String> placesTr = [
      "Nikiszowiec Mahallesi",
      "Silesian Müzesi",
      "Spodek Arena",
      "Silezya Parkı",
      "Christ the King Katedrali",
      "Üç Gölet Vadisi",
      "NOSPR Binası",
      "Giszowiec Mahallesi",
      "Kościuszko Parkı",
      "Modern Sanat Galerisi",
    ];

    return List.generate(10, (index) {
      double latitude = 50.2649 + (random.nextDouble() * 0.04 - 0.02);
      double longitude = 19.0238 + (random.nextDouble() * 0.04 - 0.02);

      return CategoryContentItem(
        id: 'content_${category.title.toLowerCase()}_$index',
        title: placesTr[index],
        description: '${placesTr[index]} hakkında bilgi ve gezi önerileri.',
        imageUrl:
            'https://picsum.photos/seed/${category.title}_${index + 1}/600/1000',
        latitude: latitude,
        longitude: longitude,
      );
    });
  }

  Future<List<CategoryContentItem>> getContentsEn(CategoryItem category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final Random random = Random();

    final List<String> placesEn = [
      "Nikiszowiec District",
      "Silesian Museum",
      "Spodek Arena",
      "Silesian Park",
      "Christ the King Cathedral",
      "Valley of Three Ponds",
      "NOSPR Building",
      "Giszowiec District",
      "Kościuszko Park",
      "Modern Art Gallery",
    ];

    return List.generate(10, (index) {
      double latitude = 50.2649 + (random.nextDouble() * 0.04 - 0.02);
      double longitude = 19.0238 + (random.nextDouble() * 0.04 - 0.02);

      return CategoryContentItem(
        id: 'content_${category.title.toLowerCase()}_$index',
        title: placesEn[index],
        description: 'Information and travel tips for ${placesEn[index]}.',
        imageUrl:
            'https://picsum.photos/seed/${category.title}_${index + 1}/600/1000',
        latitude: latitude,
        longitude: longitude,
      );
    });
  }

  Future<List<CategoryContentItem>> getContentsPl(CategoryItem category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final Random random = Random();

    final List<String> placesPl = [
      "Dzielnica Nikiszowiec",
      "Muzeum Śląskie",
      "Arena Spodek",
      "Park Śląski",
      "Katedra Chrystusa Króla",
      "Dolina Trzech Stawów",
      "Budynek NOSPR",
      "Dzielnica Giszowiec",
      "Park Kościuszki",
      "Galeria Sztuki Nowoczesnej",
    ];

    return List.generate(10, (index) {
      double latitude = 50.2649 + (random.nextDouble() * 0.04 - 0.02);
      double longitude = 19.0238 + (random.nextDouble() * 0.04 - 0.02);

      return CategoryContentItem(
        id: 'content_${category.title.toLowerCase()}_$index',
        title: placesPl[index],
        description:
            'Informacje i wskazówki turystyczne dotyczące ${placesPl[index]}.',
        imageUrl:
            'https://picsum.photos/seed/${category.title}_${index + 1}/600/1000',
        latitude: latitude,
        longitude: longitude,
      );
    });
  }

  Future<List<CategoryContentItem>> getEventsTr() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      CategoryContentItem(
        id: 'content_filmler_0',
        title: 'Vizyondaki Filmler',
        description:
            'Katowice sinemalarında izleyebileceğiniz güncel filmleri keşfedin.',
        imageUrl: 'https://picsum.photos/seed/movie_theater/600/400',
        latitude: 0, // örnek koordinatlar
        longitude: 0,
      ),
      CategoryContentItem(
        id: 'content_tiyatrolar_1',
        title: 'Tiyatrolar',
        description:
            'Katowice’de kültürel etkinlikler ve sahne sanatları için eşsiz tiyatrolar.',
        imageUrl: 'https://picsum.photos/seed/theater_stage/600/400',
        latitude: 0,
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
        description: 'Discover the latest movies playing in Katowice cinemas.',
        imageUrl: 'https://picsum.photos/seed/movie_theater/600/400',
        latitude: 0,
        longitude: 0,
      ),
      CategoryContentItem(
        id: 'content_tiyatrolar_1',
        title: 'Theaters',
        description:
            'Unique theaters in Katowice for cultural events and performing arts.',
        imageUrl: 'https://picsum.photos/seed/theater_stage/600/400',
        latitude: 0,
        longitude: 0,
      ),
    ];
  }

  Future<List<CategoryContentItem>> getEventsPl() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      CategoryContentItem(
        id: 'content_filmler_0',
        title: 'Filmy w Kinach',
        description: 'Odkryj najnowsze filmy grane w kinach w Katowicach.',
        imageUrl: 'https://picsum.photos/seed/movie_theater/600/400',
        latitude: 0, // przykładowe współrzędne
        longitude: 0,
      ),
      CategoryContentItem(
        id: 'content_tiyatrolar_1',
        title: 'Teatry',
        description:
            'Unikalne teatry w Katowicach na wydarzenia kulturalne i sztuki sceniczne.',
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
        "title": "Spodek Arena",
        "subtitle": "Canlı Etkinlikler",
        "imageUrl": "https://picsum.photos/id/1036/800/500",
        "icon": Icons.sports_basketball,
        "id": 0
      },
      {
        "title": "Bu Ayın Festivalleri",
        "subtitle": "Kaçırma!",
        "imageUrl": "https://picsum.photos/id/169/800/500",
        "icon": Icons.event,
        "id": 1
      },
      {
        "title": "Parklar ve Doğa",
        "subtitle": "Yeşil Alanlar",
        "imageUrl": "https://picsum.photos/id/110/800/500",
        "icon": Icons.park,
        "id": 2
      },
      {
        "title": "Silezya Lezzetleri",
        "subtitle": "Yerel Tatlar",
        "imageUrl": "https://picsum.photos/id/292/800/500",
        "icon": Icons.restaurant,
        "id": 3
      },
      {
        "title": "Gezilecek Yerler",
        "subtitle": "Katowice'nin İncileri",
        "imageUrl": "https://picsum.photos/id/15/800/500",
        "icon": Icons.place,
        "id": 4
      },
      {
        "title": "Yapmadan Ayrılmayın",
        "subtitle": "Özel Deneyimler",
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
        "title": "Spodek Arena",
        "subtitle": "Live Events",
        "imageUrl": "https://picsum.photos/id/1036/800/500",
        "icon": Icons.sports_basketball,
        "id": 0
      },
      {
        "title": "This Month's Festivals",
        "subtitle": "Don't Miss It!",
        "imageUrl": "https://picsum.photos/id/169/800/500",
        "icon": Icons.event,
        "id": 1
      },
      {
        "title": "Parks & Nature",
        "subtitle": "Green Spaces",
        "imageUrl": "https://picsum.photos/id/110/800/500",
        "icon": Icons.park,
        "id": 2
      },
      {
        "title": "Silesian Cuisine",
        "subtitle": "Local Flavors",
        "imageUrl": "https://picsum.photos/id/292/800/500",
        "icon": Icons.restaurant,
        "id": 3
      },
      {
        "title": "Must-See Spots",
        "subtitle": "Katowice's Gems",
        "imageUrl": "https://picsum.photos/id/15/800/500",
        "icon": Icons.place,
        "id": 4
      },
      {
        "title": "Don't Leave Without",
        "subtitle": "Unique Experiences",
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

  Future<List<FeatureModel>> fetchFeaturesPl() async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // sztuczne opóźnienie

    final List<Map<String, dynamic>> _features = [
      {
        "title": "Arena Spodek",
        "subtitle": "Wydarzenia na żywo",
        "imageUrl": "https://picsum.photos/id/1036/800/500",
        "icon": Icons.sports_basketball,
        "id": 0
      },
      {
        "title": "Festiwale tego miesiąca",
        "subtitle": "Nie przegap!",
        "imageUrl": "https://picsum.photos/id/169/800/500",
        "icon": Icons.event,
        "id": 1
      },
      {
        "title": "Parki i przyroda",
        "subtitle": "Zielone przestrzenie",
        "imageUrl": "https://picsum.photos/id/110/800/500",
        "icon": Icons.park,
        "id": 2
      },
      {
        "title": "Kuchnia Śląska",
        "subtitle": "Lokalne smaki",
        "imageUrl": "https://picsum.photos/id/292/800/500",
        "icon": Icons.restaurant,
        "id": 3
      },
      {
        "title": "Miejsca, które trzeba zobaczyć",
        "subtitle": "Perły Katowic",
        "imageUrl": "https://picsum.photos/id/15/800/500",
        "icon": Icons.place,
        "id": 4
      },
      {
        "title": "Nie odchodź bez tego",
        "subtitle": "Wyjątkowe doświadczenia",
        "imageUrl": "https://picsum.photos/id/184/800/500",
        "icon": Icons.star,
        "id": 5
      },
      {
        "title": "Zakwaterowanie",
        "subtitle": "Gdzie się zatrzymać?",
        "imageUrl": "https://picsum.photos/id/238/800/500",
        "icon": Icons.hotel,
        "id": 6
      },
    ];

    return _features.map((item) => FeatureModel.fromJson(item)).toList();
  }

  Future<List<InfoCardModel>> fetchInfoCardsTr() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final rawData = [
      {"label": "Hava Durumu", "value": "21°C", "icon": "cloud"},
      {"label": "Kapasite", "value": "11.000 kişi", "icon": "groups"},
      {"label": "Etkinlik Sayısı", "value": "Yılda 300+", "icon": "event"},
      {"label": "Açılış Yılı", "value": "1971", "icon": "history_edu"},
      {
        "label": "Mevcut Etkinlik",
        "value": "Basketbol Maçı",
        "icon": "sports_basketball"
      },
      {"label": "İç Alan", "value": "29.473 m²", "icon": "aspect_ratio"},
    ];

    return rawData.map((e) => InfoCardModel.fromJson(e)).toList();
  }

  Future<List<InfoCardModel>> fetchInfoCardsEn() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final rawData = [
      {"label": "Weather", "value": "21°C", "icon": "cloud"},
      {"label": "Capacity", "value": "11,000 people", "icon": "groups"},
      {"label": "Events per Year", "value": "300+", "icon": "event"},
      {"label": "Opening Year", "value": "1971", "icon": "history_edu"},
      {
        "label": "Current Event",
        "value": "Basketball Match",
        "icon": "sports_basketball"
      },
      {"label": "Indoor Area", "value": "29,473 m²", "icon": "aspect_ratio"},
    ];

    return rawData.map((e) => InfoCardModel.fromJson(e)).toList();
  }

  Future<List<InfoCardModel>> fetchInfoCardsPl() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final rawData = [
      {"label": "Pogoda", "value": "21°C", "icon": "cloud"},
      {"label": "Pojemność", "value": "11 000 osób", "icon": "groups"},
      {"label": "Liczba wydarzeń", "value": "300+ rocznie", "icon": "event"},
      {"label": "Rok otwarcia", "value": "1971", "icon": "history_edu"},
      {
        "label": "Aktualne wydarzenie",
        "value": "Mecz koszykówki",
        "icon": "sports_basketball"
      },
      {
        "label": "Powierzchnia wewnętrzna",
        "value": "29 473 m²",
        "icon": "aspect_ratio"
      },
    ];

    return rawData.map((e) => InfoCardModel.fromJson(e)).toList();
  }

  Future<List<FacilityModel>> fetchFacilityItemsTr() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<Map<String, dynamic>> items = [
      {
        "label": "Basketbol Sahası",
        "icon": Icons.sports_basketball,
        "active": true,
        "id": 0
      },
      {
        "label": "Konser Alanı",
        "icon": Icons.music_note,
        "active": true,
        "id": 1
      },
      {"label": "Buz Pisti", "icon": Icons.ac_unit, "active": false, "id": 2},
      {
        "label": "Restoran & Kafeler",
        "icon": Icons.restaurant,
        "active": true,
        "id": 3
      },
      {
        "label": "Konferans Salonu",
        "icon": Icons.business_center,
        "active": true,
        "id": 4
      },
    ];

    return items.map((e) => FacilityModel.fromJson(e)).toList();
  }

  Future<List<FacilityModel>> fetchFacilityItemsEn() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<Map<String, dynamic>> items = [
      {
        "label": "Basketball Court",
        "icon": Icons.sports_basketball,
        "active": true,
        "id": 0
      },
      {
        "label": "Concert Hall",
        "icon": Icons.music_note,
        "active": true,
        "id": 1
      },
      {"label": "Ice Rink", "icon": Icons.ac_unit, "active": false, "id": 2},
      {
        "label": "Restaurants & Cafes",
        "icon": Icons.restaurant,
        "active": true,
        "id": 3
      },
      {
        "label": "Conference Hall",
        "icon": Icons.business_center,
        "active": true,
        "id": 4
      },
    ];

    return items.map((e) => FacilityModel.fromJson(e)).toList();
  }

  Future<List<FacilityModel>> fetchFacilityItemsPl() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<Map<String, dynamic>> items = [
      {
        "label": "Boisko do koszykówki",
        "icon": Icons.sports_basketball,
        "active": true,
        "id": 0
      },
      {
        "label": "Sala koncertowa",
        "icon": Icons.music_note,
        "active": true,
        "id": 1
      },
      {"label": "Lodowisko", "icon": Icons.ac_unit, "active": false, "id": 2},
      {
        "label": "Restauracje i kawiarnie",
        "icon": Icons.restaurant,
        "active": true,
        "id": 3
      },
      {
        "label": "Sala konferencyjna",
        "icon": Icons.business_center,
        "active": true,
        "id": 4
      },
    ];

    return items.map((e) => FacilityModel.fromJson(e)).toList();
  }

  Future<Map<String, List<PhotoModel>>> fetchGalleryPhotosTr() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final Map<String, List<Map<String, String>>> rawCategorizedImages = {
      "Tümü": [
        {
          "title": "Spodek Arena",
          "url": "https://picsum.photos/id/1015/600/900"
        },
        {
          "title": "Nikiszowiec",
          "url": "https://picsum.photos/id/1016/600/900"
        },
        {
          "title": "Silezya Müzesi",
          "url": "https://picsum.photos/id/1018/600/900"
        },
        {
          "title": "Kültür Merkezi",
          "url": "https://picsum.photos/id/1019/600/900"
        },
        {
          "title": "Katowice Manzarası",
          "url": "https://picsum.photos/id/1020/600/900"
        },
        {"title": "Parklar", "url": "https://picsum.photos/id/1021/600/900"},
        {
          "title": "Sanat ve Heykeller",
          "url": "https://picsum.photos/id/1022/600/900"
        },
        {
          "title": "Festival Alanı",
          "url": "https://picsum.photos/id/1023/600/900"
        },
        {
          "title": "Yerel Lezzetler",
          "url": "https://picsum.photos/id/1024/600/900"
        },
        {
          "title": "Şehir Sokakları",
          "url": "https://picsum.photos/id/1025/600/900"
        },
      ],
      "Doğa": [
        {"title": "Parklar", "url": "https://picsum.photos/id/1021/600/900"},
        {
          "title": "Katowice Manzarası",
          "url": "https://picsum.photos/id/1020/600/900"
        },
      ],
      "Mimari": [
        {
          "title": "Nikiszowiec",
          "url": "https://picsum.photos/id/1016/600/900"
        },
        {
          "title": "Silezya Müzesi",
          "url": "https://picsum.photos/id/1018/600/900"
        },
        {
          "title": "Kültür Merkezi",
          "url": "https://picsum.photos/id/1019/600/900"
        },
      ],
      "Kültür": [
        {
          "title": "Festival Alanı",
          "url": "https://picsum.photos/id/1023/600/900"
        },
      ],
      "Yemek": [
        {
          "title": "Yerel Lezzetler",
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
          "title": "Spodek Arena",
          "url": "https://picsum.photos/id/1015/600/900"
        },
        {
          "title": "Nikiszowiec",
          "url": "https://picsum.photos/id/1016/600/900"
        },
        {
          "title": "Silesian Museum",
          "url": "https://picsum.photos/id/1018/600/900"
        },
        {
          "title": "Culture Center",
          "url": "https://picsum.photos/id/1019/600/900"
        },
        {
          "title": "Katowice View",
          "url": "https://picsum.photos/id/1020/600/900"
        },
        {"title": "Parks", "url": "https://picsum.photos/id/1021/600/900"},
        {
          "title": "Art & Sculptures",
          "url": "https://picsum.photos/id/1022/600/900"
        },
        {
          "title": "Festival Area",
          "url": "https://picsum.photos/id/1023/600/900"
        },
        {
          "title": "Local Flavors",
          "url": "https://picsum.photos/id/1024/600/900"
        },
        {
          "title": "City Streets",
          "url": "https://picsum.photos/id/1025/600/900"
        },
      ],
      "Nature": [
        {"title": "Parks", "url": "https://picsum.photos/id/1021/600/900"},
        {
          "title": "Katowice View",
          "url": "https://picsum.photos/id/1020/600/900"
        },
      ],
      "Architecture": [
        {
          "title": "Nikiszowiec",
          "url": "https://picsum.photos/id/1016/600/900"
        },
        {
          "title": "Silesian Museum",
          "url": "https://picsum.photos/id/1018/600/900"
        },
        {
          "title": "Culture Center",
          "url": "https://picsum.photos/id/1019/600/900"
        },
      ],
      "Culture": [
        {
          "title": "Festival Area",
          "url": "https://picsum.photos/id/1023/600/900"
        },
      ],
      "Cuisine": [
        {
          "title": "Local Flavors",
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

  Future<Map<String, List<PhotoModel>>> fetchGalleryPhotosPl() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final Map<String, List<Map<String, String>>> rawCategorizedImages = {
      "Wszystko": [
        {
          "title": "Spodek Arena",
          "url": "https://picsum.photos/id/1015/600/900"
        },
        {
          "title": "Nikiszowiec",
          "url": "https://picsum.photos/id/1016/600/900"
        },
        {
          "title": "Muzeum Śląskie",
          "url": "https://picsum.photos/id/1018/600/900"
        },
        {
          "title": "Centrum Kultury",
          "url": "https://picsum.photos/id/1019/600/900"
        },
        {
          "title": "Widok Katowic",
          "url": "https://picsum.photos/id/1020/600/900"
        },
        {"title": "Parki", "url": "https://picsum.photos/id/1021/600/900"},
        {
          "title": "Sztuka i Rzeźby",
          "url": "https://picsum.photos/id/1022/600/900"
        },
        {
          "title": "Obszar Festiwalowy",
          "url": "https://picsum.photos/id/1023/600/900"
        },
        {
          "title": "Lokalne Smaki",
          "url": "https://picsum.photos/id/1024/600/900"
        },
        {
          "title": "Ulice Miasta",
          "url": "https://picsum.photos/id/1025/600/900"
        },
      ],
      "Przyroda": [
        {"title": "Parki", "url": "https://picsum.photos/id/1021/600/900"},
        {
          "title": "Widok Katowic",
          "url": "https://picsum.photos/id/1020/600/900"
        },
      ],
      "Architektura": [
        {
          "title": "Nikiszowiec",
          "url": "https://picsum.photos/id/1016/600/900"
        },
        {
          "title": "Muzeum Śląskie",
          "url": "https://picsum.photos/id/1018/600/900"
        },
        {
          "title": "Centrum Kultury",
          "url": "https://picsum.photos/id/1019/600/900"
        },
      ],
      "Kultura": [
        {
          "title": "Obszar Festiwalowy",
          "url": "https://picsum.photos/id/1023/600/900"
        },
      ],
      "Kuchnia": [
        {
          "title": "Lokalne Smaki",
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
        'icon': "terrain",
        'thumbnail': thumbnailUrl,
      },
      {
        'name': 'Ergan Kayak Merkezi - 1. Etap',
        'url': 'https://tv-trt1.medya.trt.com.tr/master_480.m3u8',
        'description':
            '1. etap kayak pistinden canlı yayın. Pist giriş noktası ve çevresindeki kayak faaliyetlerini buradan takip edin.',
        'status': 'Çevrimiçi',
        'icon': "landscape",
        'thumbnail': thumbnailUrl,
      },
      {
        'name': 'Ergan Kayak Merkezi - 2. Etap',
        'url': 'https://tv-trt1.medya.trt.com.tr/master_480.m3u8',
        'description':
            '2. etap zirve bölgesinden panoramik canlı yayın. Geniş manzara, kayak rotaları ve hava durumu takibi için birebir.',
        'status': 'Çevrimiçi',
        'icon': "downhill_skiing",
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
        'icon': "terrain",
        'thumbnail': thumbnailUrl,
      },
      {
        'name': 'Ergan Ski Center - Stage 1',
        'url': 'https://tv-trt1.medya.trt.com.tr/master_480.m3u8',
        'description':
            'Live broadcast from the first ski slope. Watch ski activities around the entrance point of the track.',
        'status': 'Online',
        'icon': "landscape",
        'thumbnail': thumbnailUrl,
      },
      {
        'name': 'Ergan Ski Center - Stage 2',
        'url': 'https://tv-trt1.medya.trt.com.tr/master_480.m3u8',
        'description':
            'Panoramic live stream from the second peak area. Perfect for viewing ski routes and weather conditions.',
        'status': 'Online',
        'icon': "downhill_skiing",
        'thumbnail': thumbnailUrl,
      },
    ];

    return fakeData.map((json) => CameraModel.fromJson(json)).toList();
  }
}
*/
