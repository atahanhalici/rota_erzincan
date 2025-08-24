import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:rota_erzincan/models/AssemblyPointModel.dart';
import 'package:rota_erzincan/models/MovieItem.dart';
import 'package:rota_erzincan/models/TheaterPlayItem.dart';
import 'package:rota_erzincan/utilities/error_handler.dart';
import 'package:uuid/uuid.dart';

import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/models/CategoryItem.dart';
import 'package:rota_erzincan/models/CategoryModel.dart';
import 'package:rota_erzincan/models/FacilityModel.dart';
import 'package:rota_erzincan/models/FeatureModel.dart';
import 'package:rota_erzincan/models/InfoCardModel.dart';
import 'package:rota_erzincan/models/PhotoModel.dart';
import 'package:rota_erzincan/models/RouteItem.dart';

/// API özel hata tipi
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? body;

  ApiException(this.message, {this.statusCode, this.body});

  @override
  String toString() =>
      "ApiException: $message (status: $statusCode, body: $body)";
}

class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.27.9:4000/api',
  );

  final _uuid = const Uuid();

  Uri _u(String path) => Uri.parse('$baseUrl/$path');

  static IconData iconFromName(String? name) {
    switch (name) {
      case 'museum':
        return Icons.museum;
      case 'restaurant':
        return Icons.restaurant;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'location_city':
        return Icons.location_city;
      case 'church':
        return Icons.church;
      case 'factory':
        return Icons.factory;
      case 'hotel':
        return Icons.hotel;
      case 'fort':
        return Icons.fort;
      case 'movie':
        return Icons.movie;
      case 'architecture':
        return Icons.architecture; // ⚠️ yoksa -> Icons.account_balance
      case 'brush':
        return Icons.brush;
      case 'handyman':
        return Icons.handyman;
      case 'park':
        return Icons.park;
      case 'book':
        return Icons.book;
      case 'directions_bus':
        return Icons.directions_bus;
      case 'emoji_transportation':
        return Icons.emoji_transportation;
      case 'restaurant_menu':
        return Icons.restaurant_menu;
      case 'sports':
        return Icons.sports;
      case 'cloud':
        return Icons.cloud;
      case 'groups':
        return Icons.groups;
      case 'event':
        return Icons.event;
      case 'history_edu':
        return Icons.history_edu;
      case 'sports_basketball':
        return Icons.sports_basketball;
      case 'aspect_ratio':
        return Icons.aspect_ratio;
      case 'music_note':
        return Icons.music_note;
      case 'ac_unit':
        return Icons.ac_unit;
      case 'business_center':
        return Icons.business_center;
      default:
        return Icons.help_outline; // fallback
    }
  }

  Future<http.Response?> _safeGet(String path) async {
    try {
      final response =
          await http.get(_u(path)).timeout(const Duration(seconds: 10));
      return response;
    } on SocketException {
      ErrorHandler.handle("İnternet bağlantısı yok.");
    } on HttpException {
      ErrorHandler.handle("Sunucuya ulaşılamadı.");
    } on FormatException {
      ErrorHandler.handle("Geçersiz yanıt formatı.");
    } on TimeoutException {
      ErrorHandler.handle("Sunucudan yanıt alınamadı (timeout).");
    } catch (e) {
      ErrorHandler.handle("Bilinmeyen hata: $e");
    }
    return null; // 👈 hata varsa null dön
  }

  Future<http.Response?> _safePost(
      String path, Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(
            _u(path),
            headers: {HttpHeaders.contentTypeHeader: "application/json"},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));
      return response;
    } on SocketException {
      ErrorHandler.handle("İnternet bağlantısı yok.");
    } on HttpException {
      ErrorHandler.handle("Sunucuya ulaşılamadı.");
    } on FormatException {
      ErrorHandler.handle("Geçersiz yanıt formatı.");
    } on TimeoutException {
      ErrorHandler.handle("Sunucudan yanıt alınamadı (timeout).");
    } catch (e) {
      ErrorHandler.handle("Bilinmeyen hata: $e");
    }
    return null;
  }

  /// StatusCode kontrolü + JSON decode
  T _require200<T>(http.Response r, T Function(dynamic) mapJson) {
    if (r.statusCode == 200) {
      try {
        final decoded = jsonDecode(utf8.decode(r.bodyBytes));
        return mapJson(decoded);
      } catch (e) {
        throw ApiException("JSON parse hatası: $e", statusCode: r.statusCode);
      }
    }
    throw ApiException("API error", statusCode: r.statusCode, body: r.body);
  }

  // ===================== CATEGORIES =====================
  Future<List<CategoryModel>> fetchCategoriesTr() async {
    final r = await _safeGet('category_models_tr');
    if (r == null) return [];
    return _require200(
        r,
        (data) => (data as List)
            .map((e) => CategoryModel(
                title: e['title'] ?? '', imageUrl: e['imageUrl'] ?? ''))
            .toList());
  }

  Future<List<CategoryModel>> fetchCategoriesEn() async {
    final r = await _safeGet('category_models_en');
    if (r == null) return [];
    return _require200(
        r,
        (data) => (data as List)
            .map((e) => CategoryModel(
                title: e['title'] ?? '', imageUrl: e['imageUrl'] ?? ''))
            .toList());
  }

  Future<List<CategoryModel>> fetchCategoriesPl() async {
    final r = await _safeGet('category_models_pl');
    if (r == null) return [];
    return _require200(
        r,
        (data) => (data as List)
            .map((e) => CategoryModel(
                title: e['title'] ?? '', imageUrl: e['imageUrl'] ?? ''))
            .toList());
  }

  // ===================== CATEGORY ITEMS =====================
  Future<List<CategoryItem>> fetchAllCategoriesTr() async {
    final r = await _safeGet('category_items_tr');
    if (r == null) return [];
    return _require200(
      r,
      (data) => (data as List)
          .map((e) => CategoryItem(
                id: e['id'],
                title: e['title'] ?? '',
                subtitle: e['subtitle'] ?? '',
                imageUrl: e['imageUrl'] ?? '',
                iconName: e['icon']?.toString() ?? '', // 👈 sadece string
              ))
          .toList(),
    );
  }

  Future<List<CategoryItem>> fetchAllCategoriesEn() async {
    final r = await _safeGet('category_items_en');
    if (r == null) return [];
    return _require200(
      r,
      (data) => (data as List)
          .map((e) => CategoryItem(
                id: e['id'],
                title: e['title'] ?? '',
                subtitle: e['subtitle'] ?? '',
                imageUrl: e['imageUrl'] ?? '',
                iconName: e['icon']?.toString() ?? '',
              ))
          .toList(),
    );
  }

  Future<List<CategoryItem>> fetchAllCategoriesPl() async {
    final r = await _safeGet('category_items_pl');
    if (r == null) return [];
    return _require200(
      r,
      (data) => (data as List)
          .map((e) => CategoryItem(
                id: e['id'],
                title: e['title'] ?? '',
                subtitle: e['subtitle'] ?? '',
                imageUrl: e['imageUrl'] ?? '',
                iconName: e['icon']?.toString() ?? '',
              ))
          .toList(),
    );
  }

  // ===================== ROUTES =====================
  Future<List<RouteItem>> fetchAllRoutesTr() async {
    final r = await _safeGet('routes_tr');
    if (r == null) return [];
    return _require200(
        r,
        (data) => (data as List)
            .map((e) => RouteItem(
                  id: _uuid.v4(),
                  title: e['title'] ?? '',
                  subtitle: e['subtitle'] ?? '',
                  imageUrl: e['imageUrl'] ?? '',
                  iconName: e['icon'],
                  distanceKm: (e['distanceKm'] ?? 0).toDouble(),
                  duration:
                      Duration(minutes: (e['durationMinutes'] ?? 0).toInt()),
                  isUserAdded: false,
                  stops: [],
                ))
            .toList());
  }

  Future<List<RouteItem>> fetchAllRoutesEn() async {
    final r = await _safeGet('routes_en');
    if (r == null) return [];
    return _require200(
        r,
        (data) => (data as List)
            .map((e) => RouteItem(
                  id: _uuid.v4(),
                  title: e['title'] ?? '',
                  subtitle: e['subtitle'] ?? '',
                  imageUrl: e['imageUrl'] ?? '',
                  iconName: e['icon'],
                  distanceKm: (e['distanceKm'] ?? 0).toDouble(),
                  duration:
                      Duration(minutes: (e['durationMinutes'] ?? 0).toInt()),
                  isUserAdded: false,
                  stops: [],
                ))
            .toList());
  }

  Future<List<RouteItem>> fetchAllRoutesPl() async {
    final r = await _safeGet('routes_pl');
    if (r == null) return [];
    return _require200(
        r,
        (data) => (data as List)
            .map((e) => RouteItem(
                  id: _uuid.v4(),
                  title: e['title'] ?? '',
                  subtitle: e['subtitle'] ?? '',
                  imageUrl: e['imageUrl'] ?? '',
                  iconName: e['icon'],
                  distanceKm: (e['distanceKm'] ?? 0).toDouble(),
                  duration:
                      Duration(minutes: (e['durationMinutes'] ?? 0).toInt()),
                  isUserAdded: false,
                  stops: [],
                ))
            .toList());
  }

  // ===================== CATEGORY CONTENT (PLACES) =====================
  Future<List<CategoryContentItem>> getContentsTr(CategoryItem category) async {
    // Eğer category.id varsa query parametre olarak ekle
    final query = category.id != null ? '?category=${category.id}' : '';
    final r = await _safeGet('places_tr$query');

    if (r == null) return [];

    return _require200(
      r,
      (data) => (data as List)
          .map((e) => CategoryContentItem(
                id: e['id']?.toString() ?? _uuid.v4(),
                title: e['title'] ?? '',
                description: e['description'] ?? '',
                imageUrl: e['imageUrl'] ?? '',
                latitude: (e['latitude'] ?? 0).toDouble(),
                longitude: (e['longitude'] ?? 0).toDouble(),
                category: e['category']?.toString(),
                extraImages: e['extraImages'] != null
                    ? List<String>.from(e['extraImages'])
                    : null,
                hours: e['hours'] != null
                    ? Map<String, String>.from(e['hours'])
                    : null,
                shortAddress: e['shortAddress'],
                rating: e['rating'] != null
                    ? (e['rating'] as num).toDouble()
                    : null,
              ))
          .toList(),
    );
  }

  Future<List<CategoryContentItem>> getContentsEn(CategoryItem category) async {
    final r = await _safeGet('places_en');
    if (r == null) return [];
    return _require200(
        r,
        (data) => (data as List)
            .map((e) => CategoryContentItem(
                  id: e['id']?.toString() ?? _uuid.v4(),
                  title: e['title'] ?? '',
                  description: e['description'] ?? '',
                  imageUrl: e['imageUrl'] ?? '',
                  latitude: (e['latitude'] ?? 0).toDouble(),
                  longitude: (e['longitude'] ?? 0).toDouble(),
                ))
            .toList());
  }

  Future<List<CategoryContentItem>> getContentsPl(CategoryItem category) async {
    final r = await _safeGet('places_pl');
    if (r == null) return [];
    return _require200(
        r,
        (data) => (data as List)
            .map((e) => CategoryContentItem(
                  id: e['id']?.toString() ?? _uuid.v4(),
                  title: e['title'] ?? '',
                  description: e['description'] ?? '',
                  imageUrl: e['imageUrl'] ?? '',
                  latitude: (e['latitude'] ?? 0).toDouble(),
                  longitude: (e['longitude'] ?? 0).toDouble(),
                ))
            .toList());
  }

  // ===================== EVENTS =====================
  Future<List<CategoryContentItem>> getEventsTr() async {
    final r = await _safeGet('events_tr');
    if (r == null) return [];
    return _require200(
        r,
        (data) => (data as List)
            .map((e) => CategoryContentItem(
                  id: _uuid.v4(),
                  title: e['title'] ?? '',
                  description: e['description'] ?? '',
                  imageUrl: e['imageUrl'] ?? '',
                  latitude: (e['latitude'] ?? 0).toDouble(),
                  longitude: (e['longitude'] ?? 0).toDouble(),
                ))
            .toList());
  }

  Future<List<CategoryContentItem>> getEventsEn() async {
    final r = await _safeGet('events_en');
    if (r == null) return [];
    return _require200(
        r,
        (data) => (data as List)
            .map((e) => CategoryContentItem(
                  id: _uuid.v4(),
                  title: e['title'] ?? '',
                  description: e['description'] ?? '',
                  imageUrl: e['imageUrl'] ?? '',
                  latitude: (e['latitude'] ?? 0).toDouble(),
                  longitude: (e['longitude'] ?? 0).toDouble(),
                ))
            .toList());
  }

  Future<List<CategoryContentItem>> getEventsPl() async {
    final r = await _safeGet('events_pl');
    if (r == null) return [];
    return _require200(
        r,
        (data) => (data as List)
            .map((e) => CategoryContentItem(
                  id: _uuid.v4(),
                  title: e['title'] ?? '',
                  description: e['description'] ?? '',
                  imageUrl: e['imageUrl'] ?? '',
                  latitude: (e['latitude'] ?? 0).toDouble(),
                  longitude: (e['longitude'] ?? 0).toDouble(),
                ))
            .toList());
  }

  // ===================== FEATURES =====================
  Future<List<FeatureModel>> fetchFeaturesTr() async {
    final r = await _safeGet('features_tr');
    if (r == null) return [];
    return _require200(r,
        (data) => (data as List).map((e) => FeatureModel.fromJson(e)).toList());
  }

  Future<List<FeatureModel>> fetchFeaturesEn() async {
    final r = await _safeGet('features_en');
    if (r == null) return [];
    return _require200(r,
        (data) => (data as List).map((e) => FeatureModel.fromJson(e)).toList());
  }

  Future<List<FeatureModel>> fetchFeaturesPl() async {
    final r = await _safeGet('features_pl');
    if (r == null) return [];
    return _require200(r,
        (data) => (data as List).map((e) => FeatureModel.fromJson(e)).toList());
  }

  // ===================== INFO CARDS =====================
  Future<List<InfoCardModel>> fetchInfoCardsTr() async {
    final r = await _safeGet('info_cards_tr');
    if (r == null) return [];
    return _require200(
        r,
        (data) =>
            (data as List).map((e) => InfoCardModel.fromJson(e)).toList());
  }

  Future<List<InfoCardModel>> fetchInfoCardsEn() async {
    final r = await _safeGet('info_cards_en');
    if (r == null) return [];
    return _require200(
        r,
        (data) =>
            (data as List).map((e) => InfoCardModel.fromJson(e)).toList());
  }

  Future<List<InfoCardModel>> fetchInfoCardsPl() async {
    final r = await _safeGet('info_cards_pl');
    if (r == null) return [];
    return _require200(
        r,
        (data) =>
            (data as List).map((e) => InfoCardModel.fromJson(e)).toList());
  }

  // ===================== FACILITIES =====================
  Future<List<FacilityModel>> fetchFacilityItemsTr() async {
    final r = await _safeGet('facilities_tr');
    if (r == null) return [];
    return _require200(
        r,
        (data) =>
            (data as List).map((e) => FacilityModel.fromJson(e)).toList());
  }

  Future<List<FacilityModel>> fetchFacilityItemsEn() async {
    final r = await _safeGet('facilities_en');
    if (r == null) return [];
    return _require200(
        r,
        (data) =>
            (data as List).map((e) => FacilityModel.fromJson(e)).toList());
  }

  Future<List<FacilityModel>> fetchFacilityItemsPl() async {
    final r = await _safeGet('facilities_pl');
    if (r == null) return [];
    return _require200(
        r,
        (data) =>
            (data as List).map((e) => FacilityModel.fromJson(e)).toList());
  }

  // ===================== GALLERY =====================
  Future<Map<String, List<PhotoModel>>> fetchGalleryPhotosTr() async {
    final r = await _safeGet('gallery_photos_tr');
    if (r == null) return {};
    return _require200(r, (data) {
      if (data is List && data.isNotEmpty) {
        final categories =
            data.first['categories'] as Map<String, dynamic>? ?? {};
        return categories.map((k, v) => MapEntry(
            k, (v as List).map((e) => PhotoModel.fromJson(e)).toList()));
      }
      return <String, List<PhotoModel>>{};
    });
  }

  Future<Map<String, List<PhotoModel>>> fetchGalleryPhotosEn() async {
    final r = await _safeGet('gallery_photos_en');
    if (r == null) return {};
    return _require200(r, (data) {
      if (data is List && data.isNotEmpty) {
        final categories =
            data.first['categories'] as Map<String, dynamic>? ?? {};
        return categories.map((k, v) => MapEntry(
            k, (v as List).map((e) => PhotoModel.fromJson(e)).toList()));
      }
      return <String, List<PhotoModel>>{};
    });
  }

  Future<Map<String, List<PhotoModel>>> fetchGalleryPhotosPl() async {
    final r = await _safeGet('gallery_photos_pl');
    if (r == null) return {};
    return _require200(r, (data) {
      if (data is List && data.isNotEmpty) {
        final categories =
            data.first['categories'] as Map<String, dynamic>? ?? {};
        return categories.map((k, v) => MapEntry(
            k, (v as List).map((e) => PhotoModel.fromJson(e)).toList()));
      }
      return <String, List<PhotoModel>>{};
    });
  }

  Future<Map?> fetchVersion() async {
    final r = await _safeGet('app_versions');
    if (r == null) return {};
    return _require200(
      r,
      (data) {
        if (data is List && data.isNotEmpty) {
          final first = data.first; // ilk elemanı al
          return {
            "android": first['androidVersion']?.toString(),
            "ios": first['iosVersion']?.toString(),
          };
        }
        throw ApiException("Beklenmeyen JSON formatı",
            statusCode: r.statusCode);
      },
    );
  }

  Future<List<dynamic>> getShowsTr() async {
    final r = await _safeGet('shows_tr');
    if (r == null) return [];
    return _require200(
      r,
      (data) => (data as List).map((e) {
        if (e['type'] == 'movie') {
          return MovieItem(
            title: e['title'] ?? '',
            imageUrl: e['imageUrl'] ?? '',
            cinema: e['cinema'] ?? '',
            sessions: (e['sessions'] as List?)?.cast<String>() ?? [],
          );
        } else {
          return TheaterPlayItem(
            title: e['title'] ?? '',
            imageUrl: e['imageUrl'] ?? '',
            venue: e['venue'] ?? '',
            date: e['date'] ?? '',
          );
        }
      }).toList(),
    );
  }

  Future<List<dynamic>> getShowsEn() async {
    final r = await _safeGet('shows_en');
    if (r == null) return [];
    return _require200(
      r,
      (data) => (data as List).map((e) {
        if (e['type'] == 'movie') {
          return MovieItem(
            title: e['title'] ?? '',
            imageUrl: e['imageUrl'] ?? '',
            cinema: e['cinema'] ?? '',
            sessions: (e['sessions'] as List?)?.cast<String>() ?? [],
          );
        } else {
          return TheaterPlayItem(
            title: e['title'] ?? '',
            imageUrl: e['imageUrl'] ?? '',
            venue: e['venue'] ?? '',
            date: e['date'] ?? '',
          );
        }
      }).toList(),
    );
  }

  Future<List<dynamic>> getShowsPl() async {
    final r = await _safeGet('shows_pl');
    if (r == null) return [];
    return _require200(
      r,
      (data) => (data as List).map((e) {
        if (e['type'] == 'movie') {
          return MovieItem(
            title: e['title'] ?? '',
            imageUrl: e['imageUrl'] ?? '',
            cinema: e['cinema'] ?? '',
            sessions: (e['sessions'] as List?)?.cast<String>() ?? [],
          );
        } else {
          return TheaterPlayItem(
            title: e['title'] ?? '',
            imageUrl: e['imageUrl'] ?? '',
            venue: e['venue'] ?? '',
            date: e['date'] ?? '',
          );
        }
      }).toList(),
    );
  }

  /// ============== FEEDBACK ==============
  Future<Map<String, dynamic>> submitFeedback({
    required String senderName,
    required String senderEmail,
    required String message,
  }) async {
    final r = await _safePost('feedback/submit', {
      "senderName": senderName,
      "senderEmail": senderEmail,
      "message": message,
    });

    if (r == null) {
      return {"success": false, "error": "İstek başarısız oldu"};
    }

    if (r.statusCode == 201 || r.statusCode == 200) {
      try {
        return jsonDecode(utf8.decode(r.bodyBytes))
            as Map<String, dynamic>; // backend'den success JSON
      } catch (e) {
        return {"success": false, "error": "JSON parse hatası: $e"};
      }
    }

    // Diğer durumlar hata
    throw ApiException(
      "Feedback gönderilemedi",
      statusCode: r.statusCode,
      body: r.body,
    );
  }

  // ===================== ASSEMBLY POINTS =====================
  Future<List<AssemblyPointModel>> fetchAssemblyPointsTr() async {
    final r = await _safeGet('assembly_points_tr');
    if (r == null) return [];
    return _require200(
      r,
      (data) =>
          (data as List).map((e) => AssemblyPointModel.fromJson(e)).toList(),
    );
  }

  Future<List<AssemblyPointModel>> fetchAssemblyPointsEn() async {
    final r = await _safeGet('assembly_points_en');
    if (r == null) return [];
    return _require200(
      r,
      (data) =>
          (data as List).map((e) => AssemblyPointModel.fromJson(e)).toList(),
    );
  }

  Future<List<AssemblyPointModel>> fetchAssemblyPointsPl() async {
    final r = await _safeGet('assembly_points_pl');
    if (r == null) return [];
    return _require200(
      r,
      (data) =>
          (data as List).map((e) => AssemblyPointModel.fromJson(e)).toList(),
    );
  }
}
