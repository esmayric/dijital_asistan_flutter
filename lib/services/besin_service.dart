import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BesinService {
  static const String baseUrl = 'http://localhost:7293/api/Besin';

  /// Öneri al ve kaydet işlemi
  static Future<Map<String, dynamic>?> oneriAlVeKaydet({
    required int userId,
    required int kalori,
    required String kategori,
    required int karbonhidrat,
    required int protein,
    required int yag,
    required String rahatsizlik,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("❌ Token bulunamadı!");
        return null;
      }

      final url = Uri.parse('$baseUrl/oneri-al-kaydet');

      final Map<String, dynamic> data = {
        'userId': userId,
        'kalori': kalori,
        'kategori': kategori,
        'karbonhidrat': karbonhidrat,
        'protein': protein,
        'yag': yag,
        'rahatsizlik': rahatsizlik,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Öneri alınamadı. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Hata oluştu: $e');
      return null;
    }
  }
}