import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/models/CategoryModel.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';

class StoryPageViewModel extends ChangeNotifier with BaseViewModel {
  late List<CategoryModel> stories;
  late int initialIndex;
  late PageController pageController;

  double progress = 0.0;
  Timer? timer;
  bool showUI = true;
  bool showHint = false;

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

  void navigateToDetails(BuildContext context) {
    navigationService.navigateToPage(
        "/details",
        CategoryContentItem(
          id: 'content_0',
          title: 'Terzibaba Camii ve Külliyesi 1',
          description:
              'Bu Terzibaba Camii ve Külliyesi 1 kategorisi için içerik 1 açıklamasıdır.',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc',
          latitude: 39.7531,
          longitude: 39.4985,
        ));
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
    showHint = false;
    notifyListeners();
    final imageProvider = NetworkImage(imageUrl);
    final ImageStream stream =
        imageProvider.resolve(const ImageConfiguration());

    late final ImageStreamListener listener;
    if (sifirla) {
      listener = ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          resetProgress();
          showHint = true;
          notifyListeners();
          startProgress();
          stream.removeListener(listener);
        },
        onError: (dynamic error, StackTrace? stackTrace) {
          resetProgress();
          pauseProgress();
          stream.removeListener(listener);
        },
      );
    } else {
      listener = ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          showHint = true;
          notifyListeners();
          startProgress();
          stream.removeListener(listener);
        },
        onError: (dynamic error, StackTrace? stackTrace) {
          pauseProgress();
          stream.removeListener(listener);
        },
      );
    }

    stream.addListener(listener);
  }

  VoidCallback? onLastStoryCompleted;

  void disposeController() {
    try {
      animationController.dispose();
    // ignore: empty_catches
    } catch (e) {}
    timer?.cancel();
    pageController.dispose();
  }
}
