import 'package:flutter/material.dart';
import 'package:medical_app/data/viewmodels/appointments_viewmodel.dart';
import 'package:medical_app/data/viewmodels/user_vievmodel.dart';
import 'package:medical_app/presentation/widgets/inputs/search_input.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/presentation/widgets/appointment_card.dart';
import 'package:medical_app/presentation/widgets/navigation_bar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  String capitalize(String name) {
    if (name.isEmpty) {
      return name;
    }
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  String capitalizeFullName(String fullName) {
    return fullName
        .split(' ')
        .map((word) => capitalize(word))
        .join(' '); // Obsługa każdego słowa z osobna
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsViewModel = Provider.of<AppointmentsViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                userViewModel.currentUser != null
                    ? capitalizeFullName(
                        'Witaj ${userViewModel.currentUser!.firstName}')
                    : 'Witaj, Gościu', // Tekst domyślny, jeśli użytkownik nie jest zalogowany
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigation(
                      initialPageIndex: 2,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blueGrey,
                backgroundImage: userViewModel.currentUser?.avatarUrl != null
                    ? NetworkImage(userViewModel.currentUser!.avatarUrl!)
                    : null,
                child: userViewModel.currentUser?.avatarUrl == null
                    ? Text(
                        '${userViewModel.currentUser?.firstName[0] ?? 'U'}${userViewModel.currentUser?.lastName[0] ?? 'N'}', // Inicjały użytkownika
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Główna zawartość dashboardu
          Padding(
            padding: const EdgeInsets.only(top: 80.0), // miejsce na SearchInput
            child: ListView(
              children: [
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  color: Colors.blue[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Nadchodząca wizyta',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            appointmentsViewModel.appointments.isEmpty
                                ? Center(
                                    child: Text('Brak zarezerwowanych wizyt.'))
                                : AppointmentCard(
                                    appointment: appointmentsViewModel
                                        .appointments.first,
                                    onCancel: () {
                                      appointmentsViewModel.cancelAppointment(
                                          appointmentsViewModel
                                              .appointments.first.id);
                                    },
                                  ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '#ODWOLUJE #NIEBLOKUJE',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '1,3 mln nieodwołanych wizyt lekarskich na NFZ w 2023r.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Jeźeli nie mozesz przyjść na wizytę, możesz ją odwołać lub przełożyć i zwolnić miejsce dla innego pacjenta. Zatrzymaj licznik nieodwołanych wizyt.',
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {},
                            child: Text('Odwołaj wizytę'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.lightBlue,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {},
                            child: Text('Przełóż wizytę'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // SearchInput na pierwszym planie
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchInput(),
            ),
          ),
        ],
      ),
    );
  }
}
