import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class IlacTakipPage extends StatefulWidget {
  @override
  _IlacTakipPageState createState() => _IlacTakipPageState();
}

class _IlacTakipPageState extends State<IlacTakipPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _startDate;
  DateTime? _endDate;
  Map<String, List<String>> weeklyMedicines = {};
  Map<DateTime, List<String>> monthlyMedicines = {};

  // Haftalık ilaç eklemek için
  void _addWeeklyMedicine(String day) {
    TimeOfDay? selectedTime;
    TextEditingController medicineController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("İlaç Ekle ($day)"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: medicineController,
                decoration: InputDecoration(labelText: "İlaç Adı"),
              ),
              ElevatedButton(
                onPressed: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                  }
                },
                child: Text("Saat Seç"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () {
                if (medicineController.text.isNotEmpty && selectedTime != null) {
                  setState(() {
                    weeklyMedicines.putIfAbsent(day, () => []).add(
                        "${medicineController.text} - ${selectedTime!.format(context)}");
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Ekle"),
            ),
          ],
        );
      },
    );
  }

  // Aylık ilaç eklemek için
  void _addMonthlyMedicine() {
    TextEditingController medicineController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("İlaç Ekle (Aylık)"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: medicineController,
                decoration: InputDecoration(labelText: "İlaç Adı"),
              ),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedStartDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (pickedStartDate != null) {
                    setState(() {
                      _startDate = pickedStartDate;
                    });
                  }
                },
                child: Text("Başlangıç Tarihi Seç"),
              ),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedEndDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (pickedEndDate != null) {
                    setState(() {
                      _endDate = pickedEndDate;
                    });
                  }
                },
                child: Text("Bitiş Tarihi Seç"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () {
                if (medicineController.text.isNotEmpty && _startDate != null && _endDate != null) {
                  setState(() {
                    // Aylık ilaçları tarih aralığına göre ekliyoruz
                    for (DateTime date = _startDate!; date.isBefore(_endDate!); date = date.add(Duration(days: 1))) {
                      monthlyMedicines.putIfAbsent(date, () => []).add(medicineController.text);
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Ekle"),
            ),
          ],
        );
      },
    );
  }

  // Haftalık takvimi günler halinde göstermek için
  List<String> getWeekDays() {
    return ["Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi", "Pazar"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("İlaç Takip")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            TableCalendar(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addMonthlyMedicine,
              child: Text("Aylık İlaç Eklemek İçin Tıklayın"),
            ),
            Divider(),
            // Haftalık takvim kısmı
            Text("Haftalık Takvim", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              itemCount: getWeekDays().length,
              itemBuilder: (context, index) {
                String day = getWeekDays()[index];
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Gün ismi
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            day,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        // İlaçları göstermek için Wrap widget'ı kullanıyoruz
                        Expanded(
                          child: Wrap(
                            spacing: 8.0, // Aradaki yatay mesafe
                            runSpacing: 4.0, // Alt satırdaki yatay mesafe
                            children: weeklyMedicines[day]?.map((medicine) {
                              return Card(
                                color: Colors.green[100],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(medicine),
                                ),
                              );
                            }).toList() ??
                                [],
                          ),
                        ),
                        // İlaç ekleme butonu
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _addWeeklyMedicine(day);
                          },
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey), // Günler arasına gri çizgi ekleniyor
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}