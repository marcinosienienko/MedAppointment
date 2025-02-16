import 'package:flutter/material.dart';
import 'package:medical_app/data/models/appointment_model.dart';
import 'package:medical_app/data/viewmodels/appointments_viewmodel.dart';
import 'package:medical_app/data/viewmodels/user_viewmodel.dart';
import 'package:medical_app/presentation/widgets/appointment_card.dart';
import 'package:provider/provider.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId =
          Provider.of<UserViewModel>(context, listen: false).currentUser?.id;
      if (userId != null) {
        Provider.of<AppointmentsViewModel>(context, listen: false)
            .fetchAppointments(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsViewModel = Provider.of<AppointmentsViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Twoje wizyty')),
      body: _buildAppointmentsList(appointmentsViewModel.appointments),
    );
  }

  Widget _buildAppointmentsList(List<Appointment> appointments) {
    if (appointments.isEmpty) {
      return const Center(
        child: Text(
          'Brak zaplanowanych wizyt.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];

        return AppointmentCard(
          appointment: appointment,
          onCancel: () => _cancelAppointment(context, appointment.id!,
              appointment.doctorId!, appointment.slotId!),
        );
      },
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Nie')),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await appointmentsViewModel.cancelAppointment(
                appointmentId: appointmentId,
                doctorId: doctorId,
                slotId: slotId,
              );
            },
            child: const Text('Tak'),
          ),
        ],
      ),
    );
  }
}
