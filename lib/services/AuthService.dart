import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:7293/api'; // Backend API URL
  static final http.Client client = http.Client();

  // 🔐 Giriş Yapma ve Token'ı Kaydetme
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'eposta': email,
          'sifre': password,
        }),
      );

      if (response.statusCode == 200) {
        // Başarılı giriş
        final responseData = json.decode(response.body);
        String token = responseData['token'];
        var userData = responseData['kullanici'];

        // 🎯 Token ve kullanıcı bilgilerini SharedPreferences'e kaydet
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('userId', userData['kullaniciId'].toString());
        await prefs.setString('userName', '${userData['ad']} ${userData['soyad']}');
        await prefs.setString('userEmail', userData['eposta']);

        print('Login başarılı, token: $token');
        return {
          'token': token,
          'user': userData,
        };
      } else {
        // Hata durumunda geri dön
        return {
          'error': 'Login failed with status code: ${response.statusCode}'
        };
      }
    } catch (e) {
      // Hata durumunda geri dön
      print('Login sırasında hata: $e');
      return {'error': 'Login error: $e'};
    }
  }

  // ✍️ Kayıt Olma
  static Future<Map<String, dynamic>> register({
    required String eposta,
    required String sifre,
    required String ad,
    required String soyad,
    required String telefon,
    required int yas,
    required String cinsiyet,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');

    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'eposta': eposta,
          'sifre': sifre,
          'ad': ad,
          'soyad': soyad,
          'telefonNumarasi': telefon,
          'yas': yas,
          'cinsiyet': cinsiyet,
        }),
      );

      if (response.statusCode == 200) {
        print('Kayıt başarılı: ${response.body}');
        return {'success': true};
      } else {
        print('Kayıt başarısız: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
          'error': 'Registration failed with status code: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Register sırasında hata: $e');
      return {'success': false, 'error': 'Register error: $e'};
    }
  }

  // 📥 SharedPreferences'ten Token'ı Al
  static Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // 📥 SharedPreferences'ten Kullanıcı Bilgilerini Al
  static Future<Map<String, String>?> getUserDataFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? userName = prefs.getString('userName');
    String? userEmail = prefs.getString('userEmail');

    // Eğer kullanıcı bilgileri mevcutsa, geri dön
    if (userId != null && userName != null && userEmail != null) {
      return {
        'userId': userId,
        'userName': userName,
        'userEmail': userEmail,
      };
    }
    return null;
  }

  // ❌ Çıkış Yap (Token ve Kullanıcı Bilgilerini Sil)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
  }

  // 📥 Kullanıcı ID'sini SharedPreferences'ten Al
  static Future<String?> getUserIdFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
}
