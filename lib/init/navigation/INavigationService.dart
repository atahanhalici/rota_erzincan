import 'package:flutter/material.dart';
import 'package:rota_erzincan/models/CategoryItem.dart';

abstract class INavigationService {
  void navigateToBack();
  Future<void> navigateToPage(String path, Object? object);
  Future<void> navigateToPageClear(String path, Object? object);

  // Route parametresini alacak şekilde updatePageOnBack fonksiyonunu tanımlıyoruz
  void updatePageOnBack(Route<dynamic> route);

  Future<void> navigateToCategoryDetail(CategoryItem item);
}
