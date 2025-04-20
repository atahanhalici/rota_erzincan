import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/navigator_constants.dart';
import 'package:rota_erzincan/init/navigation/INavigationService.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/models/CategoryItem.dart';
import 'package:rota_erzincan/models/RouteItem.dart';
import 'package:rota_erzincan/pages/CategoryDetail/category_detail_page.dart';
import 'package:rota_erzincan/pages/CategoryDetail/category_detail_page_view_model.dart';
import 'package:rota_erzincan/pages/DetailsPage/details_page.dart';
import 'package:rota_erzincan/pages/DetailsPage/details_page_view_model.dart';
import 'package:rota_erzincan/pages/RouteDetailPage/route_Detail_page.dart';
import 'package:rota_erzincan/pages/RouteDetailPage/route_detail_page_view_model.dart';

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
    'StoryPage': NavigatorConstants.STORY,
    'GalleryPage': NavigatorConstants.GALLERY,
    'ErganPage': NavigatorConstants.ERGAN,
    'CategoriesPage': NavigatorConstants.CATEGORIES,
    'CamerasPage': NavigatorConstants.CAMERAS,
    'CategoryDetailPage': NavigatorConstants.CATEGORYDETAIL,
    'RoutesPage': NavigatorConstants.ROUTES,
    'RouteDetailPage': NavigatorConstants.ROUTEDETAIL,
  };

  String _getPathFromPageName(String pageName) {
    return pageNameToPathMap[pageName] ?? pageName;
  }

  @override
  Future<void> navigateToCategoryDetail(CategoryItem item) async {
    if (NavigatorConstants.CATEGORYDETAIL != page) {
      page = NavigatorConstants.CATEGORYDETAIL;

      await navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => CategoryDetailViewModel(category: item),
            child: const CategoryDetailPage(),
          ),
        ),
      );
    }
  }

  @override
  Future<void> navigateToDetailsPage(CategoryContentItem item) async {
    await navigatorKey.currentState?.push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ChangeNotifierProvider(
          create: (_) => DetailsPageViewModel(),
          child: const DetailsPage(),
        ),
        settings: RouteSettings(
          arguments: item,
          name: 'details_${item.id}_${DateTime.now().millisecondsSinceEpoch}',
        ),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Future<void> navigateToRouteDetailsPage(RouteItem item) async {
    await navigatorKey.currentState?.push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ChangeNotifierProvider(
          create: (_) => RouteDetailPageViewModel(route: item),
          child: RouteDetailPage(key: UniqueKey()),
        ),
        settings: RouteSettings(
          arguments: item,
        ),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
