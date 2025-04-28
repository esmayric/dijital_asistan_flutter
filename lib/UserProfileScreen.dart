import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/UserService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  final int userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final data = await UserService.getUserProfile(widget.userId, token);
      setState(() {
        userData = data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("Token bulunamadı.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userData == null
              ? Center(child: Text("Kullanıcı bilgisi alınamadı."))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Logo PNG
                      Image.asset(
                        'assets/logo.png',
                        height: 70,
                      ),
                      SizedBox(height: 20),
                      _buildSectionHeader("PROFİL"),
                      // Profil Fotoğrafı
                      CircleAvatar(
                        radius: 55,
                        backgroundImage: NetworkImage(
                          userData!["profilResmiUrl"] ??
                              "https://via.placeholder.com/150",
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "${userData!["ad"]} ${userData!["soyad"]}",
                        style:
                            TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Divider(height: 40, thickness: 1),

                      // Ad ve Soyad kutucukları
                      _buildProfileItem("Ad", userData!["ad"]),
                      _buildProfileItem("Soyad", userData!["soyad"]),

                      // Grup başlığı

                      _buildProfileItem("Telefon", userData!["telefonNumarasi"]),
                      _buildProfileItem("Yaş", userData!["yas"].toString()),

                      // Diğer Bilgiler
                      _buildProfileItem("E-posta", userData!["eposta"]),
                      _buildProfileItem("Cinsiyet", userData!["cinsiyet"]),
                      _buildProfileItem(
                          "Adres", userData!["adres"] ?? "Belirtilmemiş"),
                      SizedBox(height: 20),

                      // Kaydet Butonu
                      ElevatedButton(
                        onPressed: () {
                          // Kaydetme işlemi
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFA3D9C9),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 32),
                          elevation: 0,
                        ),
                        child: Text(
                          "Kaydet",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  // Bilgi kutusu widget'ı
  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              "$label: ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Grup başlığı widget'ı
 // Grup başlığı widget'ı
Widget _buildSectionHeader(String title) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(top: 20, bottom: 10),
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Text(
      title,
      textAlign: TextAlign.center, // Yazıyı ortala
      style: TextStyle(
        color: Color(0xFFA3D9C9), // Yazı rengi turkuaz
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
}