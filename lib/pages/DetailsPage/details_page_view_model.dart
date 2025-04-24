import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/FancyMenuLogoItem.dart';

class DetailsPageViewModel extends ChangeNotifier with BaseViewModel {
  late CategoryContentItem _contentItem;
  CategoryContentItem get contentItem => _contentItem;

  bool isExpanded = false;
  bool isSpeaking = false;
  final String fullText =
      "Terzibaba Camii ve Külliyesi, Erzincan'da bulunan ve şehrin en önemli dini ve kültürel yapılarından biridir. Caminin adı, halk arasında büyük bir manevi şahsiyet olarak kabul edilen Terzibaba'ya ithafen verilmiştir. 1980'li yıllarda inşa edilen cami, mimarisiyle hem modern hem de geleneksel unsurları bir araya getirir. Büyük ve gösterişli kubbesi, geniş iç hacmi ve dikkat çekici süslemeleriyle bölgenin en büyük ibadet merkezlerinden biri olarak kabul edilir. Caminin iç mekânında kalem işi süslemeler ve hat sanatı örnekleri yer alırken, avlusu da geniş bir kullanım alanına sahiptir."
      "Külliye, sadece bir ibadet alanı olmanın ötesinde, eğitim ve sosyal faaliyetlerin de gerçekleştirildiği bir merkez olarak tasarlanmıştır. Burada Kur'an kursları, dini sohbetler ve çeşitli kültürel etkinlikler düzenlenmektedir. Caminin yanında yer alan yapılar, ziyaretçilerin ve ibadet edenlerin ihtiyaçlarını karşılamak için çeşitli hizmetler sunmaktadır. Aynı zamanda, Terzibaba Camii, özellikle Cuma ve bayram namazlarında yoğun bir ziyaretçi akınına uğrar. Erzincan halkı için manevi bir merkez olmasının yanı sıra, şehir dışından gelen ziyaretçiler için de önemli bir cazibe noktasıdır."
      "Cami, Erzincan'ın şehir siluetinde önemli bir yer tutarken, özellikle akşam saatlerinde aydınlatmasıyla da ayrı bir görsel şölen sunar. İslam sanatının zarif detaylarını barındıran mimarisiyle, ziyaret edenlere huzurlu bir atmosfer sunar. Erzincan'ın kültürel ve dini mirasının bir parçası olan Terzibaba Camii ve Külliyesi, geçmişten günümüze kadar bölge halkının manevi hayatında büyük bir yer edinmiştir.";

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

  @override
  void dispose() {
    super.dispose();
  }

  toggleExpanded() {
    isExpanded = !isExpanded;
    notifyListeners();
  }

  Future<void> speakText() async {
    await _flutterTts.setLanguage("tr-TR"); // Türkçe konuşması için
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.55); // Hızlıysa 0.4 falan yap
    await _flutterTts.speak(fullText);
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  Future<void> toggleSpeaking() async {
    if (isSpeaking) {
      await stopSpeaking();
    } else {
      await speakText();
    }
  }

  final double targetLatitude = 39.71662446276216;
  final double targetLongitude = 39.4981052503663;
  final String targetTitle = "Terzibaba Camii";
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
        _mapErrorMessage =
            'Cihazınızda yüklü bir harita uygulaması bulunamadı.';
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
                  "Konuma Gitmek İstediğiniz Harita Uygulamasını Seçin",
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
        SnackBar(content: Text(mapErrorMessage!)),
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
