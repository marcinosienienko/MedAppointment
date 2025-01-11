import 'package:flutter/material.dart';
import 'package:medical_app/data/models/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onCancel;

  AppointmentCard({required this.appointment, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(appointment.doctorName,
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Specjalizacja: ${appointment.specialization}'),
            Text(
              'Termin: ${appointment.dateTime.toLocal()}',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.cancel, color: Colors.red),
          onPressed: onCancel,
        ),
      ),
    );
  }
}
