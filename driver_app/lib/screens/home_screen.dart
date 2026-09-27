import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ride_model.dart';
import '../providers/driver_auth_provider.dart';
import '../providers/driver_location_provider.dart';
import '../providers/driver_ride_provider.dart';
import 'login_screen.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<DriverAuthProvider>(context, listen: false);
    final rideProvider = Provider.of<DriverRideProvider>(context, listen: false);

    if (authProvider.currentDriver != null) {
      rideProvider.listenToPendingRides(authProvider.currentDriver!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('URBAN GLIDE DRIVER'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authProvider = Provider.of<DriverAuthProvider>(context, listen: false);
              await authProvider.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const DriverLoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Consumer3<DriverAuthProvider, DriverRideProvider, DriverLocationProvider>(
        builder: (context, authProvider, rideProvider, locationProvider, child) {
          final driver = authProvider.currentDriver;
          if (driver == null) return const Center(child: Text('Loading...'));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Driver Status Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  driver.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00D9FF),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text('${driver.vehicleModel} - ${driver.vehicleNumber}'),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                    Text(' ${driver.rating.toStringAsFixed(1)}'),
                                    const SizedBox(width: 16),
                                    Text('${driver.totalRides} rides'),
                                  ],
                                ),
                              ],
                            ),
                            Switch(
                              value: driver.isAvailable,
                              activeColor: const Color(0xFF00D9FF),
                              onChanged: (value) async {
                                await authProvider.toggleAvailability();
                                if (value) {
                                  locationProvider.startTracking(driver.id);
                                } else {
                                  locationProvider.stopTracking();
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          driver.isAvailable ? 'AVAILABLE FOR RIDES' : 'OFFLINE',
                          style: TextStyle(
                            color: driver.isAvailable ? Colors.green : Colors.grey,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Active Ride or Pending Rides
                if (rideProvider.activeRide != null) ...[
                  const Text(
                    'ACTIVE RIDE',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00D9FF),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildRideCard(rideProvider.activeRide!, driver.id, isActive: true),
                ] else ...[
                  const Text(
                    'AVAILABLE RIDES',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00D9FF),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (rideProvider.pendingRides.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(
                          child: Text(
                            'No rides available\nTurn on availability to receive ride requests',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                      ),
                    )
                  else
                    ...rideProvider.pendingRides.map((ride) => _buildRideCard(ride, driver.id)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRideCard(RideModel ride, String driverId, {bool isActive = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R${ride.fare.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00D9FF),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(ride.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ride.status.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(ride.pickupAddress)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.flag, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(ride.dropoffAddress)),
              ],
            ),
            const SizedBox(height: 16),
            if (isActive) _buildActiveRideButtons(ride, driverId) else _buildAcceptButton(ride, driverId),
          ],
        ),
      ),
    );
  }

  Widget _buildAcceptButton(RideModel ride, String driverId) {
    return Consumer2<DriverAuthProvider, DriverRideProvider>(
      builder: (context, authProvider, rideProvider, child) {
        return ElevatedButton(
          onPressed: rideProvider.isLoading
              ? null
              : () async {
                  final success = await rideProvider.acceptRide(
                    ride.id,
                    driverId,
                    authProvider.currentDriver!.name,
                    authProvider.currentDriver!.vehicleNumber,
                  );
                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ride accepted!')),
                    );
                  }
                },
          child: rideProvider.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('ACCEPT RIDE'),
        );
      },
    );
  }

  Widget _buildActiveRideButtons(RideModel ride, String driverId) {
    return Consumer<DriverRideProvider>(
      builder: (context, rideProvider, child) {
        String nextStatus = '';
        String buttonText = '';

        switch (ride.status) {
          case 'accepted':
            nextStatus = 'pickup';
            buttonText = 'ARRIVED AT PICKUP';
            break;
          case 'pickup':
            nextStatus = 'in_progress';
            buttonText = 'START RIDE';
            break;
          case 'in_progress':
            nextStatus = 'completed';
            buttonText = 'COMPLETE RIDE';
            break;
        }

        return ElevatedButton(
          onPressed: rideProvider.isLoading
              ? null
              : () async {
                  final success = await rideProvider.updateRideStatus(ride.id, nextStatus);
                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ride status updated to $nextStatus')),
                    );
                  }
                },
          child: rideProvider.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(buttonText),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'searching':
        return Colors.blue;
      case 'accepted':
        return Colors.orange;
      case 'pickup':
        return Colors.purple;
      case 'in_progress':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
