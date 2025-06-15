import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/InfiniteHealthHomePage.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:permission_handler/permission_handler.dart';
import 'services/FallDetectionService.dart';
import 'SignInPage.dart';
import 'InfiniteHealthHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashLogoPage(), // örnek
    );
  }
}
void main() {
  runApp(MyApp());
}

class SplashLogoPage extends StatefulWidget {
  @override
  _SplashLogoPageState createState() => _SplashLogoPageState();
}

class _SplashLogoPageState extends State<SplashLogoPage> {
  FallDetectionService? _fallDetectionService;

  @override
  void initState() {
    super.initState();
     _requestNotificationPermission();
    // sadece logo göstermek için 2 saniye bekle ve giriş sayfasına git
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    });
  }
Future<void> _requestNotificationPermission() async {
  final status = await Permission.notification.request();
  if (status.isGranted) {
    print("İzin verildi.");
  } else {
    print("İzin reddedildi.");
  }
}
  Future<void> onLoginSuccess(int kullaniciId, String kullaniciEmail) async {
    _fallDetectionService = FallDetectionService(
      kullaniciId: kullaniciId,
      
    );

    await initBackgroundMode();
    await _fallDetectionService!.start();
    await _fallDetectionService!.showForegroundNotification();
  }

  Future<void> initBackgroundMode() async {
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "Düşme Algılama",
      notificationText: "Arka planda düşme algılama aktif.",
      notificationImportance: AndroidNotificationImportance.normal,
      notificationIcon: AndroidResource(name: 'ic_launcher', defType: 'mipmap'),
    );

    bool hasPermissions = await FlutterBackground.hasPermissions;
    if (!hasPermissions) {
      await Permission.activityRecognition.request();
      await Permission.locationAlways.request();
    }

    bool success = await FlutterBackground.initialize(androidConfig: androidConfig);
    if (success) {
      await FlutterBackground.enableBackgroundExecution();
    }
  }
  Future<void> checkIfLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  final kullaniciId = prefs.getInt('kullaniciId');
  final email = prefs.getString('kullaniciEmail');

  if (kullaniciId != null && email != null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => InfiniteHealthHomePage(userId: kullaniciId ,userName: email )),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }
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