import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class DriverLocationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Position? _currentPosition;
  bool _isTracking = false;
  String? _errorMessage;
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _backupTimer;

  Position? get currentPosition => _currentPosition;
  bool get isTracking => _isTracking;
  String? get errorMessage => _errorMessage;

  Future<bool> startTracking(String driverId) async {
    if (_isTracking) return true;

    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = 'Location permissions are denied';
          notifyListeners();
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _errorMessage = 'Location permissions are permanently denied';
        notifyListeners();
        return false;
      }

      // Start location tracking
      _isTracking = true;
      notifyListeners();

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      );

      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          _currentPosition = position;
          _updateLocationInFirestore(driverId, position);
          notifyListeners();
        },
        onError: (error) {
          _errorMessage = 'Location tracking error: $error';
          notifyListeners();
        },
      );

      // Backup timer to update location every 10 seconds
      _backupTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
        if (_isTracking) {
          try {
            final position = await Geolocator.getCurrentPosition();
            _currentPosition = position;
            _updateLocationInFirestore(driverId, position);
            notifyListeners();
          } catch (e) {
            // Ignore backup timer errors
          }
        }
      });

      return true;
    } catch (e) {
      _errorMessage = 'Failed to start location tracking: $e';
      _isTracking = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _updateLocationInFirestore(String driverId, Position position) async {
    try {
      await _firestore.collection('drivers').doc(driverId).update({
        'currentLocation': GeoPoint(position.latitude, position.longitude),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Silently fail to avoid spam
      debugPrint('Failed to update location in Firestore: $e');
    }
  }

  Future<void> stopTracking() async {
    await _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _backupTimer?.cancel();
    _backupTimer = null;
    _isTracking = false;
    _currentPosition = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}
