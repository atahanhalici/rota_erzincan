import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/FancyMenuLogoItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';

class SearchPageViewModel extends ChangeNotifier with BaseViewModel {
  final List<String> _recentSearches = [];
  List<String> get recentSearches => _recentSearches;
  final List<String> keys = [
    'popularSearchTerm_1',
    'popularSearchTerm_2',
    'popularSearchTerm_3',
    'popularSearchTerm_4',
    'popularSearchTerm_5',
    'popularSearchTerm_6',
  ];

  List<CategoryContentItem> get allItems {
    final lang =
        EasyLocalization.of(navigationService.navigatorKey.currentContext!)!
            .locale
            .languageCode;

    final List<CategoryContentItem> trItems = [
      CategoryContentItem(
        id: '1',
        title: 'Spodek Arena',
        description:
            'Katowice’nin simgesi, konser ve etkinlikler için ünlü arena.',
        imageUrl: 'https://picsum.photos/id/1011/600/400',
        latitude: 50.2599,
        longitude: 19.0216,
      ),
      CategoryContentItem(
        id: '2',
        title: 'Nikiszowiec',
        description:
            'Tarihi işçi yerleşimi, geleneksel mimarisi ve kültürel etkinlikleriyle ünlü.',
        imageUrl: 'https://picsum.photos/id/1025/600/400',
        latitude: 50.2475,
        longitude: 19.0263,
      ),
      CategoryContentItem(
        id: '3',
        title: 'Silesia City Center',
        description:
            'Alışveriş, eğlence ve restoranların bulunduğu büyük bir alışveriş merkezi.',
        imageUrl: 'https://picsum.photos/id/1043/600/400',
        latitude: 50.2570,
        longitude: 19.0250,
      ),
      CategoryContentItem(
        id: '4',
        title: 'Katowice Botanik Bahçesi',
        description:
            'Doğa yürüyüşleri ve bitki çeşitleri ile dolu sakin bir alan.',
        imageUrl: 'https://picsum.photos/id/1062/600/400',
        latitude: 50.2605,
        longitude: 19.0150,
      ),
    ];

    final List<CategoryContentItem> enItems = [
      CategoryContentItem(
        id: '1',
        title: 'Spodek Arena',
        description:
            'The iconic arena of Katowice, famous for concerts and events.',
        imageUrl: 'https://picsum.photos/id/1011/600/400',
        latitude: 50.2599,
        longitude: 19.0216,
      ),
      CategoryContentItem(
        id: '2',
        title: 'Nikiszowiec',
        description:
            'Historic worker settlement known for traditional architecture and cultural events.',
        imageUrl: 'https://picsum.photos/id/1025/600/400',
        latitude: 50.2475,
        longitude: 19.0263,
      ),
      CategoryContentItem(
        id: '3',
        title: 'Silesia City Center',
        description:
            'A large shopping center with shops, entertainment, and restaurants.',
        imageUrl: 'https://picsum.photos/id/1043/600/400',
        latitude: 50.2570,
        longitude: 19.0250,
      ),
      CategoryContentItem(
        id: '4',
        title: 'Katowice Botanical Garden',
        description:
            'A peaceful area filled with walking paths and plant varieties.',
        imageUrl: 'https://picsum.photos/id/1062/600/400',
        latitude: 50.2605,
        longitude: 19.0150,
      ),
    ];

    return lang == 'tr' ? trItems : enItems;
  }

  Future<void> loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? saved = prefs.getStringList('recentSearches');
    if (saved != null) {
      _recentSearches
        ..clear()
        ..addAll(saved);
      notifyListeners();
    }
  }

  Future<void> saveRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recentSearches', _recentSearches);
  }

  void addToRecentSearches(String query) {
    query = query.trim();
    if (query.isEmpty) return;

    _recentSearches.remove(query);
    _recentSearches.insert(0, query);
    saveRecentSearches();
    notifyListeners();
  }

  void removeFromRecentSearches(String query) {
    _recentSearches.remove(query);
    saveRecentSearches();
    notifyListeners();
  }

  void clearRecentSearches() async {
    _recentSearches.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recentSearches');
    notifyListeners();
  }

  Future<void> navigateToPage(CategoryContentItem item) async {
    navigationService.navigateToDetailsPage(item);
  }

  String? _mapErrorMessage;
  String? get mapErrorMessage => _mapErrorMessage;

  void clearMapError() {
    _mapErrorMessage = null;
    notifyListeners();
  }

  Future<void> openMapApp(BuildContext context, ThemeProvider themeProvider,
      double targetLatitude, double targetLongitude, String targetTitle) async {
    _mapErrorMessage = null;
    notifyListeners();

    try {
      final availableMaps = await MapLauncher.installedMaps;

      if (availableMaps.isEmpty) {
        _mapErrorMessage = 'mapErrorNoAppInstalled'.tr();
        notifyListeners();
        return;
      }

      if (availableMaps.length == 1) {
        // Tek harita varsa direkt aç
        await MapLauncher.showMarker(
          mapType: availableMaps.first.mapType,
          coords: Coords(targetLatitude, targetLongitude),
          title: targetTitle,
        );
      } else {
        // Birden fazla varsa seçim menüsü göster
        showModalBottomSheet(
          context: context,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'mapAppSelectionTitle'.tr(),
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        themeProvider.cardColor,
                        themeProvider.infoItemColor,
                        themeProvider.cardColor,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ...availableMaps.map((map) {
                  return FancyMenuLogoItem(
                    icon: map.icon,
                    label: map.mapName,
                    color: themeProvider.buttonColor,
                    onTap: () {
                      Navigator.pop(context);
                      MapLauncher.showMarker(
                        mapType: map.mapType,
                        coords: Coords(targetLatitude, targetLongitude),
                        title: targetTitle,
                      );
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  mapErrorMessage!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        ),
      );

      notifyListeners();
    }
  }

  // Her bir galeri öğesi için animasyon oluşturucu yardımcı metodu
  Animation<double> createGalleryItemAnimation(
      int index, AnimationController controller) {
    final delay = 0.5 + (index * 0.1);
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          delay < 1.0 ? delay : 0.9,
          (delay + 0.2) < 1.0 ? (delay + 0.2) : 1.0,
          curve: Curves.easeOutQuart,
        ),
      ),
    );
  }
}
