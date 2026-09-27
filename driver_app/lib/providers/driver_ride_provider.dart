import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/ride_model.dart';

class DriverRideProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<RideModel> _pendingRides = [];
  RideModel? _activeRide;
  List<RideModel> _rideHistory = [];
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription? _pendingRidesSubscription;
  StreamSubscription? _activeRideSubscription;

  List<RideModel> get pendingRides => _pendingRides;
  RideModel? get activeRide => _activeRide;
  List<RideModel> get rideHistory => _rideHistory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void listenToPendingRides(String driverId) {
    _pendingRidesSubscription?.cancel();

    // Listen to rides with status 'searching' (rides available for acceptance)
    _pendingRidesSubscription = _firestore
        .collection('rides')
        .where('status', isEqualTo: 'searching')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .listen((snapshot) {
      _pendingRides = snapshot.docs.map((doc) => RideModel.fromJson(doc.data(), doc.id)).toList();
      notifyListeners();
    });

    // Also listen to active ride for this driver
    _listenToActiveRide(driverId);
  }

  void _listenToActiveRide(String driverId) {
    _activeRideSubscription?.cancel();

    _activeRideSubscription = _firestore
        .collection('rides')
        .where('driverId', isEqualTo: driverId)
        .where('status', whereIn: ['accepted', 'pickup', 'in_progress'])
        .limit(1)
        .snapshots()
        .listen((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            _activeRide = RideModel.fromJson(
              snapshot.docs.first.data(),
              snapshot.docs.first.id,
            );
          } else {
            _activeRide = null;
          }
          notifyListeners();
        });
  }

  Future<bool> acceptRide(String rideId, String driverId, String driverName, String vehicleNumber) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.collection('rides').doc(rideId).update({
        'driverId': driverId,
        'driverName': driverName,
        'vehicleNumber': vehicleNumber,
        'status': 'accepted',
        'acceptedAt': FieldValue.serverTimestamp(),
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to accept ride: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateRideStatus(String rideId, String newStatus) async {
    try {
      _isLoading = true;
      notifyListeners();

      final updateData = <String, dynamic>{
        'status': newStatus,
      };

      if (newStatus == 'completed') {
        updateData['completedAt'] = FieldValue.serverTimestamp();
      }

      await _firestore.collection('rides').doc(rideId).update(updateData);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to update ride status: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadRideHistory(String driverId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection('rides')
          .where('driverId', isEqualTo: driverId)
          .where('status', isEqualTo: 'completed')
          .orderBy('completedAt', descending: true)
          .limit(20)
          .get();

      _rideHistory = snapshot.docs.map((doc) => RideModel.fromJson(doc.data(), doc.id)).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load ride history: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _pendingRidesSubscription?.cancel();
    _activeRideSubscription?.cancel();
    super.dispose();
  }
}
