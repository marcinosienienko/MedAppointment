// import 'package:flutter/material.dart';
// import 'package:medical_app/data/models/doctor_model.dart';
// import 'package:provider/provider.dart';

// class SearchDoctors extends StatelessWidget {
//   const SearchDoctors({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final doctorsViewModel = Provider.of<DoctorsViewModel>(context);
//     final SearchController searchController = SearchController();

//     return SearchAnchor(
//       isFullScreen: false,
//       searchController:
//           searchController, // Podłącz SearchController do SearchAnchor
//       viewBackgroundColor: Colors.white,
//       viewShape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(4.0),
//       ),
//       builder: (BuildContext context, SearchController controller) {
//         return GestureDetector(
//           onTap: () => {controller.openView()}, // Otwórz widok po kliknięciu.
//           child: TextField(
//             autofocus: true,
//             controller: searchController, // Użyj SearchController
//             decoration: InputDecoration(
//               prefixIcon: const Icon(Icons.search, color: Colors.grey),
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.clear, color: Colors.grey),
//                 onPressed: () {
//                   searchController.clear(); // Wyczyść tekst
//                   doctorsViewModel.updateQuery('');
//                   controller.closeView(null); // Zamknij widok
//                 },
//               ),
//               hintText: 'Wyszukaj lekarza',
//               filled: true,
//               fillColor: Colors.white,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//             onChanged: (query) {
//               doctorsViewModel.updateQuery(query);
//               if (query.isNotEmpty) {
//                 controller.openView(); // Otwórz widok
//               } else {
//                 controller.closeView(null); // Zamknij widok
//               }
//             },
//           ),
//         );
//       },
//       suggestionsBuilder:
//           (BuildContext context, SearchController controller) async {
//         final List<Doctor> doctors = doctorsViewModel.filteredDoctors;

//         if (doctors.isEmpty) {
//           return [
//             const Center(
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text('Brak wyników', style: TextStyle(fontSize: 16)),
//               ),
//             ),
//           ];
//         }

//         return doctors.map((Doctor doctor) {
//           return Card(
//             color: Colors.white,
//             margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.blueAccent,
//                 child: Text(
//                   doctor.name[0].toUpperCase(),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ),
//               title: Text(
//                 doctor.name,
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(doctor.category),
//               onTap: () {
//                 // Zamknij widok po wyborze
//               },
//             ),
//           );
//         }).toList();
//       },
//     );
//   }
// }
