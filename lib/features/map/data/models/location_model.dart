import 'package:hive/hive.dart';

part 'location_model.g.dart';

@HiveType(typeId: 0)
class LocationModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final String address;
  @HiveField(4)
  final double lat;
  @HiveField(5)
  final double lng;
  @HiveField(6)
  final bool isActive;
  @HiveField(7)
  final List<String>? services;
  @HiveField(8)
  final String? phone;
  @HiveField(9)
  final String? workingHours;

  LocationModel({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.lat,
    required this.lng,
    required this.isActive,
    this.services,
    this.phone,
    this.workingHours,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    id: json['id'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    address: json['address'] as String,
    lat: (json['lat'] as num).toDouble(),
    lng: (json['lng'] as num).toDouble(),
    isActive: json['is_active'] as bool,
    services: json['services'] != null
        ? List<String>.from(json['services'])
        : null,
    phone: json['phone'] as String?,
    workingHours: json['working_hours'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'address': address,
    'lat': lat,
    'lng': lng,
    'is_active': isActive,
    'services': services,
    'phone': phone,
    'working_hours': workingHours,
  };
}
