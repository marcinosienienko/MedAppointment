import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/data/viewmodels/appointments_viewmodel.dart';
import 'package:medical_app/data/models/appointment_model.dart';
import 'package:medical_app/data/viewmodels/slot_viewmodel.dart';
import 'package:medical_app/data/viewmodels/user_viewmodel.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    final appointmentsViewModel = Provider.of<AppointmentsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Twoje wizyty'),
      ),
      body: appointmentsViewModel.appointments.isEmpty
          ? Center(
              child: Text('Brak zarezerwowanych wizyt.'),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: appointmentsViewModel.appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointmentsViewModel.appointments[index];
                return AppointmentCard(appointment, context);
              },
            ),
    );
  }

  Widget AppointmentCard(Appointment appointment, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          appointment.doctorId ?? 'Brak nazwy lekarza',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Specjalizacja: ${appointment.doctorId}'),
            Text(
              'Termin: ${appointment.date}',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.cancel, color: Colors.red),
          onPressed: () {
            _showCancelDialog(
                context, appointment.id, appointment.doctorId ?? '');
          },
        ),
      ),
    );
  }

  void _showCancelDialog(
      BuildContext context, String appointmentId, String doctorId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Anuluj wizytę'),
          content: Text('Czy na pewno chcesz anulować tę wizytę?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Anuluj'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<SlotViewModel>(context, listen: false)
                    .restoreSlotAvailability(appointmentId, doctorId);
                Provider.of<AppointmentsViewModel>(context, listen: false)
                    .cancelAppointment(appointmentId);
                Navigator.of(context).pop();
              },
              child: Text('Potwierdź'),
            ),
          ],
        );
      },
    );
  }
}
