import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/theme_provider.dart';
import '../../../constants/image_constants.dart';
import 'package:easy_localization/easy_localization.dart';

class NoNetworkPage extends StatelessWidget {
  const NoNetworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final media = context.sized;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: media.dynamicWidth(0.08),
            vertical: media.dynamicHeight(0.04),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmallDevice = constraints.maxHeight < 600;

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: media.dynamicHeight(0.02)),

                  // KART
                  Container(
                    width: constraints.maxWidth,
                    padding: EdgeInsets.all(media.lowValue * 3),
                    decoration: BoxDecoration(
                      color: themeProvider.cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: themeProvider.buttonColor.withValues(alpha:0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          ImageConstants.noNetworkVector,
                          height:
                              media.dynamicHeight(isSmallDevice ? 0.2 : 0.25),
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: media.lowValue * 2),
                        Text(
                          'noNetwork'.tr(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: context.general.textTheme.headlineSmall!
                                .copyWith(
                              fontWeight: FontWeight.w500,
                              color: themeProvider.textColor,
                            ),
                          ),
                        ),
                        SizedBox(height: media.lowValue),
                        Text(
                          'noNetworkSub'.tr(),
                          textAlign: TextAlign.center,
                          style:
                              context.general.textTheme.titleMedium!.copyWith(
                            color: themeProvider.textColor.withValues(alpha:0.85),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // LOGO
                  Column(
                    children: [
                      SizedBox(height: media.dynamicHeight(0.04)),
                      Image.asset(
                        ImageConstants.logo,
                        height: media.dynamicHeight(0.07),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
