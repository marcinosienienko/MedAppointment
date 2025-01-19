import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/data/viewmodels/appointments_viewmodel.dart';
import 'package:medical_app/data/viewmodels/slot_viewmodel.dart';
import 'package:medical_app/data/models/appointment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical_app/presentation/widgets/appointment_card.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> _fetchDoctorAndSpecialization(
      String doctorId) async {
    try {
      final doctorDoc = await _db.collection('doctors').doc(doctorId).get();
      if (doctorDoc.exists) {
        final doctorData = doctorDoc.data()!;
        final specializationId = doctorData['specializationId'];

        String? specializationName;
        if (specializationId != null) {
          final specializationDoc = await _db
              .collection('specializations')
              .doc(specializationId)
              .get();

          if (specializationDoc.exists) {
            specializationName = specializationDoc.data()?['name'];
          }
        }

        return {
          'doctorName': doctorData['name'] ?? 'Nieznany lekarz',
          'specializationName': specializationName ?? 'Brak specjalizacji',
        };
      }
    } catch (e) {
      print('Błąd podczas pobierania danych lekarza lub specjalizacji: $e');
    }

    return {
      'doctorName': 'Nieznany lekarz',
      'specializationName': 'Brak specjalizacji',
    };
  }

  Future<String?> _fetchSlotDate(String doctorId, String slotId) async {
    try {
      final slotDoc = await _db
          .collection('doctors')
          .doc(doctorId)
          .collection('slots')
          .doc(slotId)
          .get();

      if (slotDoc.exists) {
        return slotDoc.data()?['date'];
      }
    } catch (e) {
      print('Błąd podczas pobierania daty slotu: $e');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsViewModel = Provider.of<AppointmentsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Twoje wizyty'),
      ),
      body: appointmentsViewModel.appointments.isEmpty
          ? const Center(
              child: Text('Brak zarezerwowanych wizyt.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: appointmentsViewModel.appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointmentsViewModel.appointments[index];
                return FutureBuilder<List<dynamic>>(
                  future: Future.wait([
                    _fetchDoctorAndSpecialization(appointment.doctorId!),
                    _fetchSlotDate(appointment.doctorId!, appointment.slotId!),
                  ]),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final doctorData =
                        snapshot.data![0] as Map<String, dynamic>;
                    final slotDate = snapshot.data![1] as String?;

                    return AppointmentCard(
                      appointment: Appointment(
                        id: appointment.id,
                        doctorName: doctorData['doctorName'],
                        specialization: doctorData['specializationName'],
                        date: slotDate,
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
                appointmentId,
                doctorId,
                slotId,
                Provider.of<SlotViewModel>(context, listen: false),
              );
            },
            child: const Text('Tak'),
          ),
        ],
      ),
    );
  }
}
