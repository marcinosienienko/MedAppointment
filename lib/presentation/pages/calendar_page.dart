import 'package:flutter/material.dart';
import 'package:medical_app/data/viewmodels/slot_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:medical_app/presentation/widgets/buttons/primary_button.dart';
import 'package:medical_app/data/viewmodels/appointments_viewmodel.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final slotViewModel = Provider.of<SlotViewModel>(context, listen: false);
      slotViewModel.setCurrentDoctorId(widget.doctorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final slotViewModel = Provider.of<SlotViewModel>(context);
    final userId =
        Provider.of<UserViewModel>(context, listen: false).currentUser?.id ??
            '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Kalendarz wizyt'),
      ),
      body: Column(
        children: [
          // Kalendarz
          TableCalendar(
            locale: "pl_PL",
            weekendDays: [DateTime.saturday, DateTime.sunday],
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              defaultDecoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.blue[100],
                shape: BoxShape.circle,
              ),
            ),
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

          // Sloty
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: slotViewModel.slots.isNotEmpty
                  ? GridView.builder(
                      key: ValueKey(
                          slotViewModel.selectedDay), // Unikalny klucz dla dnia
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
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
                                      ? Colors.grey[300]
                                      : Colors.red[200]),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${slot.startTime.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (!slot.isAvailable)
                                  Text(
                                    'Zajęty',
                                    style: TextStyle(
                                      color: Colors.red[800],
                                      fontSize: 12.0,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Brak dostępnych slotów na ten dzień',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: PrimaryButton(
              text: 'Zarezerwuj wizytę',
              onPressed: () async {
                final selectedSlot = slotViewModel.selectedSlot;
                final currentDoctor = slotViewModel.currentDoctor;

                if (selectedSlot == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Wybierz slot przed rezerwacją.')),
                  );
                  return;
                }

                if (currentDoctor == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ładowanie danych lekarza...')),
                  );
                  return;
                }

                // Wyświetl AlertDialog z potwierdzeniem
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Potwierdź rezerwację'),
                      content: Text(
                        'Czy na pewno chcesz zarezerwować wizytę u dr ${currentDoctor.name} '
                        '(${currentDoctor.specialization?.name ?? 'Brak specjalizacji'}) '
                        'na dzień ${selectedSlot.date} o godzinie ${selectedSlot.startTime}?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text('Anuluj'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text('Potwierdź'),
                        ),
                      ],
                    );
                  },
                );

                if (confirm == true) {
                  final success = await slotViewModel.reserveSlot(
                    selectedSlot.id,
                    widget.doctorId,
                    userId,
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Wizyta zarezerwowana!')),
                    );
                    Provider.of<AppointmentsViewModel>(context, listen: false)
                        .fetchAppointments(userId);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Nie udało się zarezerwować wizyty.')),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
