import 'package:flutter/material.dart';

class IconUtils {
  /// String → IconData
  static IconData fromName(String? name) {
    switch (name) {
      case 'museum':
        return Icons.museum;
      case 'restaurant':
        return Icons.restaurant;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'location_city':
        return Icons.location_city;
      case 'church':
        return Icons.church;
      case 'factory':
        return Icons.factory;
      case 'hotel':
        return Icons.hotel;
      case 'fort':
        return Icons.fort;
      case 'movie':
        return Icons.movie;
      case 'architecture':
        return Icons.account_balance; // fallback
      case 'brush':
        return Icons.brush;
      case 'handyman':
        return Icons.handyman;
      case 'park':
        return Icons.park;
      case 'book':
        return Icons.book;
      case 'directions_bus':
        return Icons.directions_bus;
      case 'emoji_transportation':
        return Icons.emoji_transportation;
      case 'restaurant_menu':
        return Icons.restaurant_menu;
      case 'sports':
        return Icons.sports;
      case 'event':
        return Icons.event;
      case 'place':
        return Icons.place;
      case 'star':
        return Icons.star;
      default:
        return Icons.help_outline;
    }
  }

  /// IconData → String (ters mapping, gerekirse backend'e göndermek için)
  static String toName(IconData icon) {
    if (icon == Icons.museum) return 'museum';
    if (icon == Icons.restaurant) return 'restaurant';
    if (icon == Icons.sports_soccer) return 'sports_soccer';
    if (icon == Icons.location_city) return 'location_city';
    if (icon == Icons.church) return 'church';
    if (icon == Icons.factory) return 'factory';
    if (icon == Icons.hotel) return 'hotel';
    if (icon == Icons.fort) return 'fort';
    if (icon == Icons.movie) return 'movie';
    if (icon == Icons.account_balance) return 'architecture';
    if (icon == Icons.brush) return 'brush';
    if (icon == Icons.handyman) return 'handyman';
    if (icon == Icons.park) return 'park';
    if (icon == Icons.book) return 'book';
    if (icon == Icons.directions_bus) return 'directions_bus';
    if (icon == Icons.emoji_transportation) return 'emoji_transportation';
    if (icon == Icons.restaurant_menu) return 'restaurant_menu';
    if (icon == Icons.sports) return 'sports';
    if (icon == Icons.event) return 'event';
    if (icon == Icons.place) return 'place';
    if (icon == Icons.star) return 'star';
    return 'help_outline';
  }
}
