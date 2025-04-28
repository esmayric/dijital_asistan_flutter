import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/Ilacservice.dart';

class IlacTakipPage extends StatefulWidget {
  final int userId;

  const IlacTakipPage({super.key, required this.userId});

  @override
  _IlacTakipPageState createState() => _IlacTakipPageState();
}

class _IlacTakipPageState extends State<IlacTakipPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> selectedDayMedicines = [];

  final List<String> frequencyOptions = [
    "Her gün",
    "2 günde bir",
    "Haftada bir",
    "2 haftada bir",
    "Ayda bir",
    "Her 2 ayda bir",
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchMedicinesForDay(_focusedDay);
  }

void _fetchMedicinesForDay(DateTime day) async {
  try {
    print("Seçili gün: $day");

    List<Map<String, dynamic>> allMedicines = await IlacService.getIlaclar();
    print("Toplam ilaç sayısı: ${allMedicines.length}");

    DateTime normalizedDay = DateTime(day.year, day.month, day.day);

    List<Map<String, dynamic>> medicinesForDay = allMedicines.where((ilac) {
      print("Kontrol edilen ilaç: ${ilac['ilacAd']}");

      if (ilac['baslangicTarih'] == null || ilac['bitisTarihi'] == null) {
  print("- Tarih bilgisi eksik, geçildi.");
  return false;
}


      
      final baslangicRaw = DateTime.parse(ilac['baslangicTarih']);
final bitisRaw = DateTime.parse(ilac['bitisTarihi']);

      DateTime baslangic = DateTime(baslangicRaw.year, baslangicRaw.month, baslangicRaw.day);
      DateTime bitis = DateTime(bitisRaw.year, bitisRaw.month, bitisRaw.day);

      print("- Başlangıç: $baslangic | Bitiş: $bitis");

      if (normalizedDay.isBefore(baslangic)) {
        print("-- Seçili gün başlangıçtan önce.");
        return false;
      }

      if (normalizedDay.isAfter(bitis)) {
        print("-- Seçili gün bitişten sonra.");
        return false;
      }

      final siklik = ilac['siklik'] ?? "Her gün";
      print("- Sıklık: $siklik");

      Duration diff = normalizedDay.difference(baslangic);
      if (diff.inDays < 0) {
        print("-- Gün farkı negatif, geçildi.");
        return false;
      }

      print("- Gün farkı: ${diff.inDays}");

      switch (siklik) {
        case "Her gün":
          print("-- Her gün, eklendi.");
          return true;
        case "2 günde bir":
          bool result = diff.inDays % 2 == 0;
          print("-- 2 günde bir, uygun mu: $result");
          return result;
        case "Haftada bir":
          bool result = diff.inDays % 7 == 0;
          print("-- Haftada bir, uygun mu: $result");
          return result;
        case "2 haftada bir":
          bool result = diff.inDays % 14 == 0;
          print("-- 2 haftada bir, uygun mu: $result");
          return result;
        case "Ayda bir":
          bool result = normalizedDay.day == baslangic.day;
          print("-- Ayda bir, uygun mu: $result");
          return result;
        case "Her 2 ayda bir":
          bool result = normalizedDay.day == baslangic.day &&
              (normalizedDay.month - baslangic.month) % 2 == 0;
          print("-- 2 ayda bir, uygun mu: $result");
          return result;
        default:
          print("-- Bilinmeyen sıklık, geçildi.");
          return false;
      }
    }).toList();

    print("Bugün için bulunan ilaç sayısı: ${medicinesForDay.length}");

    setState(() {
      selectedDayMedicines = medicinesForDay;
    });
  } catch (e, stacktrace) {
    print("İlaçlar alınırken hata: $e");
    print("Stacktrace: $stacktrace");
  }
}

  void _showAddMedicineDialog() {
  TextEditingController nameController = TextEditingController();
  String? selectedFrequency;
  TimeOfDay? reminderTime;
  DateTime? startDate;
  DateTime? endDate;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("💊 İlaç Ekle", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "İlaç İsmi",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      startDate = pickedDate;
                    });
                  }
                },
                icon: const Icon(Icons.date_range),
                label: Text(startDate == null
                    ? "Başlangıç Tarihi Seç"
                    : "${startDate!.day}.${startDate!.month}.${startDate!.year}"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: startDate ?? DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      endDate = pickedDate;
                    });
                  }
                },
                icon: const Icon(Icons.event),
                label: Text(endDate == null
                    ? "Bitiş Tarihi Seç"
                    : "${endDate!.day}.${endDate!.month}.${endDate!.year}"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Sıklık Seç",
                  border: OutlineInputBorder(),
                ),
                items: frequencyOptions.map((String freq) {
                  return DropdownMenuItem<String>(
                    value: freq,
                    child: Text(freq),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedFrequency = value;
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      reminderTime = pickedTime;
                    });
                  }
                },
                icon: const Icon(Icons.access_time),
                label: Text(reminderTime == null
                    ? "Hatırlatma Saati Seç"
                    : reminderTime!.format(context)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  startDate != null &&
                  endDate != null &&
                  selectedFrequency != null &&
                  reminderTime != null) {
                _ilacEkle(
                  ilacAd: nameController.text,
                  baslangicTarih: startDate!,
                  bitisTarih: endDate!,
                  siklik: selectedFrequency!,
                  hatirlatmaSaati: reminderTime!,
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Lütfen tüm alanları doldurun.")),
                );
              }
            },
            icon: const Icon(Icons.save),
            label: const Text("Kaydet"),
          ),
        ],
      );
    },
  );
}


  Future<void> _ilacEkle({
    required String ilacAd,
    required DateTime baslangicTarih,
    required DateTime bitisTarih,
    required String siklik,
    required TimeOfDay hatirlatmaSaati,
  }) async {
    bool basarili = await IlacService.addIlac(
      ilacAd,
      baslangicTarih.toIso8601String(),
      bitisTarih.toIso8601String(),
      siklik,
      "${hatirlatmaSaati.hour}:${hatirlatmaSaati.minute}",
      false,
    );

    if (basarili) {
      if (_selectedDay != null) {
        _fetchMedicinesForDay(_selectedDay!);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("İlaç başarıyla eklendi!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("İlaç eklenirken hata oluştu.")),
      );
    }
  }

Widget _buildDateBar() {
  DateTime now = DateTime.now();
  DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: List.generate(14, (index) {  // İstersen 7 yerine 14 yapıp 2 haftalık da gösterebilirsin
        DateTime day = startOfWeek.add(Duration(days: index));
        bool isSelected = isSameDay(_selectedDay, day);

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = day;
            });
            _fetchMedicinesForDay(day);
          },
          child: Container(
            width: 70,  // Sabit genişlik
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? Colors.cyan : const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  day.day.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _ayAdi(day.month),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    ),
  );
}

  String _ayAdi(int month) {
    const aylar = [
      "Oca", "Şub", "Mar", "Nis", "May", "Haz",
      "Tem", "Ağu", "Eyl", "Eki", "Kas", "Ara"
    ];
    return aylar[month - 1];
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    return a?.year == b?.year && a?.month == b?.month && a?.day == b?.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("İlaç Takip")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDateBar(),
            const SizedBox(height: 10),
            Text(
              "Bugün, ${_selectedDay!.day} ${_ayAdi(_selectedDay!.month)}",
              style: const TextStyle(color: Colors.cyan, fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showAddMedicineDialog,
              icon: const Icon(Icons.add),
              label: const Text("İLAÇ EKLE"),
            ),
            const Divider(height: 30),
            ...selectedDayMedicines.map((ilac) => ListTile(
  leading: const Icon(Icons.medication),
  title: Text(ilac['ilacAd']),
  subtitle: Text(
      "Saat: ${ilac['hatirlatmaSaati']} - Sıklık: ${ilac['siklik']}"),
  trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(Icons.edit, color: Colors.orange),
        onPressed: () {
          // TODO: Güncelle dialog'u burada açılabilir
          print("Güncelle tıklandı: ${ilac['ilacId']}");
        },
      ),
      IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () async {
          bool onay = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("İlaç Sil"),
              content: const Text("Bu ilacı silmek istediğinize emin misiniz?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("İptal"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Sil"),
                ),
              ],
            ),
          );

          if (onay == true) {
            bool basarili = await IlacService.deleteIlac(ilac['ilacId']);
            if (basarili) {
              _fetchMedicinesForDay(_selectedDay!);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("İlaç silindi.")),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Silme işlemi başarısız.")),
              );
            }
          }
        },
      ),
    ],
  ),
)),

          ],
        ),
      ),
    );
  }
}