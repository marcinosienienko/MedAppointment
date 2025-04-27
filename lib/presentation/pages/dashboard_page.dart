import 'package:flutter/material.dart';
import 'package:medical_app/presentation/widgets/dashboard_cards.dart';
import 'package:medical_app/presentation/widgets/inputs/dashboard_banner.dart';
import 'package:provider/provider.dart';
import '../../data/viewmodels/doctor_viewmodel.dart';
import '../../data/viewmodels/appointments_viewmodel.dart';
import '../../data/viewmodels/user_viewmodel.dart';
import '../../presentation/widgets/search_bar.dart';
import '../../presentation/widgets/search_results.dart';
import '../../presentation/widgets/appointment_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
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
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: userViewModel.currentUser != null
            ? Text('Witaj, ${userViewModel.currentUser!.firstName}!')
            : const Text('Witaj!'),
      ),
      body: Column(
        children: [
          // Pasek wyszukiwania
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MainSearchBar(
              searchController: doctorViewModel.searchController,
              currentText: doctorViewModel.searchController.text,
              onClear: () => doctorViewModel.clearSearch(),
              onChanged: (query) => doctorViewModel.searchDoctors(query),
              autofocus: false,
            ),
          ),

          // Wyniki wyszukiwania lub dashboard
          Expanded(
            child: doctorViewModel.searchController.text.isNotEmpty
                ? SearchResults(doctors: doctorViewModel.filteredDoctors)
                : _buildDashboardContent(appointmentsViewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(AppointmentsViewModel appointmentsViewModel) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            const BanerWidget(),
            const SizedBox(height: 16.0),
            _buildUpcomingAppointment(appointmentsViewModel),
            const SizedBox(height: 16.0),
            const DashboardCards(),
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
    return AppointmentCard(
      appointment: appointment,
      onCancel: () => {},
    );
  }
}
