import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/besin_service.dart';

class BesinPage extends StatefulWidget {
  final int userId;

  const BesinPage({super.key, required this.userId});

  @override
  State<BesinPage> createState() => _BesinPageState();
}

class _BesinPageState extends State<BesinPage> {
  final TextEditingController _kaloriController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _karbonhidratController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _yagController = TextEditingController();
  final TextEditingController _rahatsizlikController = TextEditingController();

  String _sonuc = '';

  Future<void> _oneriAl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        setState(() {
          _sonuc = 'Token bulunamadı, lütfen tekrar giriş yap.';
        });
        return;
      }

      final cevap = await BesinService.oneriAlVeKaydet(
        userId: widget.userId,
        kalori: int.parse(_kaloriController.text),
        kategori: _kategoriController.text,
        karbonhidrat: int.parse(_karbonhidratController.text),
        protein: int.parse(_proteinController.text),
        yag: int.parse(_yagController.text),
        rahatsizlik: _rahatsizlikController.text,
      );

      if (cevap != null) {
        setState(() {
          _sonuc = cevap['besin']['yapayZekaOnerisi'] ?? 'Öneri bulunamadı.';
        });
      } else {
        setState(() {
          _sonuc = 'Öneri alınamadı.';
        });
      }
    } catch (e) {
      setState(() {
        _sonuc = 'Hata: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Besin Önerisi Al'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(_kaloriController, 'Kalori'),
              _buildTextField(_kategoriController, 'Kategori'),
              _buildTextField(_karbonhidratController, 'Karbonhidrat'),
              _buildTextField(_proteinController, 'Protein'),
              _buildTextField(_yagController, 'Yağ'),
              _buildTextField(_rahatsizlikController, 'Rahatsızlık'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _oneriAl,
                child: const Text('Öneri Al'),
              ),
              const SizedBox(height: 20),
              Text(
                _sonuc,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: label == 'Kategori' || label == 'Rahatsızlık'
            ? TextInputType.text
            : TextInputType.number,
      ),
    );
  }
}