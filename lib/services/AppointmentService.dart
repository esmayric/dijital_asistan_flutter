import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
class AppointmentService {
  static const String baseUrl = 'http://localhost:7293/api/RandevuTakip';

  // Randevuları almak için
  static Future<List<Map<String, dynamic>>> getAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Token bulunamadı!");
      return [];
    }
    
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      for (var appointment in data) {
        print("Randevu Verisi: $appointment");  
        print("Randevu ID: ${appointment['randevuId']}");  
      }

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
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'randevuTarihi': date, 
        'randevuSaati': time,  
        'doktorAdi': doctor,   
        'notlar': note,        
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

  // Randevu silme işlemi
  static Future<bool> deleteAppointment(int randevuId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("Token bulunamadı!");
        return false;
      }

      if (randevuId == null || randevuId == 0) {
        print("Geçersiz randevuId!");
        return false;
      }

      final url = Uri.parse('$baseUrl/$randevuId'); // ID artık doğrudan int olarak kullanılıyor

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("✅ Randevu başarıyla silindi.");
        return true;
      } else if (response.statusCode == 401) {
        print("⛔ Silme izniniz yok!");
        return false;
      } else {
        print("❌ Randevu silinemedi! Hata Kodu: ${response.statusCode}");
        print("Hata Detayı: ${response.body}");
        return false;
      }
    } catch (e) {
      print("💥 Beklenmeyen bir hata oluştu: $e");
      return false;
    }
  }
}
