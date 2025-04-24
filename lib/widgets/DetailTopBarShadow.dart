import 'package:flutter/material.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
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
                    ? Colors.black.withValues(alpha: 0.4)
                    : Colors.grey.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Appbar(
            actionIcon: const Icon(
              Icons.search,
              size: 30,
              color: ColorConstants.buttonColor,
            ),
            onActionPressed: () {
              // Arama butonuna basıldığında yapılacaklar
            },
          ),
        ),
      ),
    );
  }
}
