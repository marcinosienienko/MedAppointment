import 'package:flutter/material.dart';
import '../../data/models/doctor.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(doctor.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctor.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(doctor.description ?? 'Brak opisu'),
            const SizedBox(height: 16),
            Text(
              'Dostępne sloty:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Expanded(
              child: doctor.slots != null && doctor.slots!.isNotEmpty
                  ? ListView.builder(
                      itemCount: doctor.slots!.length,
                      itemBuilder: (context, index) {
                        final slot = doctor.slots![index];
                        return ListTile(
                          title: Text('Data: ${slot.date}'),
                          subtitle: Text(
                              'Godziny: ${slot.startTime} - ${slot.endTime}'),
                          trailing: Text(slot.status),
                        );
                      },
                    )
                  : Center(
                      child: Text('Brak slotów dla tego lekarza.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
