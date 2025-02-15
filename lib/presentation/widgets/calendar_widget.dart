import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:medical_app/data/viewmodels/slot_viewmodel.dart';

class CalendarWidget extends StatelessWidget {
  final SlotViewModel slotViewModel;

  const CalendarWidget({Key? key, required this.slotViewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: "pl_PL",
      weekendDays: [DateTime.saturday, DateTime.sunday],
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        selectedDecoration:
            BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
        defaultDecoration:
            BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
        todayDecoration:
            BoxDecoration(color: Colors.blue[100], shape: BoxShape.circle),
      ),
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(Duration(days: 30)),
      focusedDay: slotViewModel.focusedDay,
      selectedDayPredicate: (day) => isSameDay(slotViewModel.selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        slotViewModel.onDaySelected(selectedDay, focusedDay);
        slotViewModel.clearSelectedSlot();
      },
      calendarFormat: CalendarFormat.month,
      rowHeight: 40,
      headerStyle: HeaderStyle(titleCentered: true, formatButtonVisible: false),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
