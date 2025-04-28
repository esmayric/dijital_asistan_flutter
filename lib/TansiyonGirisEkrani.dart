import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/services/tansiyon_service.dart';

class TansiyonGirisEkrani extends StatefulWidget {
  const TansiyonGirisEkrani({super.key});

  @override
  _TansiyonGirisEkraniState createState() => _TansiyonGirisEkraniState();
}

class _TansiyonGirisEkraniState extends State<TansiyonGirisEkrani> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _sistolikController = TextEditingController();
  final TextEditingController _diyastolikController = TextEditingController();
  final TextEditingController _nabizController = TextEditingController();

  Future<void> tansiyonVerisiniGonder() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // token shared_preferences'tan alınıyor

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Oturum doğrulanamadı. Lütfen giriş yapın.')),
      );
      return;
    }

    var tansiyonService = TansiyonService();
    var basariliMi = await tansiyonService.tansiyonVerisiEkle(
      degerTipiId: 1,
      degerListesi: {
        'sistolik': _sistolikController.text,
        'diyastolik': _diyastolikController.text,
        'nabiz': _nabizController.text,
      },
      tahlilSonuclari: "Normal",
      token: token,
    );

    if (basariliMi) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veri başarıyla kaydedildi!')),
      );
      _formKey.currentState?.reset();
      _sistolikController.clear();
      _diyastolikController.clear();
      _nabizController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veri kaydedilemedi!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tansiyon Giriş Ekranı"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _sistolikController,
                decoration: const InputDecoration(
                  labelText: 'Sistolik Tansiyon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Boş bırakma' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _diyastolikController,
                decoration: const InputDecoration(
                  labelText: 'Diyastolik Tansiyon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Boş bırakma' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nabizController,
                decoration: const InputDecoration(
                  labelText: 'Nabız',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Boş bırakma' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    tansiyonVerisiniGonder();
                  }
                },
                child: const Text('Verileri Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}