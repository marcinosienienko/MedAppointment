// import 'package:flutter/material.dart';
// import 'package:medical_app/data/viewmodels/doctor_viewmodel.dart';
// import 'package:medical_app/presentation/pages/doctor_details_page.dart';
// import 'package:medical_app/presentation/widgets/search_bar.dart';
// import 'package:medical_app/presentation/widgets/search_results.dart';
// import 'package:provider/provider.dart';

// class SearchInput extends StatefulWidget {
//   SearchInput({super.key});

//   @override
//   State<SearchInput> createState() => _SearchInput2State();
// }

// class _SearchInput2State extends State<SearchInput> {
//   final TextEditingController _searchController = TextEditingController();
//   String _currentText = '';

//   @override
//   Widget build(BuildContext context) {
//     final doctorsViewModel = Provider.of<DoctorsViewModel>(context);

//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () {
//         FocusScope.of(context).unfocus();
//         _clearSearch(doctorsViewModel);
//       },
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           MainSearchBar(
//             searchController: _searchController,
//             currentText: _currentText,
//             onClear: () => _clearSearch(doctorsViewModel),
//             onChanged: (value) {
//               setState(() {
//                 _currentText = value;
//               });
//               doctorsViewModel.updateQuery(value);
//             },
//           ),
//           if (_currentText.isNotEmpty &&
//               doctorsViewModel.filteredDoctors.isNotEmpty)
//             Flexible(
//               fit: FlexFit.loose,
//               child: SearchResults(
//                 doctors: doctorsViewModel.filteredDoctors,
//                 onDoctorTap: (doctor) {
//                   _clearSearch(doctorsViewModel);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DoctorDetailsPage(doctor: doctor),
//                     ),
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   void _clearSearch(DoctorsViewModel doctorsViewModel) {
//     _searchController.clear();
//     setState(() {
//       _currentText = '';
//     });
//     doctorsViewModel.updateQuery('');
//   }
// }
