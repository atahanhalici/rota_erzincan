class FeatureModel {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String iconName;
  final int id;

  FeatureModel({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.iconName,
    required this.id,
  });

  // JSON'dan nesneye dönüştürme
  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      title: json["title"],
      subtitle: json["subtitle"],
      imageUrl: json["imageUrl"],
      id: json["id"],
      iconName:
          json["icon"], // Direkt icon objesi döndüğümüz için map'e gerek yok
    );
  }

  @override
  String toString() {
    return 'FeatureModel(id: $id, title: $title, subtitle: $subtitle, '
        'imageUrl: $imageUrl, iconName: $iconName)';
  }
}
