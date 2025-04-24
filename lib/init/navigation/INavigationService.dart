import 'package:flutter/material.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/models/CategoryItem.dart';
import 'package:rota_erzincan/models/RouteItem.dart';

abstract class INavigationService {
  void navigateToBack();
  Future<void> navigateToPage(String path, Object? object);
  Future<void> navigateToPageClear(String path, Object? object);

  // Route parametresini alacak şekilde updatePageOnBack fonksiyonunu tanımlıyoruz
  void updatePageOnBack(Route<dynamic> route);

  Future<void> navigateToCategoryDetail(CategoryItem item);
  Future<void> navigateToCategoryDetailClear(CategoryItem item);
  Future<void> navigateToDetailsPage(CategoryContentItem item);
  Future<void> navigateToRouteDetailsPage(RouteItem item);
  Future<void> navigateToSearchPage();
}
