import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/FancyMenuLogoItem.dart';

class DetailsPageViewModel extends ChangeNotifier with BaseViewModel {
  late CategoryContentItem _contentItem;
  CategoryContentItem get contentItem => _contentItem;

  bool isExpanded = false;
  bool isSpeaking = false;
  late String? todayHours;
  final FlutterTts _flutterTts = FlutterTts();

  void init({
    required CategoryContentItem item,
  }) {
    _contentItem = item;
    todayHours = getTodayHours(contentItem.hours);
    // TTS ayarları
    _flutterTts.setStartHandler(() {
      isSpeaking = true;
      notifyListeners();
    });

    _flutterTts.setCompletionHandler(() {
      isSpeaking = false;
      notifyListeners();
    });

    _flutterTts.setCancelHandler(() {
      isSpeaking = false;
      notifyListeners();
    });
  }

  String? getTodayHours(Map<String, String>? hours) {
    if (hours == null) return null;

    final now = DateTime.now();
    final weekdayMap = {
      1: 'monday',
      2: 'tuesday',
      3: 'wednesday',
      4: 'thursday',
      5: 'friday',
      6: 'saturday',
      7: 'sunday',
    };

    final todayKey = weekdayMap[now.weekday];
    return todayKey != null ? hours[todayKey] : null;
  }

  toggleExpanded() {
    isExpanded = !isExpanded;
    notifyListeners();
  }

  bool _isSpeakingInProgress = false;

  Future<void> toggleSpeaking(String localeCode) async {
    if (_isSpeakingInProgress) return; // zaten işlemdeyse blokla
    _isSpeakingInProgress = true;

    if (isSpeaking) {
      await stopSpeaking();
    } else {
      await speakText(localeCode);
    }

    _isSpeakingInProgress = false;
  }

  Future<void> speakText(String localeCode) async {
    try {
      await stopSpeaking(); // Her ihtimale karşı önce durdur
      await Future.delayed(
          const Duration(milliseconds: 200)); // motor nefes alsın

      if (localeCode == "tr") {
        await _flutterTts.setLanguage("tr-TR");
        await _flutterTts.setPitch(1.0);
        await _flutterTts.setSpeechRate(0.55);
        await _flutterTts.speak(contentItem.description);
      } else if (localeCode == "pl") {
        await _flutterTts.setLanguage("pl-PL");
        await _flutterTts.setPitch(1.0);
        await _flutterTts.setSpeechRate(0.55);
        await _flutterTts.speak(contentItem.description);
      } else {
        await _flutterTts.setLanguage("en-US");
        await _flutterTts.setPitch(1.0);
        await _flutterTts.setSpeechRate(0.5);
        await _flutterTts.speak(contentItem.description);
      }
    } catch (e) {
      isSpeaking = false;
      notifyListeners();
      debugPrint("TTS ERROR: $e");
    }
  }

  Future<void> stopSpeaking() async {
    try {
      await _flutterTts.stop();
      isSpeaking = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Stop speaking error: $e");
    }
  }

  String? _mapErrorMessage;
  String? get mapErrorMessage => _mapErrorMessage;

  void clearMapError() {
    _mapErrorMessage = null;
    notifyListeners();
  }

  Future<void> openMapApp(
      BuildContext context, ThemeProvider themeProvider) async {
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
          coords: Coords(contentItem.latitude!, contentItem.longitude!),
          title: contentItem.title,
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
                        coords:
                            Coords(contentItem.latitude!, contentItem.longitude!),
                        title: contentItem.title,
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
          backgroundColor: Colors.red.shade700, // veya Colors.red.shade700
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
