import 'package:flutter/material.dart';
import 'package:rota_erzincan/init/navigation/navigation_service.dart';


mixin BaseViewModel {
  late BuildContext buildContext;

  NavigationService navigationService = NavigationService.instance;

  void setContext(BuildContext context) {
    buildContext = context;
  }
}
