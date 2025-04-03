import 'package:flutter/material.dart';
import 'package:rota_erzincan/animations/right_transition.dart';
import 'package:rota_erzincan/constants/navigator_constants.dart';
import 'package:rota_erzincan/pages/DetailsPage/details_page.dart';
import 'package:rota_erzincan/pages/HomePage/home_page.dart';
import 'package:rota_erzincan/pages/SplashPage/splash_page.dart';
import 'package:rota_erzincan/pages/error_pages/need_update/need_update_page.dart';
import 'package:rota_erzincan/pages/error_pages/no_network/no_network_page.dart';
import 'package:rota_erzincan/pages/error_pages/not_found/not_found_page.dart';
import 'package:rota_erzincan/pages/error_pages/server_error/server_error_page.dart';

@immutable
class NavigationRoute {
  static const NavigationRoute _instance = NavigationRoute._();
  static NavigationRoute get instance => _instance;

  const NavigationRoute._();

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigatorConstants.SPLASH_PAGE:
        return slideAnimatedRoute(const SplashPage(), args.arguments);
      /* case NavigatorConstants.WELCOME_PAGE:
        return slideAnimatedRoute(const WelcomePage(), args.arguments);*/
      case NavigatorConstants.NOT_FOUND:
        return slideAnimatedRoute(const NotFound(), args.arguments);
      case NavigatorConstants.NO_NETWORK:
        return slideAnimatedRoute(const NoNetworkPage(), args.arguments);
      case NavigatorConstants.NEED_UPDATE:
        return slideAnimatedRoute(const NeedUpdatePage(), args.arguments);
      case NavigatorConstants.SERVER_ERROR:
        return slideAnimatedRoute(const ServerErrorPage(), args.arguments);
      /* case NavigatorConstants.ONBOARDING_PAGE:
        return slideAnimatedRoute(const OnBoardingPage(), args.arguments);*/
      case NavigatorConstants.HOME:
        return slideAnimatedRoute(const HomePage(), args.arguments);
      case NavigatorConstants.DETAILS:
        return slideAnimatedRoute(const DetailsPage(), args.arguments);
      default:
        return slideAnimatedRoute(const NotFound(), args.arguments);
    }
  }

  MaterialPageRoute nonAnimatedRoute(Widget widget) {
    return MaterialPageRoute(
      builder: (context) => widget,
      settings: RouteSettings(name: widget.toString()),
    );
  }

  PageRouteBuilder slideAnimatedRoute(Widget widget, Object? args) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondayAnimation) => widget,
        settings: RouteSettings(name: widget.toString(), arguments: args),
        transitionsBuilder: RightTransition);
  }
}
