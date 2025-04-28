import 'package:http/http.dart' as http;
import 'dart:convert';

class TansiyonService {
  static const String _baseUrl = 'http://localhost:7293/api/Deger';

  Future<bool> tansiyonVerisiEkle({
    required int degerTipiId,
    required Map<String, dynamic> degerListesi,
    required String tahlilSonuclari,
    required String token, // token parametre eklendi
  }) async {
    var url = Uri.parse(_baseUrl);

    Map<String, dynamic> veri = {
      'degerTipiId': degerTipiId,
      'degerListesi': jsonEncode(degerListesi),
      'tahlilSonuclari': tahlilSonuclari,
      'tarih': DateTime.now().toIso8601String(),
    };

    var response = await http.post(
       url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Token burada ekleniyor
      },
      body: jsonEncode(veri),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Veri başarıyla kaydedildi');
      return true;
    } else {
      print('Hata: ${response.statusCode}, ${response.body}');
      return false;
    }
  }
}
