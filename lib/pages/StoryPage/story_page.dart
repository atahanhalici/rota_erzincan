import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:rota_erzincan/models/CategoryModel.dart';
import 'package:rota_erzincan/pages/StoryPage/story_page_view_model.dart';
import 'package:rota_erzincan/widgets/SmoothProgressBar.dart';
import 'package:rota_erzincan/widgets/SwipeUpHint.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> with TickerProviderStateMixin {
  final viewModel = StoryPageViewModel();

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      final stories = args['list'] as List<CategoryModel>;
      final index = args['index'] as int;

      viewModel.init(
        storyList: stories,
        index: index,
        ticker: this,
      );
      viewModel.onLastStoryCompleted = () => Navigator.pop(context);
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    viewModel.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        return GestureDetector(
          onLongPressStart: (_) {
            viewModel.pauseProgress();
            viewModel.toggleUI(false);
          },
          onLongPressEnd: (_) {
            viewModel.resumeProgress();
            viewModel.toggleUI(true);
          },
          onTapUp: (details) {
            final dx = details.globalPosition.dx;
            final screenWidth = MediaQuery.of(context).size.width;

            if (dx < screenWidth * 0.4) {
              viewModel.previousStory();
            } else if (dx > screenWidth * 0.6) {
              viewModel.nextStory();
            }
          },
          onVerticalDragUpdate: (details) {
            final dy = details.globalPosition.dy;
            final screenHeight = MediaQuery.of(context).size.height;

            // 👇 aşağı kaydırma (örneğin sayfayı kapatmak için)
            if (details.primaryDelta != null && details.primaryDelta! > 12) {
              Navigator.pop(context);
            }

            // 👆 yukarı kaydırma - sadece ekranın alt yarısından başlarsa
            if (details.primaryDelta != null &&
                details.primaryDelta! < -12 && // yukarı doğru hareket
                dy > screenHeight * 0.5) {
              if (viewModel.showHint) {
                viewModel.navigateToDetails(context);
              }
            }
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                PageView.builder(
                  controller: viewModel.pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: viewModel.stories.length,
                  onPageChanged: (index) {
                    // Yeni sayfa index'ini viewModel'e set et
                    viewModel.setCurrentIndex(index);

                    //viewModel.resetProgress();
                    /*  viewModel.checkIfImageCachedAndHandle(
                        viewModel.stories[index].imageUrl, true);*/
                  },
                  itemBuilder: (context, index) {
                    return FadeInImage.assetNetwork(
                      placeholder: "",
                      placeholderErrorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: SpinKitDualRing(
                            color: ColorConstants.buttonColor,
                            size: 50.0,
                          ),
                        );
                      },
                      imageErrorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: SpinKitDualRing(
                            color: ColorConstants.buttonColor,
                            size: 50.0,
                          ),
                        );
                      },
                      image: viewModel.stories[index].imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      imageSemanticLabel: 'Story image',
                    )..image.resolve(const ImageConfiguration()).addListener(
                          ImageStreamListener(
                            (ImageInfo image, bool synchronousCall) {},
                            onChunk: (ImageChunkEvent? chunk) {},
                          ),
                        );
                  },
                ),
                AnimatedOpacity(
                  opacity: viewModel.showUI ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: viewModel.progress,
                              backgroundColor: Colors.white30,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: viewModel.showUI ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Progress bar + close button
                          Row(
                            children: [
                              Expanded(
                                  child: SmoothProgressBar(
                                      animation:
                                          viewModel.animationController)),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 28),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // 👇 Story title with animation
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: double.infinity, // Genişliği sabitle
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                transitionBuilder: (child, animation) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0.0, 0.3),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOut,
                                    )),
                                    child: FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                  );
                                },
                                child: Align(
                                  key: ValueKey(viewModel.currentStoryTitle),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    viewModel.currentStoryTitle,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0, 1),
                                          blurRadius: 4,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: viewModel.showUI && viewModel.showHint ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: const Align(
                    alignment: Alignment.bottomCenter, // Ortaya yerleştir
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: SwipeUpHint()),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
