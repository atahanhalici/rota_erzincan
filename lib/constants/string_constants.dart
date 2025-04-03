import 'package:flutter/material.dart';

@immutable
class StringConstants {
  // Can't instantiate this class. Use it directly.
  const StringConstants._();
  //region Error screen strings
  static const String notFound = "Aradığınız Sayfayı Bulamadık";
  static const String notFoundSub =
      "Bir şeyler yanlış gitmiş olmalı. Lütfen daha sonra tekrar deneyin.";
  static const String back = "Back";
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
}
