import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart'; // MyHomePage'e geçmek için

class SplashLogoPage extends StatefulWidget {
  @override
  _SplashLogoPageState createState() => _SplashLogoPageState();
}

class _SplashLogoPageState extends State<SplashLogoPage> {
  @override
  void initState() {
    super.initState();

    // 2 saniye sonra ana sayfaya geç
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arka plan beyaz
      body: Center(
        child: Image.asset(
          'assets/logo.png', // 👈 Logonu assets klasörüne koymayı unutma
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}