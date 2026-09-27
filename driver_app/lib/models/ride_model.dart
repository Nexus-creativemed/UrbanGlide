import 'package:cloud_firestore/cloud_firestore.dart';

class RideModel {
  final String id;
  final String passengerId;
  final String? driverId;
  final String status; // searching, accepted, pickup, in_progress, completed, cancelled
  final GeoPoint pickupLocation;
  final GeoPoint dropoffLocation;
  final String pickupAddress;
  final String dropoffAddress;
  final double fare;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final String? driverName;
  final String? vehicleNumber;
  final double? driverRating;
  final double? passengerRating;

  RideModel({
    required this.id,
    required this.passengerId,
    this.driverId,
    required this.status,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.fare,
    required this.createdAt,
    this.acceptedAt,
    this.completedAt,
    this.driverName,
    this.vehicleNumber,
    this.driverRating,
    this.passengerRating,
  });

  factory RideModel.fromJson(Map<String, dynamic> json, String id) {
    return RideModel(
      id: id,
      passengerId: json['passengerId'] ?? '',
      driverId: json['driverId'],
      status: json['status'] ?? 'searching',
      pickupLocation: json['pickupLocation'],
      dropoffLocation: json['dropoffLocation'],
      pickupAddress: json['pickupAddress'] ?? '',
      dropoffAddress: json['dropoffAddress'] ?? '',
      fare: (json['fare'] ?? 0.0).toDouble(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      acceptedAt: json['acceptedAt'] != null ? (json['acceptedAt'] as Timestamp).toDate() : null,
      completedAt: json['completedAt'] != null ? (json['completedAt'] as Timestamp).toDate() : null,
      driverName: json['driverName'],
      vehicleNumber: json['vehicleNumber'],
      driverRating: json['driverRating']?.toDouble(),
      passengerRating: json['passengerRating']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'passengerId': passengerId,
      'driverId': driverId,
      'status': status,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'pickupAddress': pickupAddress,
      'dropoffAddress': dropoffAddress,
      'fare': fare,
      'createdAt': Timestamp.fromDate(createdAt),
      'acceptedAt': acceptedAt != null ? Timestamp.fromDate(acceptedAt!) : null,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'driverName': driverName,
      'vehicleNumber': vehicleNumber,
      'driverRating': driverRating,
      'passengerRating': passengerRating,
    };
  }
}
