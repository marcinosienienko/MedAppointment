import 'package:flutter/material.dart';
import 'package:medical_app/data/models/slot_model.dart';

class ConfirmationDialog extends StatelessWidget {
  final Slot slot;
  final String doctorName;
  final String specialization;

  const ConfirmationDialog({
    Key? key,
    required this.doctorName,
    required this.slot,
    required this.specialization,
    required String date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue),
          const SizedBox(width: 8),
          const Text('Potwierdź rezerwację'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Lekarz: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: doctorName),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Specjalizacja: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: specialization),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Data: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: slot.date),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Godzina: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: slot.startTime),
              ],
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue[50],
              foregroundColor: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Anuluj'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Potwierdź'),
        )
      ],
    );
  }
}
