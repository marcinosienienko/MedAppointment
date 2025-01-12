import 'package:flutter/material.dart';
import 'package:medical_app/data/models/user_model.dart';
import 'package:medical_app/data/viewmodels/appointments_viewmodel.dart';
import 'package:medical_app/presentation/widgets/inputs/search_input.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/data/models/appointment_model.dart';
import 'package:medical_app/presentation/widgets/appointment_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentsViewModel = Provider.of<AppointmentsViewModel>(context);

    final user = UserModel(
      id: '1',
      email: 'jan.kowalski@example.com',
      firstName: 'Jan',
      lastName: 'Kowalski',
      phoneNumber: '1234567890',
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Witaj, ${user.firstName} ${user.lastName}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blueGrey,
                backgroundImage: user.avatarUrl != null
                    ? NetworkImage(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null
                    ? Text(
                        '${user.firstName[0]}${user.lastName[0]}',
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
