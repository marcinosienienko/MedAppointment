import 'package:flutter/material.dart';
import 'package:medical_app/data/models/doctor_model.dart';
import 'package:medical_app/data/viewmodels/doctor_viewmodel.dart';
import 'package:medical_app/presentation/pages/doctor_details_page.dart';
import 'package:provider/provider.dart';

class SearchInput2 extends StatefulWidget {
  SearchInput2({super.key});

  @override
  State<SearchInput2> createState() => _SearchInput2State();
}

class _SearchInput2State extends State<SearchInput2> {
  final TextEditingController _searchController = TextEditingController();
  String _currentText =
      ''; // Przechowuje aktualną wartość wpisaną przez użytkownika

  @override
  Widget build(BuildContext context) {
    final doctorsViewModel = Provider.of<DoctorsViewModel>(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
        _clearSearch(doctorsViewModel);
      },
      child: Column(
        children: [
          // Pole wyszukiwania
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.blue),
              ),
              prefixIcon: _currentText.isNotEmpty
                  ? null
                  : const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _currentText.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _clearSearch(doctorsViewModel);
                      },
                    )
                  : null,
              hintText: 'Wyszukaj lekarza',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey),
              ),
              contentPadding: _currentText.isNotEmpty
                  ? const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0)
                  : const EdgeInsets.only(
                      left: 48.0, right: 16.0, top: 15.0, bottom: 15.0),
            ),
            onChanged: (value) {
              setState(() {
                _currentText = value; // Aktualizuje wartość tekstu
              });
              doctorsViewModel.updateQuery(value);
            },
          ),
          // Lista wyników
          if (_currentText.isNotEmpty &&
              doctorsViewModel.filteredDoctors.isNotEmpty)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
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
                        onTap: () {
                          _clearSearch(doctorsViewModel);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DoctorDetailsPage(doctor: doctor),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _clearSearch(DoctorsViewModel doctorsViewModel) {
    _searchController.clear(); // Czyści pole tekstowe
    setState(() {
      _currentText = ''; // Resetuje tekst w stanie
    });
    doctorsViewModel.updateQuery(''); // Czyści wyniki wyszukiwania
  }
}
