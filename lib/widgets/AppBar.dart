import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/constants/string_constants.dart';
import 'package:rota_erzincan/theme_provider.dart';

class Appbar extends StatelessWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AppBar(
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      backgroundColor: themeProvider.cardColor,
      iconTheme:
          const IconThemeData(color: ColorConstants.buttonColor, size: 30),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 45,
            child: Image.asset(
              ImageConstants.logo,
            ),
          ),
          const SizedBox(
            width: 7,
          ),
          Text(
            StringConstants.appName,
            style: TextStyle(
                color: themeProvider.textColor, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              size: 30,
              color: ColorConstants.buttonColor,
            ))
      ],
      shadowColor: ColorConstants.buttonColor,
      elevation: 6.0,
    );
  }
}
