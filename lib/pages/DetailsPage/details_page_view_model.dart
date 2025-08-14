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
  final String fullTextTr =
      "Spodek Arena ve Çevresi, Katowice'nin en önemli modern mimari ve kültürel yapılarından biridir. Arena, çeşitli spor ve kültürel etkinliklerin merkezi olarak bilinir. 1970'li yıllarda inşa edilen yapı, hem işlevsel hem de estetik açıdan şehrin simgelerinden biridir. Büyük ve gösterişli kubbesi, geniş iç hacmi ve dikkat çekici detaylarıyla bölgenin en popüler mekanlarından biridir. Çevresindeki alan, ziyaretçiler için geniş kullanım alanları sunar."
      "Alan sadece etkinlik mekanı olmanın ötesinde, kültürel buluşmalar ve sosyal aktivitelerin de gerçekleştirildiği bir merkezdir. Konserler, fuarlar ve çeşitli festivaller burada düzenlenmektedir. Arena ve çevresindeki yapılar, ziyaretçilerin tüm ihtiyaçlarını karşılamak için çeşitli hizmetler sunar. Özellikle büyük etkinliklerde yoğun bir ziyaretçi akını gözlemlenir. Katowice halkı için önemli bir kültürel merkez olmasının yanı sıra, şehir dışından gelen turistler için de cazibe noktasıdır."
      "Spodek Arena, Katowice şehir siluetinde öne çıkan bir yapıdır ve özellikle akşam aydınlatmalarıyla görsel bir şölen sunar. Modern mimarinin zarif detaylarını barındıran tasarımıyla, ziyaretçilere etkileyici ve keyifli bir deneyim sunar. Katowice’nin kültürel ve sosyal yaşamının önemli bir parçası olarak, Spodek Arena uzun yıllardır şehrin simgesi olmayı sürdürmektedir.";

  final String fullTextEn =
      "Spodek Arena and its surroundings are among the most important modern architectural and cultural landmarks in Katowice. The arena serves as a central hub for various sports and cultural events. Built in the 1970s, the structure is one of the city's iconic buildings due to its functional and aesthetic design. With its large dome, spacious interior, and striking details, it is one of the most popular venues in the region. The surrounding area provides ample space for visitors."
      "The venue is more than just an event space; it also hosts cultural gatherings and social activities. Concerts, trade fairs, and various festivals are regularly organized here. The arena and nearby facilities offer various services to meet the needs of all visitors. Especially during major events, a significant influx of attendees can be observed. Spodek Arena is not only an important cultural center for the residents of Katowice but also an attractive destination for tourists from outside the city."
      "Spodek Arena stands out in the Katowice cityscape and offers a unique visual spectacle with its evening lighting. Its design, reflecting elegant details of modern architecture, provides visitors with an impressive and enjoyable experience. As an integral part of Katowice’s cultural and social life, Spodek Arena has remained a symbol of the city for decades.";

  final List<String> imageUrls = List.generate(
      3, (index) => 'https://picsum.photos/800/500?random=$index');
  final FlutterTts _flutterTts = FlutterTts();

  void init({
    required CategoryContentItem item,
  }) {
    _contentItem = item;

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
        await _flutterTts.speak(fullTextTr);
      } else {
        await _flutterTts.setLanguage("en-US");
        await _flutterTts.setPitch(1.0);
        await _flutterTts.setSpeechRate(0.5);
        await _flutterTts.speak(fullTextEn);
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

  final double targetLatitude = 50.2599;
  final double targetLongitude = 19.0216;
  final String targetTitle = 'targetTitleTerzibaba'.tr();
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
