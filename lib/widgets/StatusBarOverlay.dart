import 'package:flutter/material.dart';
import 'package:rota_erzincan/theme_provider.dart';

class StatusBarOverlay extends StatelessWidget {
  final ThemeProvider themeProvider;
  const StatusBarOverlay({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.top,
      color: themeProvider.cardColor,
    );
  }
}
