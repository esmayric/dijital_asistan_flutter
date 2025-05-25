import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/DegerGiris.dart';
import 'package:flutter_application_1/IlacTakipPage.dart';
import 'package:flutter_application_1/besin_page.dart';
import 'package:flutter_application_1/TahlilSonuclari.dart';
import 'package:flutter_application_1/AppointmentScreen.dart';
import 'package:flutter_application_1/SignInPage.dart';
import 'package:flutter_application_1/InfiniteHealthHomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashLogoPage(), // Splash ekranı ile başlat
    );
  }
}

class SplashLogoPage extends StatefulWidget {
  @override
  _SplashLogoPageState createState() => _SplashLogoPageState();
}

class _SplashLogoPageState extends State<SplashLogoPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()), // 🔄 Giriş ekranına yönlendirme
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}