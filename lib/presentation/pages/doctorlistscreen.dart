// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../data/viewmodels/doctor_viewmodel.dart';
// import 'doctorlistscreen1.dart';

// class DoctorListScreen extends StatefulWidget {
//   @override
//   _DoctorListScreenState createState() => _DoctorListScreenState();
// }

// class _DoctorListScreenState extends State<DoctorListScreen> {
//   late Future<void> _fetchDoctorsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _fetchDoctorsFuture =
//         Provider.of<DoctorViewModel>(context, listen: false).fetchDoctors();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final doctorViewModel = context.watch<DoctorViewModel>();

//     return Scaffold(
//       appBar: AppBar(title: Text('Lista Lekarzy')),
//       body: FutureBuilder(
//         future: _fetchDoctorsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Błąd: ${snapshot.error}'));
//           }

//           final doctors = doctorViewModel.doctors;

//           if (doctors.isEmpty) {
//             return Center(child: Text('Brak lekarzy do wyświetlenia.'));
//           }

//           return ListView.builder(
//             itemCount: doctors.length,
//             itemBuilder: (context, index) {
//               final doctor = doctors[index];
//               return ListTile(
//                 title: Text(doctor.name),
//                 subtitle:
//                     Text(doctor.specialization?.name ?? 'Brak specjalizacji'),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DoctorDetailsScreen(doctor: doctor),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
