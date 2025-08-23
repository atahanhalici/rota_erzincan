import 'package:latlong2/latlong.dart';

class AssemblyPointModel {
  final String name;
  final LatLng point;
  final int capacity;
  final List<String> facilities;
  final String description;
  final String contact;

  AssemblyPointModel({
    required this.name,
    required this.point,
    required this.capacity,
    required this.facilities,
    required this.description,
    required this.contact,
  });

  factory AssemblyPointModel.fromJson(Map<String, dynamic> json) {
    return AssemblyPointModel(
      name: json['name'] ?? '',
      point: LatLng(
        (json['latitude'] as num).toDouble(),
        (json['longitude'] as num).toDouble(),
      ),
      capacity: json['capacity'] ?? 0,
      facilities: (json['facilities'] as List?)?.cast<String>() ?? [],
      description: json['description'] ?? '',
      contact: json['contact'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': point.latitude,
      'longitude': point.longitude,
      'capacity': capacity,
      'facilities': facilities,
      'description': description,
      'contact': contact,
    };
  }
}
