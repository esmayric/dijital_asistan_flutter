import 'package:flutter/material.dart';

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
            const SizedBox(height: 50), // Üstte boşluk bırakıyor
            Center(
              child: Column(
                children: [
                  Image.asset(
                    "assets/logo.png", // Logo
                    height: 80,  // Boyutu ayarlayabilirsin
                  ),
                  const SizedBox(height: 10), // Logo ile başlık arasında boşluk
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
            const SizedBox(height: 20), // Başlık ile arama çubuğu arasında boşluk
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
                  healthButton("KAN DEGERLERI", Colors.red[300], Icons.bloodtype),
                  healthButton("KALP DEGERLERI", Colors.pink[300], Icons.favorite),
                  healthButton("SEKER DEGERLERI", Colors.lightGreen[400], Icons.medical_services),
                  healthButton("TANSIYON DEGERLERI", Colors.yellow[600], Icons.monitor_heart),
                  healthButton("TAHIL SONUCLARI", Colors.orange[300], Icons.assignment),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget healthButton(String text, Color? color, IconData icon) {
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
        onPressed: () {},
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