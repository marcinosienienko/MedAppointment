import 'package:flutter/material.dart';
import 'package:medical_app/data/viewmodels/slot_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:medical_app/presentation/widgets/buttons/PrimaryButton.dart';
import 'package:medical_app/data/viewmodels/appointments_viewmodel.dart';
import 'package:medical_app/data/models/appointment_model.dart';
import 'package:medical_app/data/viewmodels/doctor_viewmodel.dart';
import 'package:medical_app/presentation/widgets/navigation_bar.dart';
import 'package:medical_app/data/models/slot_model.dart';
import 'package:medical_app/data/viewmodels/user_viewmodel.dart';

class CalendarPage extends StatefulWidget {
  final String doctorId;

  CalendarPage({required this.doctorId});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
    // Ustawienie aktualnego ID lekarza i inicjalizacja slotów
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final slotViewModel = Provider.of<SlotViewModel>(context, listen: false);
      slotViewModel.setCurrentDoctorId(widget.doctorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final slotViewModel = Provider.of<SlotViewModel>(context);
    final doctorViewModel = Provider.of<DoctorsViewModel>(context);
    final appointmentsViewModel =
        Provider.of<AppointmentsViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final userId = userViewModel.currentUser?.id ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Kalendarz wizyt'),
      ),
      body: Column(
        children: [
          // Kalendarz
          TableCalendar(
            locale: "pl_PL",
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(Duration(days: 30)),
            focusedDay: slotViewModel.focusedDay,
            selectedDayPredicate: (day) =>
                isSameDay(slotViewModel.selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              slotViewModel.onDaySelected(selectedDay, focusedDay);
            },
            calendarFormat: CalendarFormat.month,
            rowHeight: 40,
            headerStyle:
                HeaderStyle(titleCentered: true, formatButtonVisible: false),
          ),

          // Siatka slotów
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, // Liczba kolumn
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: slotViewModel.slots.length,
              itemBuilder: (context, index) {
                final slot = slotViewModel.slots[index];
                final isSelected = slotViewModel.selectedSlot == slot;

                return GestureDetector(
                  onTap: slot.isAvailable
                      ? () {
                          slotViewModel.selectSlot(slot);
                        }
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue
                          : (slot.isAvailable
                              ? Colors.grey[400]
                              : Colors.red[200]),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${slot.dateTime.hour.toString().padLeft(2, '0')}:${slot.dateTime.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Przycisk "Zarezerwuj wizytę"
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: PrimaryButton(
              text: 'Zarezerwuj wizytę',
              onPressed: () {
                if (slotViewModel.selectedSlot != null) {
                  _showAppointmentConfirmation(
                    context,
                    slotViewModel.selectedSlot!,
                    () async {
                      // Utwórz nową wizytę
                      final appointment = Appointment(
                        id: slotViewModel.selectedSlot!.id,
                        slotId: slotViewModel.selectedSlot!.id,
                        doctorId: widget.doctorId,
                        doctorName: doctorViewModel
                            .getDoctorById(widget.doctorId)!
                            .name,
                        specialization: doctorViewModel
                            .getDoctorById(widget.doctorId)!
                            .specialization,
                        dateTime: slotViewModel.selectedSlot!.dateTime,
                      );

                      // Dodaj wizytę i zarezerwuj slot
                      await appointmentsViewModel.addAppointment(
                          appointment, userId);
                      await slotViewModel
                          .reserveSlot(slotViewModel.selectedSlot!.id);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Wizyta zarezerwowana'),
                          duration: Duration(milliseconds: 1000),
                        ),
                      );

                      // Przejdź do ekranu z listą wizyt
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => BottomNavigation(
                            initialPageIndex: 1,
                          ),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Wybierz termin wizyty'),
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAppointmentConfirmation(
      BuildContext context, Slot slot, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Czy na pewno chcesz zarezerwować wizytę?'),
        content: Text(
          'W dniu ${slot.dateTime.day}.${slot.dateTime.month}.${slot.dateTime.year} o ${slot.dateTime.hour}:${slot.dateTime.minute}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Anuluj'),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
            child: const Text('Zarezerwuj'),
          ),
        ],
      ),
    );
  }
}
