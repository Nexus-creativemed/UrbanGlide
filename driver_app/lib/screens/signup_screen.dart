import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/driver_auth_provider.dart';
import 'home_screen.dart';

class DriverSignupScreen extends StatefulWidget {
  const DriverSignupScreen({super.key});

  @override
  State<DriverSignupScreen> createState() => _DriverSignupScreenState();
}

class _DriverSignupScreenState extends State<DriverSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _vehicleModelController.dispose();
    _vehicleNumberController.dispose();
    _licenseNumberController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (value.length < 10) return 'Enter a valid phone number';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final authProvider = Provider.of<DriverAuthProvider>(context, listen: false);

    final success = await authProvider.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      vehicleModel: _vehicleModelController.text.trim(),
      vehicleNumber: _vehicleNumberController.text.trim().toUpperCase(),
      licenseNumber: _licenseNumberController.text.trim().toUpperCase(),
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DriverHomeScreen()),
      );
    } else if (mounted && authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A1628), Color(0xFF1A2742)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'URBAN GLIDE',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00D9FF),
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'DRIVER REGISTRATION',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Personal Information
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: _validatePhone,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      obscureText: _obscurePassword,
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      obscureText: _obscureConfirmPassword,
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'VEHICLE INFORMATION',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00D9FF),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _vehicleModelController,
                      decoration: InputDecoration(
                        labelText: 'Vehicle Model',
                        prefixIcon: const Icon(Icons.directions_car),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Vehicle model is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _vehicleNumberController,
                      decoration: InputDecoration(
                        labelText: 'Vehicle Registration Number',
                        prefixIcon: const Icon(Icons.confirmation_number),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) => value == null || value.isEmpty ? 'Registration number is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _licenseNumberController,
                      decoration: InputDecoration(
                        labelText: 'Driver License Number',
                        prefixIcon: const Icon(Icons.badge),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) => value == null || value.isEmpty ? 'License number is required' : null,
                    ),
                    const SizedBox(height: 32),
                    Consumer<DriverAuthProvider>(
                      builder: (context, authProvider, child) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading ? null : _signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00D9FF),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: authProvider.isLoading
                                ? const CircularProgressIndicator(color: Colors.black)
                                : const Text(
                                    'CREATE ACCOUNT',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Already have an account? Sign In',
                        style: TextStyle(color: Color(0xFF00D9FF)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
