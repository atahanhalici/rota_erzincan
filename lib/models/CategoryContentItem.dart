class CategoryContentItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  double? distanceFromUser;
  CategoryContentItem(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.latitude,
      required this.longitude,
      this.distanceFromUser});
}
