import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'welcome_page.dart';

class OtpPage extends StatefulWidget {
  final String name, userId, phone, password;

  const OtpPage({super.key, required this.name, required this.userId, required this.phone, required this.password});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpController = TextEditingController();

  Future<void> verifyOtp() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': widget.name,
        'userId': widget.userId,
        'phone': widget.phone,
        'password': widget.password,
        'otp': _otpController.text.trim(),
      }),
    );

    final res = jsonDecode(response.body);
    if (res['success']) {
      Fluttertoast.showToast(msg: "Registered!");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => WelcomePage(name: widget.name)),
        (_) => false,
      );
    } else {
      Fluttertoast.showToast(msg: "Invalid OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter OTP'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: verifyOtp,
              child: const Text("Verify & Register"),
            ),
          ],
        ),
      ),
    );
  }
}
