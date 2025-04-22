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
    // Token'ı SharedPreferences'den al
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');  // Token burada alınacak

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
      appBar: AppBar(
        title: Text("Profilim"),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userData == null
              ? Center(child: Text("Kullanıcı bilgisi alınamadı."))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileItem("Ad", userData!["ad"]),
                      _buildProfileItem("Soyad", userData!["soyad"]),
                      _buildProfileItem("E-posta", userData!["eposta"]),
                      _buildProfileItem("Telefon", userData!["telefonNumarasi"]),
                      _buildProfileItem("Yaş", userData!["yas"].toString()),
                      _buildProfileItem("Cinsiyet", userData!["cinsiyet"]),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
    );
  }
}
