import 'package:flutter/material.dart';
import 'package:medical_app/data/viewmodels/slot_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  final String doctorId;

  CalendarPage({required this.doctorId});

  @override
  Widget build(BuildContext context) {
    final slotViewModel = Provider.of<SlotViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Kalendarz wizyt'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(Duration(days: 30)),
            focusedDay: slotViewModel.focusedDay,
            selectedDayPredicate: (day) =>
                isSameDay(slotViewModel.selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              slotViewModel.onDaySelected(selectedDay, focusedDay);
            },
            calendarFormat: CalendarFormat.month,
            headerStyle: HeaderStyle(formatButtonVisible: true),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, // Liczba kolumn w siatce
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: slotViewModel.slots.length,
              itemBuilder: (context, index) {
                final slot = slotViewModel.slots[index];
                final isSelected = slotViewModel.selectedSlot == slot;

                return GestureDetector(
                  onTap: () {
                    if (slot.isAvailable) {
                      slotViewModel.selectSlot(slot);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue
                          : (slot.isAvailable ? Colors.blueGrey : Colors.red),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${slot.dateTime.hour.toString().padLeft(2, '0')}:${slot.dateTime.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
