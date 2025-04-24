import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/init/navigation/navigation_service.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/StadiumSideButton.dart';
import 'package:easy_localization/easy_localization.dart';

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
              flex: 8,
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: themeProvider.cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: themeProvider.buttonColor.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image.asset(ImageConstants.notFound),
                  const SizedBox(height: 24),
                  Text(
                    'notFound'.tr(),
                    style: GoogleFonts.poppins(
                      textStyle:
                          context.general.textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: themeProvider.textColor,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'notFoundSub'.tr(),
                    style: context.general.textTheme.titleMedium!.copyWith(
                      color: themeProvider.textColor.withValues(alpha: 0.85),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
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
              text: 'back'.tr(),
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
