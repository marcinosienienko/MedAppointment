import 'package:flutter/material.dart';
import 'package:medical_app/data/models/doctor_model.dart';

class SearchResults extends StatelessWidget {
  final List<Doctor> doctors;
  final ValueChanged<Doctor> onDoctorTap;

  const SearchResults({
    super.key,
    required this.doctors,
    required this.onDoctorTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doctor = doctors[index];
            return ListTile(
              title: Text(doctor.name),
              subtitle: Text(doctor.specialization),
              onTap: () => onDoctorTap(doctor),
            );
          },
        ),
      ),
    );
  }
}
