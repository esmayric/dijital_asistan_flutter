import 'package:flutter/material.dart';
import 'AppointmentScreen.dart';
import 'DegerGiris.dart';
import 'TahlilSonuclari.dart';
import 'IlacTakipPage.dart';
import 'MakalePage.dart';

class InfiniteHealthHomePage extends StatelessWidget {
  final String userName;
  final int userId; // 💥 userId'yi ekliyoruz

  const InfiniteHealthHomePage({super.key, required this.userName, required this.userId});

  @override
  Widget build(BuildContext context) {
    print('InfiniteHealthHomePage userId: $userId');
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            // Üst Profil ve Logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF94D9C6),
                            width: 1,
                          ),
                        ),
                      ),
                      Container(
                        width: 85,
                        height: 85,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF59A7A7),
                            width: 1,
                          ),
                        ),
                      ),
                      const Positioned(
                        child: Center(
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/profile.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hoş geldiniz!', style: TextStyle(fontSize: 16)),
                      Text(
                        userName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Image.asset('assets/logo.png', width: 80),
            const Text(
              'INFINITE HEALTH',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5FB5B5)),
            ),
            const SizedBox(height: 8),
            Center(
              child: SizedBox(
                width: 450,
                child: const LinearProgressIndicator(
                  value: 3.0,
                  color: Color(0xFF5FB5B5),
                  backgroundColor: Colors.white,
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(height: 80),

            // Bilgilendirici Kutu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFBAC94A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 150),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 30),
                          Text(
                            'Doğru ve dengeli beslenmek, sağlığın korunması için önemlidir.',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: 3.0,
                            color: Color.fromARGB(255, 53, 53, 53),
                            backgroundColor: Colors.white,
                            minHeight: 2,
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Kendini Sev, Sağlıklı Beslen.',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Color.fromARGB(255, 29, 29, 29),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    left: -150,
                    child: Center(
                      child: Image.asset(
                        'assets/healthyFood.png',
                        width: 280,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MakalePage()),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.teal,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
  child: const Text(
    'Makaleyi Oku',
    style: TextStyle(
      fontSize: 18,
      color: Colors.white,
    ),
  ),
),

            // SU TAKİBİ & ADIMSAYAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SU TAKİBİ
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'SU TAKİBİ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color(0xFF9FC9E9),
                          ),
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 200,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xFF9FC9E9), Color(0xFF59A7A7)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Gün içinde ne kadar su içtiğini takip etmek sağlıklıdır.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const Text(
                                    'Hatırlatıcı bildirimleri açmayı unutma!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 10),
                                  LinearProgressIndicator(
                                    value: 0.5,
                                    minHeight: 8,
                                    backgroundColor: Colors.white.withOpacity(0.3),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: -30,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Image.asset(
                                  'assets/water.png',
                                  width: 280,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // ADIMSAYAR
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'ADIMSAYAR',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color(0xFFE2D46B),
                          ),
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 150,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xFFE2D46B), Color(0xFF59A7A7)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Column(
                                children: [
                                  Text(
                                    'Bugün',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    '4973',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'adım attınız.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(height: 10),
                                  LinearProgressIndicator(
                                    value: 0.65,
                                    minHeight: 8,
                                    backgroundColor: Colors.white30,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: -140,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Image.asset(
                                  'assets/footprint.png',
                                  width: 280,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: 450,
                child: const LinearProgressIndicator(
                  value: 3.0,
                  color: Color(0xFF5FB5B5),
                  backgroundColor: Colors.white,
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // BUTONLAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _menuButton('İLAÇ TAKİP', Icons.medical_services, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IlacTakipPage()),
                    );
                  }),
                  _menuButton('DEĞER GİRİŞ', Icons.bar_chart, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DegerGiris()),
                    );
                  }),
                  _menuButton('TAHLİL SONUÇLARI', Icons.list_alt, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TahlilSonuclari()),
                    );
                  }),
                  _menuButton('RANDEVU', Icons.calendar_month, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AppointmentScreen(userId: userId)),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(String title, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF5FB5B5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
      icon: Icon(icon, size: 28),
      label: Text(title, style: const TextStyle(fontSize: 18)),
    );
  }
}