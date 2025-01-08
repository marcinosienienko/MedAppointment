import 'package:flutter/material.dart';
import 'package:medical_app/data/models/appointment_model.dart';
import 'package:medical_app/data/viewmodels/appointments_viewmodel.dart';
import 'package:provider/provider.dart';

class AppointmentBookingPage extends StatefulWidget {
  final String doctorId;

  const AppointmentBookingPage({super.key, required this.doctorId});

  @override
  State<AppointmentBookingPage> createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    final appointmentsViewModel = Provider.of<AppointmentsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezerwacja wizyty'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wybierz datę:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: Colors.teal, // Kolor nagłówka i przycisków
                          onPrimary: Colors.white, // Kolor tekstu nagłówka
                          onSurface: Colors.black, // Kolor tekstu w kalendarzu
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.teal, // Kolor przycisków
                          ),
                        ),
                        dialogBackgroundColor: Colors.grey[50], // Kolor tła
                        dialogTheme: DialogTheme(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                _selectedDate != null
                    ? _selectedDate!.toLocal().toString().split(' ')[0]
                    : 'Wybierz datę',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Wybierz godzinę:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        timePickerTheme: TimePickerThemeData(
                          dialBackgroundColor: Colors.grey[200],
                          hourMinuteColor: MaterialStateColor.resolveWith(
                            (states) => Colors.teal,
                          ),
                          hourMinuteTextColor: Colors.white,
                          dayPeriodColor: MaterialStateColor.resolveWith(
                            (states) => Colors.teal[200]!,
                          ),
                          dayPeriodTextColor: Colors.black,
                          dialHandColor: Colors.teal,
                          dialTextColor: Colors.black,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (time != null) {
                  setState(() {
                    _selectedTime = time;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                _selectedTime != null
                    ? _selectedTime!.format(context)
                    : 'Wybierz godzinę',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _selectedDate != null && _selectedTime != null
                    ? () {
                        final appointmentDate = DateTime(
                          _selectedDate!.year,
                          _selectedDate!.month,
                          _selectedDate!.day,
                          _selectedTime!.hour,
                          _selectedTime!.minute,
                        );

                        final appointment = Appointment(
                          doctorId: widget.doctorId,
                          userId:
                              'currentUserId', // Zastąp właściwym ID użytkownika
                          date: appointmentDate,
                        );

                        appointmentsViewModel.addAppointment(appointment);
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Zarezerwuj wizytę',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
