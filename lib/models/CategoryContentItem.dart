class CategoryContentItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double? latitude;
  final double? longitude;
  double? distanceFromUser;

  // ✅ Yeni eklenen alanlar
  final String? category;
  final List<String>? extraImages; // çoklu URL string listesi
  final Map<String, String>? hours; // ör: { monday: "09:00-18:00", ... }
  final String? shortAddress;
  final double? rating; // ör: 4.5

  CategoryContentItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.latitude,
    this.longitude,
    this.distanceFromUser,
    this.category,
    this.extraImages,
    this.hours,
    this.shortAddress,
    this.rating,
  });
}
