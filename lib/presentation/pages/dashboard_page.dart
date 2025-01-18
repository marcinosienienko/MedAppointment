import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/viewmodels/doctor_viewmodel.dart';
import '../../presentation/widgets/search_bar.dart';
import '../../presentation/widgets/search_results.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final doctorViewModel = Provider.of<DoctorViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Column(
        children: [
          // Pasek wyszukiwania
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MainSearchBar(
              searchController: doctorViewModel.searchController,
              currentText: doctorViewModel.searchController.text,
              onClear: () {
                doctorViewModel.clearSearch(); // Czyszczenie wyników
              },
              onChanged: (query) {
                doctorViewModel.searchDoctors(query); // Filtrowanie wyników
              },
            ),
          ),
          // Wyniki wyszukiwania - renderowane tylko, gdy użytkownik wpisuje tekst
          if (doctorViewModel.searchController.text.isNotEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SearchResults(
                  doctors: doctorViewModel.filteredDoctors,
                ),
              ),
            )
          else
            const SizedBox.shrink(), // Ukryj, gdy nie wpisano tekstu
        ],
      ),
    );
  }
}
