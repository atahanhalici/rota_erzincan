import 'package:flutter/material.dart';

class FullscreenGalleryViewModel extends ChangeNotifier {
  late PageController _pageController;
  int _currentPageIndex;

  FullscreenGalleryViewModel(int initialIndex)
      : _currentPageIndex = initialIndex {
    _pageController = PageController(initialPage: initialIndex)
      ..addListener(_onPageChanged);
  }

  PageController get pageController => _pageController;
  int get currentPageIndex => _currentPageIndex;

  void _onPageChanged() {
    final page = _pageController.page?.round() ?? 0;
    if (_currentPageIndex != page) {
      _currentPageIndex = page;
      notifyListeners();
    }
  }

  void goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }
}