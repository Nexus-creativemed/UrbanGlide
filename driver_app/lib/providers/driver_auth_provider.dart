import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/driver_model.dart';

class DriverAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DriverModel? _currentDriver;
  bool _isLoading = false;
  String? _errorMessage;

  DriverModel? get currentDriver => _currentDriver;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentDriver != null;

  DriverAuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _loadDriverData(user.uid);
      } else {
        _currentDriver = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadDriverData(String uid) async {
    try {
      final doc = await _firestore.collection('drivers').doc(uid).get();
      if (doc.exists) {
        _currentDriver = DriverModel.fromJson(doc.data()!, doc.id);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to load driver data: $e';
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _loadDriverData(credential.user!.uid);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String vehicleModel,
    required String vehicleNumber,
    required String licenseNumber,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final driver = DriverModel(
          id: credential.user!.uid,
          name: name,
          email: email,
          phone: phone,
          vehicleModel: vehicleModel,
          vehicleNumber: vehicleNumber,
          licenseNumber: licenseNumber,
          isAvailable: false,
          isVerified: false,
        );

        await _firestore.collection('drivers').doc(credential.user!.uid).set(driver.toJson());

        _currentDriver = driver;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      if (_currentDriver != null) {
        // Set availability to false before signing out
        await _firestore.collection('drivers').doc(_currentDriver!.id).update({
          'isAvailable': false,
        });
      }
      await _auth.signOut();
      _currentDriver = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to sign out: $e';
      notifyListeners();
    }
  }

  Future<void> toggleAvailability() async {
    if (_currentDriver == null) return;

    try {
      final newAvailability = !_currentDriver!.isAvailable;

      await _firestore.collection('drivers').doc(_currentDriver!.id).update({
        'isAvailable': newAvailability,
      });

      _currentDriver = _currentDriver!.copyWith(isAvailable: newAvailability);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update availability: $e';
      notifyListeners();
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No driver account found with this email';
        case 'wrong-password':
          return 'Incorrect password';
        case 'email-already-in-use':
          return 'An account already exists with this email';
        case 'weak-password':
          return 'Password should be at least 6 characters';
        case 'invalid-email':
          return 'Invalid email address';
        default:
          return 'Authentication error: ${error.message}';
      }
    }
    return error.toString();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
