import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';

class DetailsPageViewModel extends ChangeNotifier with BaseViewModel {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool isExpanded = false;
  bool isSpeaking = false;
  final String fullText =
      "Terzibaba Camii ve Külliyesi, Erzincan'da bulunan ve şehrin en önemli dini ve kültürel yapılarından biridir. Caminin adı, halk arasında büyük bir manevi şahsiyet olarak kabul edilen Terzibaba'ya ithafen verilmiştir. 1980'li yıllarda inşa edilen cami, mimarisiyle hem modern hem de geleneksel unsurları bir araya getirir. Büyük ve gösterişli kubbesi, geniş iç hacmi ve dikkat çekici süslemeleriyle bölgenin en büyük ibadet merkezlerinden biri olarak kabul edilir. Caminin iç mekânında kalem işi süslemeler ve hat sanatı örnekleri yer alırken, avlusu da geniş bir kullanım alanına sahiptir."
      "Külliye, sadece bir ibadet alanı olmanın ötesinde, eğitim ve sosyal faaliyetlerin de gerçekleştirildiği bir merkez olarak tasarlanmıştır. Burada Kur'an kursları, dini sohbetler ve çeşitli kültürel etkinlikler düzenlenmektedir. Caminin yanında yer alan yapılar, ziyaretçilerin ve ibadet edenlerin ihtiyaçlarını karşılamak için çeşitli hizmetler sunmaktadır. Aynı zamanda, Terzibaba Camii, özellikle Cuma ve bayram namazlarında yoğun bir ziyaretçi akınına uğrar. Erzincan halkı için manevi bir merkez olmasının yanı sıra, şehir dışından gelen ziyaretçiler için de önemli bir cazibe noktasıdır."
      "Cami, Erzincan'ın şehir siluetinde önemli bir yer tutarken, özellikle akşam saatlerinde aydınlatmasıyla da ayrı bir görsel şölen sunar. İslam sanatının zarif detaylarını barındıran mimarisiyle, ziyaret edenlere huzurlu bir atmosfer sunar. Erzincan'ın kültürel ve dini mirasının bir parçası olan Terzibaba Camii ve Külliyesi, geçmişten günümüze kadar bölge halkının manevi hayatında büyük bir yer edinmiştir.";

  final List<String> imageUrls = List.generate(
      3, (index) => 'https://picsum.photos/800/500?random=$index');
  final FlutterTts _flutterTts = FlutterTts();
  // Getter for animation
  AnimationController get controller => _controller;
  Animation<double> get fadeAnimation => _fadeAnimation;

  void init({required TickerProvider vsync}) {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
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
    _controller.dispose();
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

  // Gerekirse stop fonksiyonu da ekleyebilirsin
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
}
