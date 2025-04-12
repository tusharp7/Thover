import 'package:flutter/material.dart';
import 'signup_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Login (Not implemented)'),
              onPressed: () {}, // Placeholder
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Sign Up'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'signup_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Login (Not implemented)'),
              onPressed: () {}, // Placeholder
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Sign Up'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
