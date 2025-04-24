// lib/viewmodels/event_detail_view_model.dart

import 'package:flutter/material.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/models/MovieItem.dart';
import 'package:rota_erzincan/models/TheaterPlayItem.dart';

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
  Future<void> fetchData() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // sahte API

    if (eventType == 'movie') {
      items = [
        MovieItem(
          title: 'Dune: Çöl Gezegeni',
          imageUrl: 'https://picsum.photos/seed/dune/200/300',
          cinema: 'Erzincan AVM Sineması',
          sessions: ['13:00', '16:00', '19:30'],
        ),
        MovieItem(
          title: 'Godzilla x Kong',
          imageUrl: 'https://picsum.photos/seed/godzillakong/200/300',
          cinema: 'Erzincan Park Sineması',
          sessions: ['14:15', '17:00', '21:00'],
        ),
      ];
    } else {
      items = [
        TheaterPlayItem(
          title: 'Şahane Düğün',
          imageUrl: 'https://picsum.photos/seed/theater1/200/300',
          venue: 'Erzincan Şehir Tiyatrosu',
          date: '25 Nisan 2025, 20:00',
        ),
        TheaterPlayItem(
          title: 'Bir Delinin Hatıra Defteri',
          imageUrl: 'https://picsum.photos/seed/theater2/200/300',
          venue: 'Halk Eğitim Salonu',
          date: '28 Nisan 2025, 19:30',
        ),
      ];
    }

    isLoading = false;
    notifyListeners();
  }
}
