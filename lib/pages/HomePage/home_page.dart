import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/pages/HomePage/home_page.view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    HomePageViewModel _homeModel =
        Provider.of<HomePageViewModel>(context, listen: true);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _homeModel.navigateToDetails(context);
              },
              child: const Text("HomePage'e Git"),
            ),
            ElevatedButton(
              onPressed: themeProvider.toggleTheme,
              child: const Text("Temayı Değiştir"),
            ),
          ],
        ),
      ),
    );
  }
}
