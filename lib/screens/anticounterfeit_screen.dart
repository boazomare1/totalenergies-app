import 'package:flutter/material.dart';

class AnticounterfeitScreen extends StatelessWidget {
  const AnticounterfeitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE60012),
        elevation: 0,
        title: const Text(
          'Anticounterfeit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_user_outlined,
              size: 100,
              color: Color(0xFFE60012),
            ),
            SizedBox(height: 20),
            Text(
              'Anticounterfeit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE60012),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Verify product authenticity',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
