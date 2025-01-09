class Slot {
  final String id;
  final DateTime dateTime;
  final String doctorId;
  bool isAvailable;

  Slot({
    required this.id,
    required this.dateTime,
    required this.doctorId,
    required this.isAvailable,
  });
}

// Map<DateTime, List<Slot>> _slots = {
//   DateTime(2025, 1, 9): [Slot(DateTime(2025, 1, 9, 9, 0), true)],
//   DateTime(2025, 1, 10): [Slot(DateTime(2025, 1, 10, 10, 0), false)],
// };

// List<Slot> _getSlotsForDay(DateTime day) {
//   return _slots[day] ?? [];
// }
