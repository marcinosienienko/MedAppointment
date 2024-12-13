import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/data/viewmodels/appointments_viewmodel.dart';
import 'package:medical_app/presentation/pages/appointments_page.dart';
import 'package:medical_app/presentation/pages/login_page.dart';
import 'package:medical_app/presentation/pages/profile_page.dart';
import 'package:medical_app/presentation/pages/register_page.dart';
import 'package:medical_app/presentation/widgets/navigation_bar.dart';
import 'package:medical_app/core/theme/app_colors.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppointmentsViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Appointments',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => const BottomNavigation(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
