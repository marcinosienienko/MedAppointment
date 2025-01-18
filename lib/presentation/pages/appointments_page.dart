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
            _cancelAppointment(context, appointment.id,
                appointment.doctorId ?? '', appointment.slotId ?? '');
          },
        ),
      ),
    );
  }

  void _cancelAppointment(BuildContext context, String appointmentId,
      String doctorId, String slotId) {
    final appointmentsViewModel =
        Provider.of<AppointmentsViewModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Anuluj wizytę'),
        content: const Text('Czy na pewno chcesz anulować tę wizytę?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Nie'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await appointmentsViewModel.cancelAppointment(
                  appointmentId, doctorId, slotId);
            },
            child: const Text('Tak'),
          ),
        ],
      ),
    );
  }
}
