import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:rota_erzincan/pages/LiveCamsPage/live_cams_page_view_model.dart';
import 'package:rota_erzincan/widgets/BackButtonOverlay.dart';
import 'package:rota_erzincan/widgets/LiveBadge.dart';
import 'package:rota_erzincan/widgets/PlayPauseButton.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerBody extends StatelessWidget {
  final bool isReady;

  const VideoPlayerBody({super.key, required this.isReady});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LiveCamsPageViewModel>(context);
    final orientation = MediaQuery.of(context).orientation;

    return Stack(
      children: [
        Center(
          child: isReady
              ? AspectRatio(
                  aspectRatio: vm.videoController.value.aspectRatio,
                  child: VideoPlayer(vm.videoController),
                )
              : const CircularProgressIndicator(
                  color: ColorConstants.buttonColor),
        ),
        if (isReady && vm.showPlayPause) const PlayPauseButton(),
        const LiveBadge(),
        if (orientation == Orientation.landscape) const BackButtonOverlay(),
      ],
    );
  }
}
