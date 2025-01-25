import 'package:flutter/material.dart';

class PrescriptionsPage extends StatefulWidget {
  @override
  _PrescriptionsPageState createState() => _PrescriptionsPageState();
}

class _PrescriptionsPageState extends State<PrescriptionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> mockPrescriptions = [
    {
      'userId': '1',
      'doctorId': 'Jan Kowalski',
      'date': '2025-01-15',
      'medications': 'Paracetamol, Ibuprofen',
      'specialization': 'Lekarz rodzinny',
      'description': 'Dawkowanie: 2x dziennie (1 x rano i 1 x wieczorem)',
      'status': 'Aktywna',
    },
    {
      'userId': '2',
      'doctorId': '2',
      'date': '2025-01-10',
      'medications': 'Amoksycylina',
      'specialization': 'Medycyna ogólna',
      'description': 'Antybiotyk na infekcję',
      'status': 'Zrealizowana',
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
        title: const Text('Recepty'),
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
          _buildPrescriptionsList('Aktywna'),
          _buildPrescriptionsList('Zrealizowana'),
          _buildPrescriptionsList('Anulowana'),
        ],
      ),
    );
  }

  Widget _buildPrescriptionsList(String status) {
    final filteredPrescriptions = mockPrescriptions
        .where((prescription) => prescription['status'] == status)
        .toList();

    if (filteredPrescriptions.isEmpty) {
      return const Center(
        child: Text('Brak recept w tej kategorii.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: filteredPrescriptions.length,
      itemBuilder: (context, index) {
        final prescription = filteredPrescriptions[index];
        return Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text('Lekarz: ${prescription['doctorId']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data: ${prescription['date']}'),
                Text('Leki: ${prescription['medications']}'),
                Text('Specjalizacja: ${prescription['specialization']}'),
                Text('Opis: ${prescription['description']}'),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    minimumSize: Size(double.infinity, 40),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    _showPrescriptionDetails(context, prescription);
                  },
                  child: const Text('Wyświetl receptę'),
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  void _showPrescriptionDetails(
      BuildContext context, Map<String, String> prescription) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: const Text('Recepta NR 2024/01/01/1222'),
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
                      'Lekarz: ${prescription['doctorId']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Data: ${prescription['date']}'),
                    const SizedBox(height: 8),
                    Text('Leki: ${prescription['medications']}'),
                    const SizedBox(height: 8),
                    Text('Specjalizacja: ${prescription['specialization']}'),
                    const SizedBox(height: 8),
                    Text('Opis: ${prescription['description']}'),
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
