import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

@immutable
class StringConstants {
  // Can't instantiate this class. Use it directly.
  const StringConstants._();
  static const String appName = "Poznaj Katowice";

  //region Error screen strings
  static const String notFound = "Aradığınız Sayfayı Bulamadık";
  static const String notFoundSub =
      "Bir şeyler yanlış gitmiş olmalı. Lütfen daha sonra tekrar deneyin.";
  static const String back = "Geri Dön";
  //endregion

  //region No Network screen strings
  static const String noNetwork = "İnternet Yok";
  static const String noNetworkSub =
      "Lütfen internet bağlantınızı kontrol edin ve daha sonra tekrar deneyin.";
  //endregion

  //region Server Error screen strings
  static const String serverError = "Sunucu Hatası";
  static const String serverErrorSub =
      "Şu anda sunucularımıza bağlanmakta güçlük çekiyoruz. Lütfen daha sonra tekrar deneyin.";
  //endregion

  //region Need Update screen strings
  static const String needUpdate = "Güncelleme Gerekiyor.";
  static const String needUpdateSub =
      "Rota Erzincan uygulamasını kullanmaya devam edebilmek için uygulamayı güncellemeniz gerekmektedir.";
  static const String update = "Güncelle";
  //endregion

  static const categoriesTitle = "Kategoriler";
  static const categoriesSubtitle =
      "Erzincan'ın keşfedilmeyi bekleyen hazineleriyle tanışın";

  static const targetTitleTerzibaba = "Terzibaba Camii";
  static const mapErrorNoAppInstalled =
      "Cihazınızda yüklü bir harita uygulaması bulunamadı.";
  static const mapAppSelectionTitle =
      "Konuma Gitmek İstediğiniz Harita Uygulamasını Seçin";
  static const unitMeter = 'metre';
  static const unitKilometer = 'km';

  static const openingHoursText = '09:00 - 18:00';
  static const locationErzincan = 'Erzincan';
  static const ratingDefault = '4.8';
  static const showLessText = 'Daha Az Göster';
  static const readMoreText = 'Devamını Oku';
  static const galleryTitle = 'Galeri';
  static const photoPrefix = 'Fotoğraf';
  static const detailGalleryTitle = 'Spodek Arena';

  static const locationLoadingText = "Konumunuz alınıyor...";
  static const locationPermissionTitle = "Konum Erişimi Gerekli";
  static const locationPermissionDescription =
      "En yakın acil toplanma alanını bulabilmek için konum erişimine izin vermeniz gerekiyor.";
  static const locationPermissionButton = "Konuma İzin Ver";

  static const skiExcitementText = 'Heyecan dolu kayak deneyimi';
  static const winterSportsParadiseText = 'Kış sporları cenneti';
  static const snowFunWaitingText = 'Kar keyfi sizi bekliyor';

  static const galleryCategoryAll = "Tümü";
  static const galleryCategoryNature = "Doğa";
  static const galleryCategoryArchitecture = "Mimari";
  static const galleryCategoryCulture = "Kültür";
  static const galleryCategoryFood = "Yemek";

  static const galleryPageTitle = "Fotoğraf Galerisi";
  static const galleryPageSubtitle =
      "Erzincan'ın benzersiz manzaralarını keşfedin";

  static const opinionPageTitle = "Görüş Bildir";
  static const opinionPageSubtitle =
      "Sizin değerli geri bildirimlerinizle büyüyor, daha iyiye doğru ilerliyoruz!";
  static const nameLabel = "Adınız Soyadınız";
  static const nameHint = "Adınızı ve soyadınızı giriniz";
  static const emailLabel = "E-posta Adresiniz";
  static const emailHint = "ornek@mail.com";
  static const commentLabel = "Görüşleriniz";
  static const commentHint = "Görüşlerinizi bizimle paylaşın...";
  static const submitButtonText = "Gönder";

  static String get footerCopyright =>
      'Erzincan Valiliği © ${DateTime.now().year}';

  static const opinionSuccessMessage = "Görüşünüz alındı, teşekkür ederiz!";
  static const nameValidationEmpty = "Lütfen adınızı giriniz";
  static const emailValidationEmpty = "Lütfen e-posta adresinizi giriniz";
  static const emailValidationInvalid = "Geçerli bir e-posta adresi giriniz";
  static const commentValidationEmpty = "Lütfen görüşünüzü giriniz";
  static const commentValidationTooShort =
      "Görüşünüz en az 10 karakter olmalıdır";

  static const homeHeaderErzincan = "Erzincan'da";
  static const homeHeaderSuffix = "hazır mısın? ";
  static const homeSectionTitle = "Ana Başlıklar";
  static const homeSeeAllText = "Tümünü Gör";
  static const homeAboutTitle = "Erzincan Hakkında";
  static const homeAboutDescription =
      "Doğu Anadolu Bölgesi'nin Yukarı Fırat bölümünde yer alan Erzincan, doğal güzellikleri, tarihi yapıları ve kültürel zenginlikleri ile öne çıkar. Ergan Dağı Kayak Merkezi, Girlevik Şelalesi ve daha pek çok turistik noktası ile keşfedilmeyi bekliyor.";
  static const homeMoreInfoText = "Detaylı Bilgi";

  static const homeAnimatedExplore = "Keşfetmeye";
  static const homeAnimatedLearn = "Öğrenmeye";
  static const homeAnimatedTaste = "Tatmaya";
  static const homeAnimatedAdventure = "Maceraya";

  static const mapErrorNoAppInstalledSimple =
      'Yüklü bir harita uygulaması bulunamadı';
  static const mapErrorGoogleMapsFailed = 'Google Maps Açılamadı';
  static const mapAppSelectionStopTitle =
      'Bu durağı açmak istediğiniz harita uygulamasını seçin';
  static const mapErrorGeneric = 'Harita uygulaması açılırken bir hata oluştu.';
  static const mapAppSelectionRouteTitle =
      'Konuma Gitmek İstediğiniz Harita Uygulamasını Seçin';

  static const routeNoStopsText = "Rotada ekli durak bulunmuyor.";

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    return hours > 0
        ? 'hourMinuteFormat'.tr(namedArgs: {
            'hours': hours.toString(),
            'minutes': minutes.toString(),
          })
        : 'minuteOnlyFormat'.tr(namedArgs: {
            'minutes': minutes.toString(),
          });
  }

  static const routesReadyTitle = "Hazır Rotalar";

  static const searchHintText = "Ne arıyorsunuz?";
  static const popularSearchesTitle = "Popüler Aramalar";
  static const allContentTitle = "Tüm İçerikler";

  static const popularSearchTerziBaba = "Terzi Baba";
  static const popularSearchGirlevik = "Girlevik Şelalesi";
  static const popularSearchErgan = "Ergan Dağı";
  static const popularSearchKemaliye = "Kemaliye";
  static const popularSearchRefahiye = "Refahiye";
  static const popularSearchKemah = "Kemah Kalesi";

  static const List<String> popularSearchTerms = [
    popularSearchTerziBaba,
    popularSearchGirlevik,
    popularSearchErgan,
    popularSearchKemaliye,
    popularSearchRefahiye,
    popularSearchKemah,
  ];

  static const locationServiceOffTitle = "Konum Servisi Kapalı";
  static const locationServiceOffMessage =
      "Rota özelliklerimizi kullanabilmek için konum servisini açmalısınız.";
  static const locationPermissionDeniedTitle = "Konum İzni Reddedildi";
  static const locationPermissionDeniedMessage =
      "Bu uygulama konum izni olmadan çalışamaz.";
  static const locationPermissionPermanentlyDeniedTitle =
      "Konum İzni Kalıcı Olarak Reddedildi";
  static const locationPermissionPermanentlyDeniedMessage =
      "Konum iznini ayarlardan manuel olarak açmalısınız.";
  static const openSettingsButton = "Ayarları Aç";
  static const okButtonText = "Tamam";

  static const aboutSectionTitle = "Merkez Hakkında";
  static const aboutSectionDescription =
      "Ergan Kayak Merkezi, Erzincan'ın en gözde kış turizm noktasıdır. 3278 metre rakıma sahip Ergan Dağı'nda bulunan merkez, farklı zorluk seviyelerinde pistleri, modern telesiyej sistemleri ve panoramik manzarası ile kış sporları tutkunlarına benzersiz bir deneyim sunmaktadır.";
  static const aboutSectionMoreInfo = "Detaylı Bilgi İçin Tıklayın";
  static const aboutSectionDirections = "Yol Tarifi";
  static const aboutSectionCall = "Ara";

  static const addToRouteTitle = "Rotalarım";
  static const addToRouteEmptyMessage = "Henüz rota oluşturmadınız.";
  static const addToRouteSaveButton = "Kaydet";
  static const addToRouteNewRouteButton = "Yeni Rota";
  static const undoButtonLabel = "Geri Al";

  static String routeStopAddedMessage(String stopTitle, String routeTitle) =>
      "Durak '$stopTitle' '$routeTitle' rotasına eklendi.";

  static String routeStopRemovedMessage(String stopTitle, String routeTitle) =>
      "Durak '$stopTitle' '$routeTitle' rotasından çıkarıldı.";

  static const galleryItemTitle = "Erzincan Kareleri";
  static const categoryCardExploreButton = "Keşfet";
  static const discoverErzincanTitle = "Erzincan'ı Keşfet";

  static const bottomNavHome = "Ana Sayfa";
  static const bottomNavCategories = "Kategoriler";
  static const bottomNavGallery = "Galeri";
  static const bottomNavRoutes = "Rotalar";
  static const bottomNavEvents = "Etkinlikler";

  static const eventHighlightTitle = "Bu Ayın Etkinlikleri";
  static const eventHighlightSubtitle = "Kaçırma!";

  static const drawerMessageFromGovernor = "Valimizden Mesaj";
  static const drawerAboutErzincan = "Erzincan Hakkında";
  static const drawerEmergencyAreas = "Acil Toplanma Alanları";
  static const drawerAboutApp = "Uygulama Hakkında";
  static const drawerFeedback = "Görüş Bildir";

  static const drawerLightMode = "Aydınlık Mod";
  static const drawerDarkMode = "Karanlık Mod";

  static String get drawerCopyright =>
      'Erzincan Valiliği © ${DateTime.now().year}';

  static const emergencyPhoneTitle = "Acil Durum Telefonları";
  static const emergencyPhone112 = "112 - Acil Çağrı Merkezi";
  static const emergencyPhone122 = "122 - AFAD";

  static const facilityStatusTitle = "Tesis Durumu";
  static const facilityStatusBadge = "Güncel";

  static const facilityOpenLabel = "  Açık  ";
  static const facilityClosedLabel = "Kapalı";

  static const floatingPanelDetailsButton = "Detaylar";
  static const floatingPanelPersonSuffix = "Kişi";
  static const floatingPanelFacilitySuffix = "İmkan";
  static const floatingPanelNearestButton = "En Yakın Alana Git";

  static const heroSectionBadgeText = "En Popüler";
  static const heroSectionTitle = "Ergan Dağı Kayak Merkezi";
  static const heroSectionLocation = "Erzincan, Türkiye";
  static const heroSectionAltitude = "3278m Rakım";

  static const legendTitle = 'Gösterge';
  static const legendYourLocation = 'Konumunuz';
  static const legendAssemblyArea = 'Toplanma Alanı';
  static const legendNearestArea = 'En Yakın Alan';

  static const liveBadge = 'CANLI';
  static const liveCamsTitle = "Canlı Kameralar";
  static const liveCamsSubtitle = "Ergan'ı canlı olarak keşfedin";

  // Yeni Rota Modal
  static const newRouteTitle = 'Yeni Rota Oluştur';
  static const newRouteSubtitle = 'Kendi özel rotanızı oluşturun ve keşfedin';
  static const routeNameLabel = 'Rota Adı';
  static const routeNameHint = 'Ör: Erzincan Keşfi';
  static const routeDescLabel = 'Rota Açıklaması';
  static const routeDescHint = 'Rotanızı kısaca tanımlayın...';
  static const stopsLabel = 'Duraklar';
  static const selectedCount = 'seçildi';

  // Toast mesajları
  static const formIncompleteToast =
      'Lütfen rota adı, açıklama girin ve en az 1 durak seçin.';
  static const routeSavedToast = 'Rota Başarıyla Kaydedildi';

  // Butonlar
  static const updateRouteButton = 'Rotayı Güncelle';
  static const saveRouteButton = 'Rotayı Kaydet';

  // PlaceCardWidget
  static const viewOnMapButton = 'Haritada Gör';

  // PointDetailSheet
  static const assemblyAreaLabel = 'Toplanma Alanı';
  static const capacityLabel = 'Kapasite';
  static const capacityUnit = 'Kişi';
  static const descriptionLabel = 'Açıklama';
  static const facilitiesLabel = 'Mevcut İmkanlar';
  static const contactLabel = 'İletişim';
  static const navigateButtonLabel = 'Bu Alana Yönlendir';

  // RecentSearchesWidget
  static const noSearchesText = 'Henüz arama yapılmadı.';
  static const recentSearchesTitle = 'Son Aramalar';
  static const clearButtonLabel = 'Temizle';

  static const stopDeletedPrefix = 'Durak silindi:';

  // Mesafe göstergesi
  static const distancePrefix = 'Bana uzaklık:';
  static const distanceLessThanOne = '< 1 km';
  static const distanceUnitKm = ' km';

  // Haritada Git butonu
  static const goToMapButton = 'Haritada Git';

  // Ana sayfa – Rotalar bölümü
  static const routesHeader = 'Rotalar';
  static const routesSubheader =
      'Erzincan’ın en özel rotalarında yolculuğa çıkmaya hazır mısınız?';

  // Arama sonuçları
  static const noResultsFound = 'Sonuç bulunamadı.';

  // Photo Detail Sheet
  static const photoDetailsTitle = 'Fotoğraf Detayları';
  static const locationLabel = 'Konum';
  static const locationValue = 'Erzincan, Türkiye';
  static const dateLabel = 'Tarih';
  static const dateValue = '2023';
  static const photographerLabel = 'Fotoğrafçı';
  static const photographerValue = 'Rota Erzincan';
  static const photoDescription =
      'Bu fotoğraf, Erzincan\'ın eşsiz doğal güzelliklerini göstermektedir. '
      'Bölgenin karakteristik coğrafi özellikleri ve kültürel zenginliği gözler önüne serilmektedir.';

  static const startFullRouteOnMapButton = 'Tüm Rotayı Haritada Başlat';

  // “Daha fazlası için yukarı kaydır”
  static const scrollUpForMore = 'Daha fazlası için yukarı kaydır';

  // Rota silindi mesajı için suffix (başına rota adı gelecek)
  static const routeDeletedSuffix = ' adlı rota silindi';

  // Rota listesi boşken gösterilecek mesaj
  static const noUserRoutesText = 'Henüz oluşturduğunuz bir rota bulunmuyor.';

  // Rotaları silme yönergesi
  static const swipeToDeleteRoutes =
      'Rotaları silmek için sola kaydırabilirsiniz.';

  // Hava ve Kar Durumu başlığı
  static const weatherAndSnowTitle = 'Hava ve Kar Durumu';

  // Swipe yönergesi
  static const swipeForAllInfo = 'Tüm bilgileri görmek için kaydır';

  static const distanceCalculatingText = "Mesafe hesaplanıyor...";
}
