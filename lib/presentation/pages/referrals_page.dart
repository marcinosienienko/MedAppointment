import 'package:flutter/material.dart';

class ReferralsPage extends StatefulWidget {
  @override
  _ReferralsPageState createState() => _ReferralsPageState();
}

class _ReferralsPageState extends State<ReferralsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> mockReferrals = [
    {
      'userId': '1',
      'doctorId': 'Jan Kowalski',
      'date': '2025-01-15',
      'specialization': 'Kardiologia',
      'description': 'Skierowanie na badania serca.',
      'appointmentId': '123',
      'status': 'Aktywne',
    },
    {
      'userId': '2',
      'doctorId': 'Anna Nowak',
      'date': '2025-01-10',
      'specialization': 'Ortopedia',
      'description': 'Skierowanie na prześwietlenie kolana.',
      'appointmentId': '124',
      'status': 'Zrealizowane',
    },
  ];

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skierowania'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          indicatorWeight: 6,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Aktywne', icon: Icon(Icons.check_circle_outline)),
            Tab(text: 'Zrealizowane', icon: Icon(Icons.done_all)),
            Tab(text: 'Anulowane', icon: Icon(Icons.cancel_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReferralsList('Aktywne'),
          _buildReferralsList('Zrealizowane'),
          _buildReferralsList('Anulowane'),
        ],
      ),
    );
  }

  Widget _buildReferralsList(String status) {
    final filteredReferrals = mockReferrals
        .where((referral) => referral['status'] == status)
        .toList();

    if (filteredReferrals.isEmpty) {
      return const Center(
        child: Text('Brak skierowań w tej kategorii.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: filteredReferrals.length,
      itemBuilder: (context, index) {
        final referral = filteredReferrals[index];
        return Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text('Lekarz: ${referral['doctorId']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data: ${referral['date']}'),
                Text('Specjalizacja: ${referral['specialization']}'),
                Text('Opis: ${referral['description']}'),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0), // Dodaj padding po bokach
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              minimumSize: const Size(double.infinity,
                                  40), // Wypełnij całą szerokość
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              _showReferralDetails(context, referral);
                            },
                            child: const Text('Wyświetl skierowanie'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  void _showReferralDetails(
      BuildContext context, Map<String, String> referral) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: const Text('Skierowanie NR 2025/01/15/12'),
                automaticallyImplyLeading: false,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lekarz: ${referral['doctorId']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Data: ${referral['date']}'),
                    const SizedBox(height: 8),
                    Text('Specjalizacja: ${referral['specialization']}'),
                    const SizedBox(height: 8),
                    Text('Opis: ${referral['description']}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
