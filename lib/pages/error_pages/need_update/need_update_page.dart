import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/string_constants.dart';
import 'package:rota_erzincan/enums/platform_enum.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/OutlinedButtonWithImage.dart';

import '../../../constants/image_constants.dart';

class NeedUpdatePage extends StatelessWidget {
  const NeedUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    String imagePath = PlatformEnum.currentPlatform.storeImage;
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
              flex: 2,
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: themeProvider.cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: themeProvider.buttonColor.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(ImageConstants.updateRequiredVector),
                  const SizedBox(height: 24),
                  Text(
                    StringConstants.needUpdate,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle:
                          context.general.textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: themeProvider.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    StringConstants.needUpdateSub,
                    textAlign: TextAlign.center,
                    style: context.general.textTheme.titleMedium!.copyWith(
                      color: themeProvider.textColor.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            OutlinedButtonWithImage(
                onPressed: () {},
                backgroundColor: themeProvider.buttonColor,
                textColor: Colors.white,
                text: StringConstants.update,
                imagePath: imagePath),
            const Spacer(),
            Image.asset(
              ImageConstants.logo,
              height: context.sized.dynamicHeight(0.1),
            ),
          ],
        ),
      ),
    ));
  }
}
