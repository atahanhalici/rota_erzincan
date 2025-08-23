// lib/viewmodels/event_detail_view_model.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/MovieItem.dart';
import 'package:rota_erzincan/models/TheaterPlayItem.dart';
import 'package:rota_erzincan/services/api_service.dart';

class EventDetailViewModel extends ChangeNotifier with BaseViewModel {
  bool isLoading = false;
  List<dynamic> items = [];

  late String eventType;
  late String imageUrl;
  late String title;
  late String subtitle;
  late String id;

  void initialize(Map<String, dynamic> args) {
    eventType = args['eventType'];
    imageUrl = args['imageUrl'];
    title = args['title'];
    subtitle = args['subtitle'];
    id = args['id'];
  }

  void navigateToSearch() {
    navigationService.navigateToSearchPage();
  }

  Future<void> fetchData(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final lang = context.locale.languageCode;
      List<dynamic> allShows = [];

      if (lang == 'tr') {
        allShows = await ApiService().getShowsTr();
      } else if (lang == 'en') {
        allShows = await ApiService().getShowsEn();
      } else {
        allShows = await ApiService().getShowsPl();
      }

      // 👇 type filtreleme
      if (eventType == 'movie') {
        items = allShows.where((e) => e is MovieItem).toList();
      } else {
        items = allShows.where((e) => e is TheaterPlayItem).toList();
      }
    } catch (e) {
      items = [];
    }

    isLoading = false;
    notifyListeners();
  }
}
