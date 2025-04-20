class RouteStop {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  double? distanceFromUser; // ✅ Geçici, sonradan ViewModel hesaplayacak
  RouteStop({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });
}
