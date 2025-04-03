import 'package:flutter/material.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';

class HomePageViewModel extends ChangeNotifier with BaseViewModel {
  void navigateToDetails(BuildContext context) {
    navigationService.navigateToPage("/details", null);
  }
}
