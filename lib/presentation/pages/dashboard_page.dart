import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/viewmodels/doctor_viewmodel.dart';
import '../../data/viewmodels/appointments_viewmodel.dart';
import '../../data/viewmodels/user_viewmodel.dart';
import '../../data/viewmodels/slot_viewmodel.dart';
import '../../presentation/widgets/search_bar.dart';
import '../../presentation/widgets/search_results.dart';
import '../../presentation/widgets/appointment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/appointment_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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

  Future<Map<String, dynamic>?> _fetchSlotDetails(
      String doctorId, String slotId) async {
    try {
      final slotDoc = await _db
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

  @override
  void initState() {
    super.initState();
    // Pobierz wizyty przy inicjalizacji
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      if (userViewModel.currentUser != null) {
        final appointmentsViewModel =
            Provider.of<AppointmentsViewModel>(context, listen: false);
        appointmentsViewModel.fetchAppointments(userViewModel.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorViewModel = Provider.of<DoctorViewModel>(context);
    final appointmentsViewModel = Provider.of<AppointmentsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Pasek wyszukiwania
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MainSearchBar(
                searchController: doctorViewModel.searchController,
                currentText: doctorViewModel.searchController.text,
                onClear: () {
                  doctorViewModel.clearSearch();
                },
                onChanged: (query) {
                  doctorViewModel.searchDoctors(query);
                },
                autofocus: false,
              ),
            ),

            // Wyniki wyszukiwania - renderowane tylko, gdy wpisano tekst
            if (doctorViewModel.searchController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SearchResults(
                  doctors: doctorViewModel.filteredDoctors,
                ),
              )
            else
              Column(
                children: [
                  // Baner informacyjny
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      color: Colors.blue[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '#odwoluje #nieBlokuje',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Czy wiesz, że w 2023 roku nie odwołano aż 1.3 miliona wizyt u lekarzy? To generuje kolejki i utrudnia dostęp do specjalistów. Jeśli nie możesz stawić się na wizytę, odwołaj ją lub przełóż.',
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Sekcja nadchodzących wizyt
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nadchodząca wizyta',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        _buildUpcomingAppointment(appointmentsViewModel),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Karty na ekranie głównym
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        _buildDashboardCard(
                          title: 'Wszystkie wizyty',
                          subtitle: 'Sprawdź i zarządzaj swoimi wizytami.',
                          icon: Icons.calendar_today,
                          color: Colors.blue,
                          onTap: () {
                            Navigator.pushNamed(context, '/appointments');
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _buildDashboardCard(
                          title: 'Recepty',
                          subtitle: 'Zobacz swoje recepty',
                          icon: Icons.local_pharmacy,
                          color: Colors.red,
                          onTap: () {
                            print('Otwórz Zrealizuj receptę');
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _buildDashboardCard(
                          title: 'Skierowania',
                          subtitle: 'Zobacz swoje skierowania',
                          icon: Icons.upload_file,
                          color: Colors.teal,
                          onTap: () {
                            print('Otwórz Dodaj dokumenty');
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _buildDashboardCard(
                          title: 'Uzupełnij swój profil',
                          subtitle: 'Dodaj brakujące informacje o sobie.',
                          icon: Icons.person,
                          color: Colors.lightBlue,
                          onTap: () {
                            print('Otwórz Uzupełnij swój profil');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointment(
      AppointmentsViewModel appointmentsViewModel) {
    if (appointmentsViewModel.appointments.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Brak zaplanowanych wizyt'),
        ),
      );
    }

    final appointment = appointmentsViewModel.appointments.first;
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
          onCancel: () => _showCancelDialog(
            context,
            appointment.id!,
            appointment.doctorId!,
            appointment.slotId!,
          ),
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, String appointmentId,
      String doctorId, String slotId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Potwierdź anulowanie'),
        content: const Text('Czy na pewno chcesz anulować tę wizytę?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Nie'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              final appointmentsViewModel =
                  Provider.of<AppointmentsViewModel>(context, listen: false);
              final slotViewModel =
                  Provider.of<SlotViewModel>(context, listen: false);
              appointmentsViewModel.cancelAppointment(
                appointmentId,
                doctorId,
                slotId,
                slotViewModel,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Tak'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: onTap,
        splashColor: color.withOpacity(0.3),
        highlightColor: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.2),
                radius: 28,
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
