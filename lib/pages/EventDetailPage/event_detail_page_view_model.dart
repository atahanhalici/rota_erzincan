// lib/viewmodels/event_detail_view_model.dart

import 'package:easy_localization/easy_localization.dart';
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

  Future<void> fetchData(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // sahte API
    final lang = context.locale.languageCode;

    if (eventType == 'movie') {
      items = lang == 'tr'
          ? [
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
            ]
          : [
              MovieItem(
                title: 'Dune: Desert Planet',
                imageUrl: 'https://picsum.photos/seed/dune/200/300',
                cinema: 'Erzincan Mall Cinema',
                sessions: ['1:00 PM', '4:00 PM', '7:30 PM'],
              ),
              MovieItem(
                title: 'Godzilla x Kong',
                imageUrl: 'https://picsum.photos/seed/godzillakong/200/300',
                cinema: 'Erzincan Park Cinema',
                sessions: ['2:15 PM', '5:00 PM', '9:00 PM'],
              ),
            ];
    } else {
      items = lang == 'tr'
          ? [
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
            ]
          : [
              TheaterPlayItem(
                title: 'A Perfect Wedding',
                imageUrl: 'https://picsum.photos/seed/theater1/200/300',
                venue: 'Erzincan City Theater',
                date: 'April 25, 2025, 8:00 PM',
              ),
              TheaterPlayItem(
                title: 'Diary of a Madman',
                imageUrl: 'https://picsum.photos/seed/theater2/200/300',
                venue: 'Public Education Hall',
                date: 'April 28, 2025, 7:30 PM',
              ),
            ];
    }

    isLoading = false;
    notifyListeners();
  }
}
