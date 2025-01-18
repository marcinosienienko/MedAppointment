import 'package:flutter/material.dart';
import 'package:medical_app/presentation/pages/dashboard_page.dart';
import 'package:medical_app/presentation/pages/appointments_page.dart';
import 'package:medical_app/presentation/pages/settings_page.dart';
import 'package:medical_app/core/theme/app_colors.dart';
import 'package:medical_app/presentation/pages/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/data/viewmodels/appointments_viewmodel.dart';

class BottomNavigation extends StatefulWidget {
  final int initialPageIndex;

  const BottomNavigation({super.key, required this.initialPageIndex});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int currentPageIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppointmentsViewModel>(context, listen: false)
          .loadAppointmentsFromPreferences();
    });
    currentPageIndex = widget.initialPageIndex; // Ustaw domyślny indeks
  }

  final List<Widget> _pages = [
    const DashboardPage(), // Dashboard
    AppointmentsPage(), // Wizyty
    const ProfilePage(), // Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: AppColors.primaryLight,
        backgroundColor: Colors.white,
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Wizyty',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outlined),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
