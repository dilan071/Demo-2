// lib/models/location.dart
class Location {
  final int? id;
  final String name;
  final String? type;
  final String? dimension;

  Location({
    this.id,
    required this.name,
    this.type,
    this.dimension,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] != null ? json['id'] as int : null,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      dimension: json['dimension'] ?? '',
    );
  }
}
