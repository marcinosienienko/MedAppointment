import 'package:flutter/material.dart';
import 'package:medical_app/data/viewmodels/slot_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:medical_app/presentation/widgets/buttons/PrimaryButton.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Kalendarz wizyt'),
      ),
      body: Column(
        children: [
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
                  onTap: slot.isAvailable
                      ? () {
                          print('Slot clicked: ${slot.id}');
                          slotViewModel.selectSlot(slot);
                        }
                      : null,
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
          Padding(
            padding: const EdgeInsets.only(
                bottom: 84.0, top: 8.0, left: 16.0, right: 16.0),
            child: PrimaryButton(
              text: 'Zarezerwuj wizytę',
              onPressed: () {
                if (slotViewModel.selectedSlot != null) {
                  slotViewModel.reserveSlot(slotViewModel.selectedSlot!.id);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Wizyta zarezerwowana'),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Wybierz termin wizyty'),
                  ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
