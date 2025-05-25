import 'dart:async';
import 'package:flutter/material.dart';

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
        MaterialPageRoute(builder: (context) => MyHomePage()), // Burada MyHomePage'e yönlendiriyorsun
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Logonun assets klasörüne koymayı unutma
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}

// MyHomePage widget'ı burada tanımlanıyor
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ana Sayfa')),
      body: Center(child: Text('Ana Sayfa İçeriği')),
    );
  }
}