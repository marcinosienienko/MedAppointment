import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/presentation/widgets/filter_choice_chip.dart';
import 'package:medical_app/data/viewmodels/appointments_viewmodel.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppointmentsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wizyty'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilterChoiceChip(
                label: 'Nadchodzące',
                selected: true,
                count: viewModel.upcomingAppointments.length,
                onSelected: (bool selected) {
                  // Logika zmiany stanu
                },
              ),
              FilterChoiceChip(
                label: 'Zakończone',
                selected: false,
                count: viewModel.completedAppointments.length,
                onSelected: (bool selected) {
                  // Logika zmiany stanu
                },
              ),
              FilterChoiceChip(
                label: 'Odwołane',
                selected: false,
                count: viewModel.cancelledAppointments.length,
                onSelected: (bool selected) {
                  // Logika zmiany stanu
                },
              ),
            ],
          ),
          // Reszta ciała ekranu
        ],
      ),
    );
  }
}
