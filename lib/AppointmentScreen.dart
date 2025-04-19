import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_application_1/services/AppointmentService.dart';

class AppointmentScreen extends StatefulWidget {
  final int userId;
  
  AppointmentScreen({super.key, required this.userId});

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  Map<DateTime, List<Map<String, dynamic>>> appointments = {}; // ID'yi de saklayacak şekilde güncelledik
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // TimeOfDay'i Duration'a dönüştürmek için yardımcı fonksiyon
  String _convertTimeToString(TimeOfDay time) {
    final hours = time.hour;
    final minutes = time.minute;
    final duration = Duration(hours: hours, minutes: minutes);
    return duration.toString(); // "HH:mm:ss" formatında döner
  }

  void _showAddAppointmentDialog() {
    TextEditingController doctorController = TextEditingController();
    TextEditingController noteController = TextEditingController();
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Randevu Ekle"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
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
                child: Text(selectedTime == null
                    ? "Saat Seç"
                    : selectedTime!.format(context)),
              ),
              TextField(
                controller: doctorController,
                decoration: InputDecoration(labelText: "Doktor Adı"),
              ),
              TextField(
                controller: noteController,
                decoration: InputDecoration(labelText: "Not"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("İptal"),
            ),
            TextButton(
              onPressed: () async {
                if (selectedTime != null && doctorController.text.isNotEmpty) {
                  // TimeOfDay'ı string formata dönüştür
                  String timeString = _convertTimeToString(selectedTime!);

                  bool success = await AppointmentService.addAppointment(
                    widget.userId,
                    DateFormat('yyyy-MM-dd').format(_selectedDay),
                    timeString,
                    doctorController.text,
                    noteController.text,
                  );
                  if (success) {
                    setState(() {
                      appointments[_selectedDay] = appointments[_selectedDay] ?? [];
                      // Randevu eklerken ID'yi de alıyoruz
                      appointments[_selectedDay]!.add({
                        "id": DateTime.now().millisecondsSinceEpoch,  // ID olarak örnek bir değer kullandık
                        "time": timeString,
                        "doctor": doctorController.text,
                        "note": noteController.text,
                      });
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Randevu başarıyla eklendi!")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Randevu eklenemedi. Lütfen tekrar deneyin.")),
                    );
                  }
                }
                Navigator.pop(context);
              },
              child: Text("Kaydet"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAppointmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Randevu Sil"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: appointments[_selectedDay]?.map((appointment) {
              return ListTile(
                title: Text("Doktor: ${appointment["doctor"]}"),
                subtitle: Text("Saat: ${appointment["time"]}\nNot: ${appointment["note"]}"),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    // Silmek için randevu ID'sini alıyoruz
                    final randevuId = appointment["id"];

                    if (randevuId == null) {
                      print("Randevu ID'si geçerli değil.");
                      return;
                    }

                    bool success = await AppointmentService.deleteAppointment(randevuId);

                    if (success) {
                      setState(() {
                        appointments[_selectedDay]?.remove(appointment);
                        if (appointments[_selectedDay]?.isEmpty ?? false) {
                          appointments.remove(_selectedDay);
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Randevu başarıyla silindi!")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Randevu silinemedi. Lütfen tekrar deneyin.")),
                      );
                    }

                    Navigator.pop(context);
                  },
                ),
              );
            }).toList() ?? [
              Center(
                child: Text("Silinecek randevu yok.",
                    style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Kapat"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Center(
              child: Image.asset(
                'assets/logo.png',
                height: 100,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'RANDEVU TAKİP',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Ara...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            TableCalendar(
              firstDay: DateTime(2000),
              lastDay: DateTime(2101),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: (day) => appointments[day] ?? [],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _showAddAppointmentDialog,
                  icon: Icon(Icons.add, color: Colors.black54),
                  label: Text('Randevu Ekle', style: TextStyle(color: Colors.black54)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                ),
                ElevatedButton.icon(
                  onPressed: _showDeleteAppointmentDialog,
                  icon: Icon(Icons.delete, color: Colors.red),
                  label: Text('Randevu Sil', style: TextStyle(color: Colors.red)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: appointments[_selectedDay]?.map((appointment) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ListTile(
                      title: Text("Doktor: ${appointment["doctor"]}"),
                      subtitle: Text(
                          "Saat: ${appointment["time"]}\nNot: ${appointment["note"]}"),
                    ),
                  );
                }).toList() ?? 
                [
                  Center(
                    child: Text("Bugün için randevu yok.",
                        style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
