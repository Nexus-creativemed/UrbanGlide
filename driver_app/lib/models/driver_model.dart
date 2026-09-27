import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String vehicleModel;
  final String vehicleNumber;
  final String licenseNumber;
  final double rating;
  final int totalRides;
  final double earnings;
  final bool isAvailable;
  final bool isVerified;
  final GeoPoint? currentLocation;
  final DateTime? lastUpdated;
  final String? fcmToken;

  DriverModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.vehicleModel,
    required this.vehicleNumber,
    required this.licenseNumber,
    this.rating = 5.0,
    this.totalRides = 0,
    this.earnings = 0.0,
    this.isAvailable = false,
    this.isVerified = false,
    this.currentLocation,
    this.lastUpdated,
    this.fcmToken,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json, String id) {
    return DriverModel(
      id: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      vehicleModel: json['vehicleModel'] ?? '',
      vehicleNumber: json['vehicleNumber'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      rating: (json['rating'] ?? 5.0).toDouble(),
      totalRides: json['totalRides'] ?? 0,
      earnings: (json['earnings'] ?? 0.0).toDouble(),
      isAvailable: json['isAvailable'] ?? false,
      isVerified: json['isVerified'] ?? false,
      currentLocation: json['currentLocation'],
      lastUpdated: json['lastUpdated'] != null ? (json['lastUpdated'] as Timestamp).toDate() : null,
      fcmToken: json['fcmToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'vehicleModel': vehicleModel,
      'vehicleNumber': vehicleNumber,
      'licenseNumber': licenseNumber,
      'rating': rating,
      'totalRides': totalRides,
      'earnings': earnings,
      'isAvailable': isAvailable,
      'isVerified': isVerified,
      'currentLocation': currentLocation,
      'lastUpdated': lastUpdated != null ? Timestamp.fromDate(lastUpdated!) : null,
      'fcmToken': fcmToken,
    };
  }

  DriverModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? vehicleModel,
    String? vehicleNumber,
    String? licenseNumber,
    double? rating,
    int? totalRides,
    double? earnings,
    bool? isAvailable,
    bool? isVerified,
    GeoPoint? currentLocation,
    DateTime? lastUpdated,
    String? fcmToken,
  }) {
    return DriverModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      rating: rating ?? this.rating,
      totalRides: totalRides ?? this.totalRides,
      earnings: earnings ?? this.earnings,
      isAvailable: isAvailable ?? this.isAvailable,
      isVerified: isVerified ?? this.isVerified,
      currentLocation: currentLocation ?? this.currentLocation,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
