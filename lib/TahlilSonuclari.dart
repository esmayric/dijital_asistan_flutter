import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show File;

class Tahlil {
  final String tarih;
  final String tur;
  final String dosyaAdi;
  final String yorum;

  Tahlil({
    required this.tarih,
    required this.tur,
    required this.dosyaAdi,
    required this.yorum,
  });

  factory Tahlil.fromJson(Map<String, dynamic> json) {
    return Tahlil(
      tarih: json['raporTarihi'] ?? '',
      tur: json['raporBasligi'] ?? '',
      dosyaAdi: json['raporDosyaYolu'] ?? '',
      yorum: json['raporIcerigi'] ?? '',
    );
  }
}

class TahlilSonuclari extends StatefulWidget {
  const TahlilSonuclari({super.key});

  @override
  State<TahlilSonuclari> createState() => _TahlilSonuclariState();
}

class _TahlilSonuclariState extends State<TahlilSonuclari> {
  List<Tahlil> tahliller = [];
  bool isLoading = false;
  String? token;

  final String baseUrl = 'http://localhost:7293';

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
    if (token != null) {
      await fetchTahliller();
    }
  }

  Future<void> fetchTahliller() async {
    setState(() {
      isLoading = true;
    });

    try {
      final uri = Uri.parse('$baseUrl/api/Rapor/listele');
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          tahliller = jsonResponse.map((item) => Tahlil.fromJson(item)).toList();
        });
      } else {
        print('Listeleme hatası: ${response.statusCode}');
        print('Hata mesajı: ${response.body}');
      }
    } catch (e) {
      print('Listeleme hatası: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Tahlil?> uploadFile(PlatformFile pickedFile) async {
    if (token == null) {
      print("❌ Token bulunamadı.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen giriş yapın. Token bulunamadı.')),
      );
      return null;
    }

    try {
      if (kIsWeb) {
        final fileBytes = pickedFile.bytes;
        if (fileBytes == null) return null;

        var uri = Uri.parse('$baseUrl/api/Rapor/yukle');
        var request = http.MultipartRequest('POST', uri);
        request.headers['Authorization'] = 'Bearer $token';

        var multipartFile = http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: pickedFile.name,
          contentType: MediaType('application', 'pdf'),
        );

        request.files.add(multipartFile);

        var streamedResponse = await request.send();
        var responseString = await streamedResponse.stream.bytesToString();

        if (streamedResponse.statusCode == 200) {
          var jsonResponse = json.decode(responseString);
          return Tahlil.fromJson(jsonResponse);
        } else {
          print('Upload failed with status: ${streamedResponse.statusCode}');
          print('Response: $responseString');
          return null;
        }
      } else {
        if (pickedFile.path == null) return null;
        File file = File(pickedFile.path!);

        var uri = Uri.parse('$baseUrl/api/Rapor/yukle');
        var request = http.MultipartRequest('POST', uri);
        request.headers['Authorization'] = 'Bearer $token';

        request.files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType('application', 'pdf'),
          filename: pickedFile.name,
        ));

        var streamedResponse = await request.send();
        var responseString = await streamedResponse.stream.bytesToString();

        if (streamedResponse.statusCode == 200) {
          var jsonResponse = json.decode(responseString);
          return Tahlil.fromJson(jsonResponse);
        } else {
          print('Upload failed with status: ${streamedResponse.statusCode}');
          print('Response: $responseString');
          return null;
        }
      }
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  Future<void> pickAndUploadFile() async {
    setState(() {
      isLoading = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: kIsWeb,
      );

      if (result == null || result.files.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final pickedFile = result.files.first;

      final yeniTahlil = await uploadFile(pickedFile);

      if (yeniTahlil != null) {
        setState(() {
          tahliller.insert(0, yeniTahlil);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dosya yüklenirken hata oluştu.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildTahlilCard(Tahlil tahlil) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: ExpansionTile(
          leading: const Icon(Icons.insert_drive_file, size: 40, color: Colors.blue),
          title: Text("Tarih: ${tahlil.tarih}", style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Tür: ${tahlil.tur}"),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          children: [
            Text("Dosya: ${tahlil.dosyaAdi}"),
            const SizedBox(height: 10),
            const Text("Yapay Zeka Yorumu:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(tahlil.yorum),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tahlil Sonuçları"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
                child: const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              const Text(
                "TAHLİL SONUÇLARI",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ]),
          ),
          const Divider(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : tahliller.isEmpty
                    ? const Center(child: Text("Henüz tahlil yüklenmedi."))
                    : ListView.builder(
                        itemCount: tahliller.length,
                        itemBuilder: (context, index) {
                          return _buildTahlilCard(tahliller[index]);
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              onPressed: isLoading ? null : pickAndUploadFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Tahlil Yükleyin", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}