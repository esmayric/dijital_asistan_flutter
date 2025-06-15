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
  Map<DateTime, List<Map<String, dynamic>>> appointments = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    List<Map<String, dynamic>> fetchedAppointments = await AppointmentService.getAppointments();

    Map<DateTime, List<Map<String, dynamic>>> organizedAppointments = {};

    for (var appt in fetchedAppointments) {
      DateTime? date = DateTime.tryParse(appt['randevuTarihi']);
      if (date == null) {
        print("Geçersiz tarih formatı: ${appt['randevuTarihi']}");
        continue; // Veriyi atla
      }

      String time = appt['randevuSaati'] ?? '';
      String doctor = appt['doktorAdi'] ?? '';
      String note = appt['notlar'] ?? '';

      dynamic rawId = appt['id'] ?? appt['randevuId']; // varsa randevuId de bak
if (rawId == null) {
  print("Randevunun ID'si eksik! Atlanıyor: $appt");
  continue; // SKIP et, kendi kafamıza göre id uydurmuyoruz artık
}

int? id = rawId is int ? rawId : int.tryParse(rawId.toString());

if (id == null) {
  print("ID çözülemedi: $rawId");
  continue;
}
      DateTime onlyDate = DateTime(date.year, date.month, date.day);

      organizedAppointments.putIfAbsent(onlyDate, () => []);
      organizedAppointments[onlyDate]!.add({
        "id": id,
        "time": time,
        "doctor": doctor,
        "note": note,
      });
    }

    setState(() {
      appointments = organizedAppointments;
    });
  }

  String _convertTimeToString(TimeOfDay time) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(DateTime(0, 0, 0, time.hour, time.minute));
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<Map<String, dynamic>> getAppointmentsForDay(DateTime day) {
    return appointments.entries
        .where((entry) => isSameDay(entry.key, day))
        .map((entry) => entry.value)
        .expand((element) => element)
        .toList();
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
                if (selectedTime == null || doctorController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Lütfen tüm alanları doldurun!")),
                  );
                  return;
                }

                String timeString = _convertTimeToString(selectedTime!);

                bool success = await AppointmentService.addAppointment(
                  widget.userId,
                  DateFormat('yyyy-MM-dd').format(_selectedDay),
                  timeString,
                  doctorController.text,
                  noteController.text,
                );
                if (success) {
                  await _loadAppointments();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Randevu başarıyla eklendi!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Randevu eklenemedi. Lütfen tekrar deneyin.")),
                  );
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
  List<Map<String, dynamic>> todaysAppointments = getAppointmentsForDay(_selectedDay);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Randevu Sil"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: todaysAppointments.isNotEmpty
              ? todaysAppointments.map((appointment) {
                  final dynamic rawId = appointment['id'];
                  final int? randevuId = rawId is int
                      ? rawId
                      : (rawId is String ? int.tryParse(rawId) : null);

                  return ListTile(
                    title: Text("Doktor: ${appointment["doctor"]}"),
                    subtitle: Text("Saat: ${appointment["time"]}\nNot: ${appointment["note"]}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        if (randevuId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Geçersiz randevu ID'si!")),
                          );
                          return;
                        }

                        bool success = await AppointmentService.deleteAppointment(randevuId);

                        if (success) {
                          await _loadAppointments();
                          Navigator.pop(context); // Artık burada, tam yerinde!
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Randevu başarıyla silindi!")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Randevu silinemedi. Lütfen tekrar deneyin.")),
                          );
                        }
                      },
                    ),
                  );
                }).toList()
              : [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Bugün için silinecek randevu bulunamadı."),
                  )
                ],
        ),
        actions: [
          TextButton(
            child: Text("Kapat"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> todaysAppointments = getAppointmentsForDay(_selectedDay);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:Color(0xFF94D9C6),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
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
              eventLoader: (day) => getAppointmentsForDay(day),
              
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _showAddAppointmentDialog,
                  icon: Icon(Icons.add, color: Colors.teal),
                  label: Text('Randevu Ekle', style: TextStyle(color: Colors.teal)),
                  style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 233, 247, 244),foregroundColor: Colors.teal),
                ),
                ElevatedButton.icon(
                  onPressed: _showDeleteAppointmentDialog,
                  icon: Icon(Icons.delete, color:  const Color.fromARGB(255, 168, 68, 61)),
                  label: Text('Randevu Sil', style: TextStyle(color: const Color.fromARGB(255, 168, 68, 61))),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 253, 216, 216)),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
  child: SizedBox(
    width: 320, // ← Genişlik burada belirleniyor
    child: Divider(
      thickness: 2,
      color: Colors.teal,
    ),
  ),
),
SizedBox(height: 20),
        SizedBox(
          height: 200,  // Örneğin sabit yükseklik verin
          child: todaysAppointments.isNotEmpty
              ? ListView.builder(
                  itemCount: todaysAppointments.length,
                  itemBuilder: (context, index) {
                    var appointment = todaysAppointments[index];
                    return Card(
                      color: Color.fromARGB(255, 233, 247, 244), 
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        title: Text("Doktor: ${appointment["doctor"]}"),
                        subtitle: Text("Saat: ${appointment["time"]}\nNot: ${appointment["note"]}"),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text("Bugün için randevu yok.", style: TextStyle(color: Colors.grey)),
                ),
        ),
          ],
        ),
        ),
      ),
    );
  }
}