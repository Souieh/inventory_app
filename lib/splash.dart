import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 🎨 يمكنك تغيير الخلفية
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            // 🖼️ الشعار (استبدل بـ AssetImage لو عندك لوجو)
            CircleAvatar(
              maxRadius: 12,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
            // 🏷️ العنوان
            Text(
              'Inventory App',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
