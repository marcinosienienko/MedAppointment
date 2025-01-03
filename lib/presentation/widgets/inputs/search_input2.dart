import 'package:flutter/material.dart';
import 'package:medical_app/data/models/doctor_model.dart';
import 'package:medical_app/data/viewmodels/doctor_viewmodel.dart';
import 'package:medical_app/presentation/pages/doctor_details_page.dart';
import 'package:provider/provider.dart';

class SearchInput2 extends StatelessWidget {
  SearchInput2({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final doctorsViewModel = Provider.of<DoctorsViewModel>(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
        _searchController.clear();
        doctorsViewModel.updateQuery('');
      },
      child: Column(
        children: [
          // Pole wyszukiwania
          Container(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    doctorsViewModel.updateQuery('');
                  },
                ),
                hintText: 'Search',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                doctorsViewModel.updateQuery(value);
              },
            ),
          ),
          // Lista wyników
          if (doctorsViewModel.query.isNotEmpty &&
              doctorsViewModel.filteredDoctors.isNotEmpty)
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: doctorsViewModel.filteredDoctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctorsViewModel.filteredDoctors[index];
                    return ListTile(
                      title: Text(doctor.name),
                      subtitle: Text(doctor.category),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DoctorDetailsPage(doctor: doctor),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
