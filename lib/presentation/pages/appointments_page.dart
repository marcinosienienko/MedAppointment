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

class _AppointmentsPageState extends State<AppointmentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsViewModel = Provider.of<AppointmentsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Twoje wizyty'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 6,
          indicatorPadding: EdgeInsets.all(10),
          labelColor: Colors.white, // Kolor tekstu dla aktywnej zakładki
          unselectedLabelColor:
              Colors.white70, // Kolor tekstu dla nieaktywnych zakładek
          labelStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight:
                FontWeight.bold, // Wyróżniona czcionka dla aktywnej zakładki
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14.0,
          ),
          tabs: const [
            Tab(
              icon: Icon(Icons.check_circle_outline), // Ikona dla aktualnych
              text: 'Aktualne',
            ),
            Tab(
              icon: Icon(Icons.cancel_outlined), // Ikona dla anulowanych
              text: 'Anulowane',
            ),
            Tab(
              icon: Icon(Icons.done_all), // Ikona dla zrealizowanych
              text: 'Zrealizowane',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentsList(appointmentsViewModel.upcomingAppointments),
          _buildAppointmentsList(appointmentsViewModel.cancelledAppointments),
          _buildAppointmentsList(appointmentsViewModel.completedAppointments),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(List<Appointment> appointments) {
    if (appointments.isEmpty) {
      return const Center(
        child: Text('Brak wizyt w tej kategorii.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return FutureBuilder<List<dynamic>>(
          future: Future.wait([
            _fetchDoctorAndSpecialization(appointment.doctorId!),
            _fetchSlotDetails(appointment.doctorId!, appointment.slotId!),
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final doctorData = snapshot.data![0] as Map<String, dynamic>;
            final slotDetails = snapshot.data![1] as Map<String, dynamic>?;

            final slotDate = slotDetails?['date'] ?? 'Brak daty';
            final slotTime = slotDetails?['startTime'] ?? '00:00';

            return AppointmentCard(
              appointment: Appointment(
                id: appointment.id,
                doctorName: doctorData['doctorName'],
                specialization: doctorData['specializationName'],
                date: '$slotDate $slotTime',
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

  Future<Map<String, dynamic>> _fetchDoctorAndSpecialization(
      String doctorId) async {
    try {
      final doctorDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .get();
      if (doctorDoc.exists) {
        final doctorData = doctorDoc.data()!;
        final specializationId = doctorData['specializationId'];

        String? specializationName;
        if (specializationId != null) {
          final specializationDoc = await FirebaseFirestore.instance
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

  Future<Map<String, dynamic>?> _fetchSlotDetails(
      String doctorId, String slotId) async {
    try {
      final slotDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .collection('slots')
          .doc(slotId)
          .get();

      if (slotDoc.exists) {
        return slotDoc.data();
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
