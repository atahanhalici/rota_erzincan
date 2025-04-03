import 'package:flutter/material.dart';
import 'package:rota_erzincan/init/navigation/navigation_service.dart';


class CustomNavigatorObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (!(route is PopupRoute)) {
      // Sayfa geri dönüşü olduğunda path'i güncelle
      if (previousRoute != null) {
        NavigationService.instance.updatePageOnBack(previousRoute);
      }
    }
  }
}

