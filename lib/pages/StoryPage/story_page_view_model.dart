import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rota_erzincan/models/CategoryModel.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';

class StoryPageViewModel extends ChangeNotifier with BaseViewModel {
  late List<CategoryModel> stories;
  late int initialIndex;
  late PageController pageController;

  double progress = 0.0;
  Timer? timer;
  bool showUI = true;

  void setCurrentIndex(int index) {
    initialIndex = index;
    pauseProgress();
    resetProgress();
    checkIfImageCachedAndHandle(stories[initialIndex].imageUrl, true);
    notifyListeners();
  }

  String get currentStoryTitle {
    if (stories.isEmpty) return '';
    return stories[initialIndex].title;
  }

  late AnimationController animationController;

  void init({
    required List<CategoryModel> storyList,
    required int index,
    required TickerProvider ticker,
  }) {
    stories = storyList;
    initialIndex = index;
    pageController = PageController(initialPage: index);

    animationController = AnimationController(
      vsync: ticker,
      duration: const Duration(seconds: 5), // hikaye süresi
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (pageController.page!.toInt() < stories.length - 1) {
            nextStory();
          } else {
            onLastStoryCompleted?.call();
          }
        }
      });

    checkIfImageCachedAndHandle(stories[index].imageUrl, true);
  }

  void startProgress() {
    animationController.forward(from: 0.0);
  }

  void pauseProgress() {
    animationController.stop();
  }

  void resumeProgress() {
    animationController.forward();
  }

  void resetProgress() {
    animationController.reset();
  }

  void toggleUI(bool value) {
    showUI = value;
    notifyListeners();
  }

  void previousStory() {
    if (pageController.page!.toInt() > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      /*pauseProgress();
      checkIfImageCachedAndHandle(stories[initialIndex - 1].imageUrl, true);*/
    }
  }

  void nextStory() {
    if (pageController.page!.toInt() < stories.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      /* pauseProgress();
      checkIfImageCachedAndHandle(stories[initialIndex + 1].imageUrl, true);*/
    } else {
      onLastStoryCompleted?.call();
    }
  }

  void checkIfImageCachedAndHandle(String imageUrl, bool sifirla) {
    final imageProvider = NetworkImage(imageUrl);
    final ImageStream stream =
        imageProvider.resolve(const ImageConfiguration());

    late final ImageStreamListener listener;
    if (sifirla) {
      listener = ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          print("✅ Resim cache’deydi veya yüklendi");
          resetProgress();
          startProgress();
          stream.removeListener(listener);
        },
        onError: (dynamic error, StackTrace? stackTrace) {
          print("❌ Resim yüklenemedi: $error");
          resetProgress();
          pauseProgress();
          stream.removeListener(listener);
        },
      );
    } else {
      listener = ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          print("✅ Resim cache’deydi veya yüklendi");
          startProgress();
          stream.removeListener(listener);
        },
        onError: (dynamic error, StackTrace? stackTrace) {
          print("❌ Resim yüklenemedi: $error");
          pauseProgress();
          stream.removeListener(listener);
        },
      );
    }

    stream.addListener(listener);
  }

  VoidCallback? onLastStoryCompleted;

  void disposeController() {
    timer?.cancel();
    pageController.dispose();
  }
}
