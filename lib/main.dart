import 'package:flutter/material.dart';
import 'package:medical_app/presentation/pages/dashboard_page.dart';
import 'package:medical_app/presentation/pages/login_page.dart';
import 'package:medical_app/presentation/pages/profile_page.dart';
import 'package:medical_app/presentation/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Appointments',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      //home: RegisterPage(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => DashboardPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
