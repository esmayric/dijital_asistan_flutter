import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TahlilService {
  static const String baseUrl = 'http://localhost:7293';

  /// PDF dosyasını backend'e yükler ve rapor cevabını JSON olarak döner.
  static Future<Map<String, dynamic>?> raporYukle(File pdfFile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("❌ Token bulunamadı!");
        return null;
      }

      final uri = Uri.parse('$baseUrl/api/Rapor/yukle');
      final mimeType = lookupMimeType(pdfFile.path) ?? 'application/pdf';
      final mediaType = MediaType.parse(mimeType);

      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        pdfFile.path,
        contentType: mediaType,
        filename: basename(pdfFile.path),
      ));

      final streamedResponse = await request.send();
      final responseString = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(responseString);
        return jsonResponse;
      } else {
        print('API hatası: ${streamedResponse.statusCode}');
        print('Hata mesajı: $responseString');
        return null;
      }
    } catch (e) {
      print('Hata oluştu: $e');
      return null;
    }
  }

  /// Kullanıcının yüklediği tüm raporları backend'den çeker.
  static Future<List<dynamic>?> raporListele() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("❌ Token bulunamadı!");
        return null;
      }

      final uri = Uri.parse('$baseUrl/api/Rapor/listele');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        print('API hatası: ${response.statusCode}');
        print('Hata mesajı: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Hata oluştu: $e');
      return null;
    }
  }
}