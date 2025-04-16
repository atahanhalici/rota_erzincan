import 'package:flutter/material.dart';

@immutable
class NavigatorConstants {
  // Can't create an instance of this class
  const NavigatorConstants._();

  static const SPLASH_PAGE = "/splash";
  static const WELCOME_PAGE = "/welcome";
  static const ONBOARDING_PAGE = "/onboarding";
  static const NOT_FOUND = "/not_found";
  static const NO_NETWORK = "/noNetwork";
  static const SERVER_ERROR = "/serverError";
  static const NEED_UPDATE = "/needUpdate";
  static const HOME = "/home";
  static const DETAILS = "/details";
  static const STORY = "/story";
  static const GALLERY = "/gallery";
  static const ERGAN = "/ergan";
  static const CATEGORIES = "/categories";
  static const CAMERAS = "/cameras";
}
