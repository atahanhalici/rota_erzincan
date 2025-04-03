import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/theme_provider.dart';

import '../../../constants/image_constants.dart';
import '../../../constants/string_constants.dart';

class ServerErrorPage extends StatelessWidget {
  const ServerErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: context.padding.medium,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(ImageConstants.serverError),
              context.sized.emptySizedHeightBoxLow,
              Text(StringConstants.serverError,
                  style: GoogleFonts.poppins(
                    textStyle: context.general.textTheme.headlineMedium!
                        .copyWith(
                            fontWeight: FontWeight.w500,
                            color: themeProvider.textColor),
                  )),
              context.sized.emptySizedHeightBoxLow3x,
              Text(
                StringConstants.serverErrorSub,
                style: context.general.textTheme.titleMedium!
                    .copyWith(color: themeProvider.textColor),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Image.asset(
                ImageConstants.logo,
                height: context.sized.dynamicHeight(0.1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
