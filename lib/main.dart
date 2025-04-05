import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/string_constants.dart';
import 'package:rota_erzincan/constants/theme_data.dart';
import 'package:rota_erzincan/init/navigation/custom_navigation_observer.dart';
import 'package:rota_erzincan/init/navigation/navigation_route.dart';
import 'package:rota_erzincan/init/navigation/navigation_service.dart';
import 'package:rota_erzincan/init/start/application_start.dart';
import 'package:rota_erzincan/pages/DetailsPage/details_page_view_model.dart';
import 'package:rota_erzincan/pages/FullScreenGallery/full_screen_gallery_page_view_model.dart';
import 'package:rota_erzincan/pages/HomePage/home_page.view_model.dart';
import 'package:rota_erzincan/pages/SplashPage/splash_page.dart';
import 'package:rota_erzincan/pages/SplashPage/splash_page_view_model.dart';
import 'package:rota_erzincan/pages/StoryPage/story_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';

void main() async {
  final splashViewModel = SplashPageViewModel();
  ApplicationStart.init(splashViewModel);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomePageViewModel()),
        ChangeNotifierProvider(create: (_) => DetailsPageViewModel()),
        ChangeNotifierProvider(create: (_) => StoryPageViewModel()),
        ChangeNotifierProvider<FullscreenGalleryViewModel>(
          create: (context) =>
              FullscreenGalleryViewModel(0), // veya uygun bir başlangıç index'i
        ),
        ChangeNotifierProvider(create: (_) => splashViewModel),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
