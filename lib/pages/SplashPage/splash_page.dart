import 'package:flutter/material.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:rota_erzincan/constants/image_constants.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    //final viewModel = Provider.of<SplashPageViewModel>(context, listen: false);
    return
        // ignore: unused_local_variable

        Scaffold(
      body: Column(
        children: [
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset(ImageConstants.logo),
          ),
          const Expanded(child: SizedBox()),
          const LinearProgressIndicator(
            color: ColorConstants.buttonColor,
            backgroundColor: ColorConstants.backgroundColor,
          ),
        ],
      ),
    );
  }
}
