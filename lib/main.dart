import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/string_constants.dart';
import 'package:rota_erzincan/constants/theme_data.dart';
import 'package:rota_erzincan/init/navigation/custom_navigation_observer.dart';
import 'package:rota_erzincan/init/navigation/navigation_route.dart';
import 'package:rota_erzincan/init/navigation/navigation_service.dart';
import 'package:rota_erzincan/init/start/application_start.dart';
import 'package:rota_erzincan/pages/CategoriesPage/categories_page_view_model.dart';
import 'package:rota_erzincan/pages/DetailsPage/details_page_view_model.dart';
import 'package:rota_erzincan/pages/DetailPhotoView/detail_photo_view_page_view_model.dart';
import 'package:rota_erzincan/pages/GalleryPage/gallery_page_view_model.dart';
import 'package:rota_erzincan/pages/HomePage/home_page.view_model.dart';
import 'package:rota_erzincan/pages/LiveCamsPage/live_cams_page_view_model.dart';
import 'package:rota_erzincan/pages/RouteDetailPage/new_route_modal_view_model.dart';
import 'package:rota_erzincan/pages/SplashPage/splash_page.dart';
import 'package:rota_erzincan/pages/SplashPage/splash_page_view_model.dart';
import 'package:rota_erzincan/pages/StoryPage/story_page_view_model.dart';
import 'package:rota_erzincan/pages/routesPage/routes_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';

void main() async {
  final splashViewModel = SplashPageViewModel();
  ApplicationStart.init(splashViewModel);
  await _handleLocationPermission();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomePageViewModel()),
        ChangeNotifierProvider(create: (_) => GalleryPageViewModel()),
        ChangeNotifierProvider(create: (_) => DetailsPageViewModel()),
        ChangeNotifierProvider(create: (_) => StoryPageViewModel()),
        ChangeNotifierProvider(create: (_) => CategoriesPageViewModel()),
        ChangeNotifierProvider(create: (_) => RoutesPageViewModel()),
        ChangeNotifierProvider(create: (_) => NewRouteModalViewModel()),
        ChangeNotifierProvider<DetailPhotoViewPageViewModel>(
          create: (context) => DetailPhotoViewPageViewModel(
              0), // veya uygun bir başlangıç index'i
        ),
        ChangeNotifierProvider(create: (_) => splashViewModel),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LiveCamsPageViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _handleLocationPermission() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Lokasyon servisi açık değilse hata fırlat
    throw Exception('Konum servisi etkin değil.');
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Konum izni reddedildi.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception(
        'Konum izni kalıcı olarak reddedildi, ayarlardan açmanız gerekiyor.');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: StringConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: AppThemes.darkTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      themeMode: themeProvider.themeMode,
      onGenerateRoute: NavigationRoute.instance.generateRoute,
      navigatorKey: NavigationService.instance.navigatorKey,
      navigatorObservers: [CustomNavigatorObserver()],
      home: const SplashPage(),
    );
  }
}
