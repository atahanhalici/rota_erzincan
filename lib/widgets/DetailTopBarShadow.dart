import 'package:flutter/material.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/AppBar.dart';

class DetailTopBarShadow extends StatelessWidget {
  final ThemeProvider themeProvider;
  const DetailTopBarShadow({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          height: kToolbarHeight,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: themeProvider.isDarkMode
                    ? Colors.black.withOpacity(0.4)
                    : Colors.grey.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Appbar(),
        ),
      ),
    );
  }
}
