import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'otp_verification_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _userIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String formatPhoneNumber(String phone) {
    // Remove any non-digit characters
    String digits = phone.replaceAll(RegExp(r'\D'), '');
    
    // For India numbers, add country code if not present
    if (!digits.startsWith('91')) {
      digits = '91' + digits;
    }
    
    // Ensure the number starts with '+'
    return digits.startsWith('+') ? digits : '+' + digits;
  }

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      try {
        final formattedPhone = formatPhoneNumber(_phoneController.text);
        print('Formatted phone number: $formattedPhone'); // Debug log
        
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/api/auth/send-otp'), // Updated URL for Android emulator
          // Use 'http://localhost:3000/api/auth/send-otp' for iOS simulator
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'phoneNumber': formattedPhone,
          }),
        );

        print('Response status: ${response.statusCode}'); // Debug log
        print('Response body: ${response.body}'); // Debug log

        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          if (mounted) {
            Fluttertoast.showToast(msg: "OTP sent successfully!");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPVerificationPage(
                  username: _usernameController.text,
                  userId: _userIdController.text,
                  password: _passwordController.text,
                  phoneNumber: formattedPhone,
                ),
              ),
            );
          }
        } else {
          Fluttertoast.showToast(msg: data['message'] ?? "Failed to send OTP");
        }
      } catch (e) {
        print('Error during signup: $e'); // Debug log
        Fluttertoast.showToast(msg: "Error: Failed to connect to server");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(
                  labelText: 'User ID',
                  hintText: 'Enter a unique user ID',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a user ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your 10-digit phone number',
                  prefixText: '+91 ', // Add country code prefix
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  if (value.length != 10) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleSignup,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
