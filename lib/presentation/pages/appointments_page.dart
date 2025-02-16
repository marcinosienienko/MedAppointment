import 'package:flutter/material.dart';
import 'package:medical_app/data/models/appointment_model.dart';
import 'package:medical_app/data/viewmodels/appointments_viewmodel.dart';
import 'package:medical_app/data/viewmodels/slot_viewmodel.dart';
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
          onCancel: () {
            final userId = Provider.of<UserViewModel>(context, listen: false)
                .currentUser
                ?.id;
            final slotViewModel =
                Provider.of<SlotViewModel>(context, listen: false);

            if (userId != null) {
              Provider.of<AppointmentsViewModel>(context, listen: false)
                  .handleAppointmentCancelation(
                      context, appointment, userId, slotViewModel);
            }
          },
        );
      },
    );
  }
}
