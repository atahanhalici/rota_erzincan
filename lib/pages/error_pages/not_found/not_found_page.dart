import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/init/navigation/navigation_service.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/StadiumSideButton.dart';

import '../../../constants/string_constants.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationService navigationService = NavigationService.instance;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        body: Center(
      child: Padding(
        padding: context.padding.medium,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 7,
            ),
            Image.asset(ImageConstants.notFound),
            Text(
              StringConstants.notFound,
              style: GoogleFonts.poppins(
                textStyle: context.general.textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: themeProvider.textColor),
              ),
              textAlign: TextAlign.center,
            ),
            context.sized.emptySizedHeightBoxLow3x,
            Text(
              StringConstants.notFoundSub,
              style: context.general.textTheme.titleMedium!
                  .copyWith(color: themeProvider.textColor),
            ),
            const Spacer(
              flex: 5,
            ),
            Image.asset(
              ImageConstants.logo,
              height: context.sized.dynamicHeight(0.1),
            ),
            const Spacer(),
            StadiumSideButton(
              text: StringConstants.back,
              onPressed: () => navigationService.navigateToBack(),
              color: themeProvider.buttonColor,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    ));
  }
}
