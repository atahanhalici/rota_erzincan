import 'package:flutter/material.dart';
import 'package:rota_erzincan/constants/navigator_constants.dart';
import 'package:rota_erzincan/init/navigation/INavigationService.dart';

class NavigationService implements INavigationService {
  static final NavigationService _instance = NavigationService._();
  static NavigationService get instance => _instance;
  String page = '/splash';

  NavigationService._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final removeAllOldRoutes = (Route<dynamic> route) => false;

  @override
  Future<void> navigateToPage(String path, Object? object) async {
    if (path != page) {
      page = path;
      await navigatorKey.currentState!.pushNamed(path, arguments: object);
    }
  }

  @override
  Future<void> navigateToPageClear(String path, Object? object) async {
    if (path != page) {
      page = path;
      await navigatorKey.currentState!
          .pushNamedAndRemoveUntil(path, removeAllOldRoutes, arguments: object);
    }
  }

  @override
  void navigateToBack() async {
    // Açılır bileşen varsa sadece onu kapat, yoksa sayfa geçmişinde git
    final didPop = await navigatorKey.currentState!.maybePop();
    if (!didPop) {
      if (navigatorKey.currentState!.canPop()) {
        navigatorKey.currentState!.pop();
      } else {
        page = "/splash";
      }
    }
  }

  @override
  void updatePageOnBack(Route<dynamic> route) {
    final routeName = route.settings.name;
    if (routeName != null) {
      page = _getPathFromPageName(routeName);
    }
  }

  final Map<String, String> pageNameToPathMap = {
    'SplashPage': NavigatorConstants.SPLASH_PAGE,
    'WelcomePage': NavigatorConstants.WELCOME_PAGE,
    'OnboardingPage': NavigatorConstants.ONBOARDING_PAGE,
    'NotFoundPage': NavigatorConstants.NOT_FOUND,
    'NoNetworkPage': NavigatorConstants.NO_NETWORK,
    'ServerErrorPage': NavigatorConstants.SERVER_ERROR,
    'NeedUpdatePage': NavigatorConstants.NEED_UPDATE,
    'DetailsPage': NavigatorConstants.DETAILS,
    'HomePage': NavigatorConstants.HOME,
  };

  String _getPathFromPageName(String pageName) {
    return pageNameToPathMap[pageName] ?? pageName;
  }
}
