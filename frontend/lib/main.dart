import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(home: TwilioOTP()));

class TwilioOTP extends StatefulWidget {
  @override
  State<TwilioOTP> createState() => _TwilioOTPState();
}

class _TwilioOTPState extends State<TwilioOTP> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  String message = "";

  final String baseUrl = "http://172.20.10.3:3000";  // Your local Node.js backend IP

  Future<void> sendOTP() async {
    final response = await http.post(
      Uri.parse("$baseUrl/send-otp"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"phone": phoneController.text}),
    );

    final data = jsonDecode(response.body);
    setState(() {
      message = data['message'];
    });
  }

  Future<void> verifyOTP() async {
    final response = await http.post(
      Uri.parse("$baseUrl/verify-otp"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "phone": phoneController.text,
        "otp": otpController.text,
      }),
    );

    final data = jsonDecode(response.body);
    setState(() {
      message = data['message'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Twilio OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Enter phone number (+91...)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: sendOTP,
              child: Text("Send OTP"),
            ),
            SizedBox(height: 12),
            TextField(
              controller: otpController,
              decoration: InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: verifyOTP,
              child: Text("Verify OTP"),
            ),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
