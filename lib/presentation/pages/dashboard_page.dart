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

                  // Karty na ekranie głównym
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    child: Column(
                      children: [
                        _buildDashboardCard(
                          title: 'Nadchodzące wizyty',
                          subtitle: 'Sprawdź i zarządzaj swoimi wizytami.',
                          icon: Icons.calendar_today,
                          color: Colors.blue,
                          onTap: () {
                            print('Otwórz Nadchodzące wizyty');
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
