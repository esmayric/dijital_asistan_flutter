import 'package:flutter/material.dart';
import 'package:flutter_application_1/TansiyonGirisEkrani.dart'; // Tansiyon giriş ekranını ekliyoruz

class DegerGiris extends StatelessWidget {
  const DegerGiris({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Center(
              child: Column(
                children: [
                  Image.asset(
                    "assets/logo.png",
                    height: 80,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "DEGER GIRIS",
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.teal),
                hintText: "Ara...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  healthButton(
                    "KAN DEGERLERI", 
                    Colors.red[300], 
                    Icons.bloodtype
                  ),
                  healthButton(
                    "KALP DEGERLERI", 
                    Colors.pink[300], 
                    Icons.favorite
                  ),
                  healthButton(
                    "SEKER DEGERLERI", 
                    Colors.lightGreen[400], 
                    Icons.medical_services
                  ),
                  healthButton(
                    "TANSIYON DEGERLERI", 
                    Colors.yellow[600], 
                    Icons.monitor_heart, 
                    context
                  ),
                  healthButton(
                    "TAHIL SONUCLARI", 
                    Colors.orange[300], 
                    Icons.assignment
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget healthButton(String text, Color? color, IconData icon, [BuildContext? context]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        ),
        onPressed: () {
          if (text == "TANSIYON DEGERLERI" && context != null) {
            // Tansiyon butonuna tıklanınca Tansiyon Giriş Ekranına geçiş
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TansiyonGirisEkrani()),
            );
          }
        },
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 50),
            SizedBox(width: 30),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
