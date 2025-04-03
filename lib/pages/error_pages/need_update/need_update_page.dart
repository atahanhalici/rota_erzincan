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
            Image.asset(ImageConstants.updateRequiredVector),
            Text(
              StringConstants.needUpdate,
              style: GoogleFonts.poppins(
                textStyle: context.general.textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: themeProvider.textColor),
              ),
            ),
            context.sized.emptySizedHeightBoxLow3x,
            Text(
              StringConstants.needUpdateSub,
              style: context.general.textTheme.titleMedium!
                  .copyWith(color: themeProvider.textColor),
            ),
            const Spacer(),
            OutlinedButtonWithImage(
                onPressed: () {},
                textColor: themeProvider.textColor,
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
