import 'package:flutter/material.dart';

@immutable
class ImageConstants {
  // Can't create an instance of this class. Use it directly.
  const ImageConstants._();

  static final String logo = 'logo_png'.logoToPng;
  static final String loading = 'loading'.imageToJpg;

  static final String serverError = 'server_error'.imageToPng;
  static final String notFound = 'not_found_asset'.imageToPng;
  static final String noNetworkVector = 'no_network'.imageToPng;
  static final String updateRequiredVector =
      'update_required_vector'.imageToPng;

  static final String googlePlayStore = 'google_play_store'.iconToPng;
  static final String appleStore = 'apple_store'.iconToPng;
}

extension _StringPath on String {
  String get imageToPng => 'assets/images/$this.png';
  String get imageToJpg => 'assets/images/$this.jpg';
  String get imageToGif => 'assets/images/$this.gif';
  String get iconToPng => 'assets/icons/$this.png';
  String get onboardingToPng => 'assets/onboarding/$this.png';
  String get logoToPng => 'assets/logos/$this.png';
  String get logoToJpg => 'assets/logos/$this.jpg';
}
