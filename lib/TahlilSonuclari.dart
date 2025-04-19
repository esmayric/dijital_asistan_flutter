import 'package:flutter/material.dart';

class TahlilSonuclari extends StatelessWidget {
  const TahlilSonuclari({super.key});

  @override
  Widget build(BuildContext context) {
    // Örnek tahlil verileri
    List<Map<String, String>> tahliller = [
      {
        "tarih": "25 Mart 2025",
        "tur": "Kan Testi",
        "hastane": "Şehir Hastanesi"
      },
      {
        "tarih": "10 Şubat 2025",
        "tur": "MR",
        "hastane": "Özel Sağlık Hastanesi"
      },
      {
        "tarih": "05 Ocak 2025",
        "tur": "Röntgen",
        "hastane": "Devlet Hastanesi"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tahlil Sonuçları"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Logo ve başlık
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Kullanıcının ekleyeceği logo
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Yer tutucu renk
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                const Text(
                  "TAHLİL SONUÇLARI",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(),

          // Tahlil listesi
          Expanded(
            child: ListView.builder(
              itemCount: tahliller.length,
              itemBuilder: (context, index) {
                var tahlil = tahliller[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Tahlil Logosu
                              const Icon(Icons.insert_drive_file, size: 40, color: Colors.blue),
                              const SizedBox(width: 10),
                              // Tahlil Bilgileri
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Tarih: ${tahlil['tarih']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text("Tür: ${tahlil['tur']}"),
                                  Text("Hastane: ${tahlil['hastane']}"),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Butonlar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Rapor isteme işlemi
                                },
                                child: const Text("Rapor İste"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Tahlili görüntüleme işlemi
                                },
                                child: const Text("Tahlili Görüntüle"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Tahlil ekleme butonu
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              onPressed: () {
                // Tahlil yükleme işlemi
              },
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