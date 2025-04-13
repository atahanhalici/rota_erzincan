class PhotoModel {
  final String title;
  final String url;

  PhotoModel({required this.title, required this.url});

  factory PhotoModel.fromMap(Map<String, String> map) {
    return PhotoModel(
      title: map['title'] ?? '',
      url: map['url'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'title': title,
      'url': url,
    };
  }

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'url': url,
      };
}
