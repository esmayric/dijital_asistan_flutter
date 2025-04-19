import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentService {
  static const String baseUrl = 'http://localhost:7293/api/RandevuTakip';

  // Randevuları almak için
  static Future<List<Map<String, dynamic>>> getAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      print("Kullanıcı ID'si bulunamadı.");
      return [];
    }

    final response = await http.get(Uri.parse('$baseUrl/$userId/randevular'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      print("Randevular alınamadı!");
      print("Hata Kodu: ${response.statusCode}");
      print("Mesaj: ${response.body}");
      throw Exception('Randevular alınamadı: ${response.statusCode}');
    }
  }

  // Randevu eklemek için
  static Future<bool> addAppointment(int userId, String date, String time, String doctor, String note) async {
    // Token'ı SharedPreferences'tan alıyoruz
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Token bulunamadı!");
      return false;
    }

    final response = await http.post(
      Uri.parse('http://localhost:7293/api/RandevuTakip/ekle'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Token'ı Authorization header'a ekliyoruz
      },
      body: jsonEncode({
        'randevuTarihi': date, // Tarih formatı: 2025-04-19T20:06:42.917Z
        'randevuSaati': time,  // Saat formatı: 14:24:00
        'doktorAdi': doctor,   // Doktor adı
        'notlar': note,        // Notlar
      }),
    );

    if (response.statusCode == 200) {
      print("Randevu başarıyla eklendi.");
      return true;
    } else {
      print("Randevu eklenemedi! Hata Kodu: ${response.statusCode}");
      print("Mesaj: ${response.body}");
      return false;
    }
  }
  // Randevu silmek için
// Randevu silmek için
static Future<bool> deleteAppointment(int randevuId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Token bulunamadı!");
      return false;
    }

    // API URL'sini randevuId ile birlikte oluşturuyoruz
    final url = Uri.parse('$baseUrl/$randevuId'); // randevuId'yi URL'de kullanıyoruz

    // HTTP DELETE isteği gönderiyoruz
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Authorization header'a token ekliyoruz
      },
    );

    // HTTP yanıtına göre işlem yapıyoruz
    if (response.statusCode == 200) {
      print("Randevu başarıyla silindi.");
      return true;
    } else {
      print("Randevu silinemedi!");
      print("Hata Kodu: ${response.statusCode}");
      print("Mesaj: ${response.body}");
      return false;
    }
  } catch (e) {
    // Hata durumunu yakalıyoruz
    print("Beklenmeyen bir hata oluştu: $e");
    return false;
  }
}
}