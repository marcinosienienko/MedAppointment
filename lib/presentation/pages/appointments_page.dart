import 'package:flutter/material.dart';
import 'package:medical_app/data/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/data/viewmodels/appointments_viewmodel.dart';
import 'package:medical_app/data/models/appointment_model.dart';
import 'package:medical_app/data/models/doctor.dart';
import 'package:medical_app/data/models/slot_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical_app/presentation/widgets/appointment_card.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
      appBar: AppBar(
        title: const Text('Twoje wizyty'),
      ),
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

        return FutureBuilder<List<dynamic>>(
          future: Future.wait([
            _fetchDoctor(appointment.doctorId!),
            _fetchSlotDetails(appointment.doctorId!, appointment.slotId!),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("Nie udało się pobrać danych"));
            }

            final doctor = snapshot.data![0] as Doctor?;
            final slot = snapshot.data![1] as Slot?;

            return AppointmentCard(
              appointment: Appointment(
                id: appointment.id,
                doctorName: doctor?.name ?? "Nieznany lekarz",
                specialization:
                    doctor?.specialization?.name ?? "Brak specjalizacji",
                date: slot != null
                    ? "${slot.date} ${slot.startTime}"
                    : "Brak terminu",
                status: appointment.status,
              ),
              onCancel: () {
                _cancelAppointment(
                  context,
                  appointment.id!,
                  appointment.doctorId!,
                  appointment.slotId!,
                );
              },
            );
          },
        );
      },
    );
  }

  Future<Doctor?> _fetchDoctor(String doctorId) async {
    try {
      final doc = await _db.collection('doctors').doc(doctorId).get();
      if (doc.exists) {
        final data = doc.data();
        return data != null ? Doctor.fromMap(data, doc.id) : null;
      }
    } catch (e) {
      print('Błąd podczas pobierania danych lekarza: $e');
    }
    return null;
  }

  Future<Slot?> _fetchSlotDetails(String doctorId, String slotId) async {
    try {
      final doc = await _db
          .collection('doctors')
          .doc(doctorId)
          .collection('slots')
          .doc(slotId)
          .get();
      if (doc.exists) {
        final data = doc.data();
        return data != null ? Slot.fromMap(data, doc.id) : null;
      }
    } catch (e) {
      print('Błąd podczas pobierania szczegółów slotu: $e');
    }
    return null;
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
            child: const Text('Nie'),
          ),
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
