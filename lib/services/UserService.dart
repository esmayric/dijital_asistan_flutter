import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static Future<Map<String, dynamic>?> getUserProfile(int userId, String token) async {
    // 🔗 Backend adresin doğruysa, süper. Ama mobilde "localhost" yerine genelde IP kullanılır
    final url = Uri.parse("http://localhost:7293/api/Kullanici/profile");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Token burada ekleniyor
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Kullanıcı bilgisi alınamadı: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Bir hata oluştu: $e");
      return null;
    }
  }
}
