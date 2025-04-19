import 'package:flutter/material.dart';

class BeslenmeTakipPage extends StatefulWidget {
  @override
  _BeslenmeTakipPageState createState() => _BeslenmeTakipPageState();
}

class _BeslenmeTakipPageState extends State<BeslenmeTakipPage> {
  Map<String, List<String>> yemekler = {
    'Kahvaltı': [],
    'Öğle Yemeği': [],
    'Akşam Yemeği': [],
    'Ara Öğün': [],
    'Diğer': []
  };

  void _yemekEkle(String ogun) {
    TextEditingController yemekController = TextEditingController();
    TextEditingController gramajController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$ogun için Yemek Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: yemekController,
                decoration: InputDecoration(labelText: 'Yemek Adı'),
              ),
              TextField(
                controller: gramajController,
                decoration: InputDecoration(labelText: 'Gramaj (g)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  yemekler[ogun]?.add('${yemekController.text} - ${gramajController.text}g');
                });
                Navigator.of(context).pop();
              },
              child: Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beslenme Takip'),
      ),
      body: ListView(
        children: yemekler.keys.map((ogun) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text(ogun, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              children: [
                ...yemekler[ogun]!.map((yemek) => ListTile(title: Text(yemek))).toList(),
                TextButton(
                  onPressed: () => _yemekEkle(ogun),
                  child: Text('+ Yemek Ekle', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}