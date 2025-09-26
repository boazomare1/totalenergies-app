import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE60012), // TotalEnergies Red
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/totalenergies_logo_white.png',
              height: 30,
              width: 30,
            ),
            const SizedBox(width: 12),
            const Text(
              'TotalEnergies',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 100, color: Color(0xFFE60012)),
            SizedBox(height: 20),
            Text(
              'Welcome to TotalEnergies',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE60012),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your energy partner for life',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
